<?php
/**
 * Emissor de token JWT de curta duração para o painel de senhas.
 *
 * O painel (executado no navegador) precisa autenticar no serviço HU-Speaker,
 * que exige um JWT HS256. Em vez de embutir um token fixo/longo no front-end
 * (inseguro e que expira), o painel busca aqui um token novo e curto a cada uso.
 *
 * O segredo (JWT_SECRET_KEY) fica NO SERVIDOR, lido de variável de ambiente,
 * e deve ser IDÊNTICO ao usado pelo HU-Speaker. Nunca é enviado ao navegador.
 *
 * Endpoint: GET /painel-token.php  ->  { "token": "<jwt>", "expires_in": 300 }
 */

// ---- CORS: permite que o painel (outra origem, ex.: http://localhost:9000) consuma ----
$allowedOrigins = array(
    'http://localhost:9000',
    'http://127.0.0.1:9000',
);
$origin = isset($_SERVER['HTTP_ORIGIN']) ? $_SERVER['HTTP_ORIGIN'] : '';
if (in_array($origin, $allowedOrigins, true)) {
    header('Access-Control-Allow-Origin: ' . $origin);
    header('Vary: Origin');
}
header('Access-Control-Allow-Methods: GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

// Responde o preflight
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(204);
    exit;
}

header('Content-Type: application/json; charset=utf-8');
header('Cache-Control: no-store');

// ---- Segredo compartilhado (mesmo do HU-Speaker) ----
$secret = getenv('JWT_SECRET_KEY');
if ($secret === false || $secret === '' || $secret === 'changeme-set-in-host-env') {
    http_response_code(500);
    echo json_encode(array('error' => 'JWT_SECRET_KEY nao configurado no servidor'));
    exit;
}

// ---- Geração do JWT HS256 (sem bibliotecas) ----
function base64UrlEncode($data)
{
    return rtrim(strtr(base64_encode($data), '+/', '-_'), '=');
}

$now = time();
$ttl = 300; // 5 minutos

$header = array('alg' => 'HS256', 'typ' => 'JWT');
$payload = array(
    'sub'           => 'novosga-panel',
    'source_system' => 'novosga',
    'iat'           => $now,
    'exp'           => $now + $ttl,
);

$segments = array(
    base64UrlEncode(json_encode($header)),
    base64UrlEncode(json_encode($payload)),
);
$signingInput = implode('.', $segments);
$signature = hash_hmac('sha256', $signingInput, $secret, true);
$segments[] = base64UrlEncode($signature);

$jwt = implode('.', $segments);

echo json_encode(array(
    'token'      => $jwt,
    'expires_in' => $ttl,
));
