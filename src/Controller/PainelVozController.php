<?php

declare(strict_types=1);

namespace App\Controller;

use App\Service\HuSpeakerClient;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

/**
 * Entrega o WAV da convocação para o painel tocar.
 *
 * Os parâmetros vêm como query string (senha/local), NÃO como argumentos
 * tipados como entidade. Isso evita o EntityValueResolver tentar carregar
 * algo do banco e devolver 404 quando não encontra.
 */
final class PainelVozController
{
    #[Route('/painel/voz', name: 'painel_voz', methods: ['GET'])]
    public function voz(Request $request, HuSpeakerClient $speaker): Response
    {
        $senha = (string) $request->query->get('senha', '');
        $local = (string) $request->query->get('local', '');

        if ($senha === '') {
            return new Response('senha obrigatória', Response::HTTP_BAD_REQUEST);
        }

        $wav = $speaker->speak($this->frase($senha, $local));

        return new Response($wav, Response::HTTP_OK, [
            'Content-Type'  => 'audio/wav',
            'Cache-Control' => 'no-store',
        ]);
    }

    /**
     * Monta a frase falada. Soletra a senha dígito a dígito pra ficar
     * inteligível ("A001" -> "Senha A 0 0 1").
     */
    private function frase(string $senha, string $local): string
    {
        $soletrado = trim((string) preg_replace('/(\S)/u', '$1 ', $senha));
        $frase = "Senha {$soletrado}";

        if ($local !== '') {
            $frase .= ", {$local}";
        }

        return $frase;
    }
}
