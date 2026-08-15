<?php

declare(strict_types=1);

/*
 * This file is part of the NovoSGA project.
 *
 * (c) Rogerio Lino <rogeriolino@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

namespace App\Controller;

use App\Entity\Painel;
use App\Entity\PainelSenha;
use Doctrine\ORM\EntityManagerInterface;
use Novosga\Entity\PainelServicoInterface;
use Novosga\Entity\ServicoInterface;
use Novosga\Service\PainelServiceInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\DependencyInjection\ParameterBag\ParameterBagInterface;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\DependencyInjection\Attribute\Autowire;
use Symfony\Contracts\HttpClient\HttpClientInterface;
use Lcobucci\JWT\Configuration;
use Lcobucci\JWT\Signer\Hmac\Sha256;
use Lcobucci\JWT\Signer\Key\InMemory;

/**
 * PainelController
 *
 * @author Rogerio Lino <rogeriolino@gmail.com>
 */
#[Route('/painel', name: 'painel_')]
class PainelController extends AbstractController
{
    #[Route('/{publicId:painel}', name: 'show', methods: ['GET'])]
    public function show(
        Painel $painel,
        ParameterBagInterface $params,
        PainelServiceInterface $painelService,
    ): Response {

        return $this->render('painel/show.html.twig', [
            'painel' => $painel,
            'mercureUrl' => $params->get('mercure_url'),
            'settings' => $painelService->loadSettings($painel),
        ]);
    }

    #[Route('/{publicId:painel}/data', name: 'data', methods: ['GET'])]
    public function data(
        Painel $painel,
        EntityManagerInterface $em,
    ): Response {
        $servicos = $painel
            ->getServicos()
            ->map(fn (PainelServicoInterface $ps) => $ps->getServico())
            ->map(fn (ServicoInterface $s) => $s->getId())
            ->toArray();

        $senhas = $em
            ->createQueryBuilder()
            ->select(['e', 's'])
            ->from(PainelSenha::class, 'e')
            ->join('e.servico', 's')
            ->where('e.unidade = :unidade')
            ->andWhere('s.id IN (:servicos)')
            ->orderBy('e.id', 'DESC')
            ->setParameter('unidade', $painel->getUnidade())
            ->setParameter('servicos', $servicos)
            ->setMaxResults(10)
            ->getQuery()
            ->getResult();

        return $this->json($senhas);
    }
    #[Route('/{publicId:painel}/voz/{senha}', name: 'voz', methods: ['GET'])]
    public function voz(
        Painel $painel,
        PainelSenha $senha,
        HttpClientInterface $http,
        #[Autowire('%env(HU_SPEAKER_URL)%')] string $huUrl,
        #[Autowire('%env(HU_SPEAKER_JWT_SECRET)%')] string $huSecret,
    ): Response {
        // segurança: a senha tem que pertencer à unidade do painel
        if ($senha->getUnidade()?->getId() !== $painel->getUnidade()?->getId()) {
            throw $this->createNotFoundException();
        }

        // 1) monta o texto falado
        $soletrada = trim((string) preg_replace('/(.)/u', '$1 ', $senha->getSenhaFormatada()));
        $numeroPad = str_pad((string) $senha->getNumeroLocal(), 2, '0', STR_PAD_LEFT);
        $numeroLocal = trim((string) preg_replace('/(.)/u', '$1 ', $numeroPad));
        $nome = trim((string) ($senha->getNomeCliente() ?? ''));

        if ($nome !== '') {
            $texto = sprintf(
                'Atenção! %s. Senha %s. Compareça ao %s %s.',
                $nome,
                $soletrada,
                $senha->getLocal(),
                $numeroLocal,
            );
        } else {
            $texto = sprintf(
                'Atenção pacientes! Senha %s. Compareça ao %s %s.',
                $soletrada,
                $senha->getLocal(),
                $numeroLocal,
            );
        }

        // 2) assina o JWT HS256 (HU-Speaker exige claims sub + exp)
        $config = Configuration::forSymmetricSigner(new Sha256(), InMemory::plainText($huSecret));
        $now = new \DateTimeImmutable();
        $jwt = $config->builder()
            ->relatedTo('novosga-service')              // sub
            ->issuedAt($now)
            ->expiresAt($now->modify('+2 minutes'))     // exp
            ->withClaim('source_system', 'novosga')
            ->withClaim('actor_id', (string) $senha->getId())
            ->withClaim('actor_name', $senha->getNomeCliente() ?? '')
            ->getToken($config->signer(), $config->signingKey())
            ->toString();

        $headers = ['Authorization' => 'Bearer ' . $jwt];

        // 3) sintetiza
        $syn = $http->request('POST', $huUrl . '/speak/synthesize', [
            'headers' => $headers,
            'json' => ['text' => $texto, 'language' => 'pt_BR', 'length_scale' => 1.6],
        ])->toArray();

        // 4) baixa o wav e repassa (proxy) — segredo nunca sai do servidor
        $wav = $http->request('GET', $huUrl . '/speak/download/' . $syn['id'], [
            'headers' => $headers,
        ])->getContent();

        return new Response($wav, 200, [
            'Content-Type' => 'audio/wav',
            'Cache-Control' => 'no-store',
        ]);
    }
}
