<?php

declare(strict_types=1);

namespace App\Service;

use Firebase\JWT\JWT;
use Symfony\Contracts\HttpClient\HttpClientInterface;

/**
 * Cliente do HU-Speaker (síntese de voz).
 *
 * Monta o JWT de serviço (HS256) exigido pela API e expõe os dois passos
 * do fluxo: synthesize -> download.
 */
final class HuSpeakerClient
{
    public function __construct(
        private readonly HttpClientInterface $client,
        private readonly string $baseUrl,    // %env(HU_SPEAKER_URL)%
        private readonly string $jwtSecret,  // %env(HU_SPEAKER_JWT_SECRET)%
    ) {
    }

    /**
     * Gera o JWT de serviço que o HU-Speaker valida em require_service_jwt().
     * exp curto (2 min) porque o token é usado na hora e descartado.
     */
    private function token(
        ?string $actorId = null,
        ?string $actorName = null,
        ?string $actorRole = null,
    ): string {
        $now = time();

        $payload = array_filter([
            'sub'           => 'novosga-service',
            'source_system' => 'novosga',
            'actor_id'      => $actorId,
            'actor_name'    => $actorName,
            'actor_role'    => $actorRole,
            'request_id'    => bin2hex(random_bytes(8)),
            'iat'           => $now,
            'exp'           => $now + 120,
        ], static fn ($v) => $v !== null);

        return JWT::encode($payload, $this->jwtSecret, 'HS256');
    }

    /**
     * Passo 1: sintetiza o texto. Retorna o id da síntese.
     */
    public function synthesize(string $text, float $lengthScale = 1.6): string
    {
        $response = $this->client->request('POST', $this->baseUrl . '/speak/synthesize', [
            'auth_bearer' => $this->token(),
            'json'        => [
                'text'         => $text,
                'language'     => 'pt_BR',
                'length_scale' => $lengthScale,
            ],
            'timeout'     => 15,
        ]);

        return $response->toArray()['id'];
    }

    /**
     * Passo 2: baixa o WAV de uma síntese já criada.
     */
    public function download(string $synthesisId): string
    {
        $response = $this->client->request('GET', $this->baseUrl . '/speak/download/' . $synthesisId, [
            'auth_bearer' => $this->token(),
            'timeout'     => 15,
        ]);

        return $response->getContent();
    }

    /**
     * Atalho: sintetiza e já devolve os bytes do WAV.
     */
    public function speak(string $text, float $lengthScale = 1.0): string
    {
        return $this->download($this->synthesize($text, $lengthScale));
    }
}
