<?php

declare(strict_types=1);

namespace App\Controller;

use App\Service\HuSpeakerClient;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

/**
 * Endpoint de teste de voz usado pelo botão "Testar voz" do formulário de
 * painel. Fica fora do prefixo público "/painel" (portanto exige login) para
 * não expor a síntese a qualquer visitante.
 */
class VozTesteController extends AbstractController
{
    #[Route('/voz-teste', name: 'painel_voz_teste', methods: ['GET'])]
    public function testar(Request $request, HuSpeakerClient $huSpeaker): Response
    {
        $modelosValidos = ['piper', 'kokoro'];
        $modelo = (string) $request->query->get('model', 'piper');
        if (!in_array($modelo, $modelosValidos, true)) {
            $modelo = 'piper';
        }

        $velocidade = (float) $request->query->get('velocidade', '1.6');
        // mesmo intervalo aceito pelo HU-Speaker
        $velocidade = max(0.5, min(2.0, $velocidade));

        // "falar nome" espelha a opção do painel: com nome vs. frase alternativa.
        $falarNome = $request->query->getBoolean('falar_nome', true);
        if ($falarNome) {
            $nome = trim((string) $request->query->get('nome', 'Maria da Silva'));
            if ($nome === '') {
                $nome = 'Maria da Silva';
            }
            $nome = mb_substr($nome, 0, 80); // limite defensivo
            $texto = sprintf('Atenção! %s. Senha A zero zero um. Compareça ao guichê dois.', $nome);
        } else {
            $texto = 'Atenção pacientes! Senha A zero zero um. Compareça ao guichê dois.';
        }

        try {
            $wav = $huSpeaker->speak($texto, $velocidade, $modelo);
        } catch (\Throwable $e) {
            return new Response('Falha ao sintetizar: ' . $e->getMessage(), Response::HTTP_BAD_GATEWAY);
        }

        return new Response($wav, Response::HTTP_OK, [
            'Content-Type' => 'audio/wav',
            'Cache-Control' => 'no-store',
        ]);
    }
}
