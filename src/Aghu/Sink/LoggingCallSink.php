<?php

declare(strict_types=1);

namespace App\Aghu\Sink;

use App\Aghu\Dto\ChamadaResolvida;
use Psr\Log\LoggerInterface;

/**
 * SINK dry-run: apenas registra o que SERIA feito, sem escrever no banco.
 *
 * É o binding padrão enquanto a escrita real (senha + voz via serviços nativos)
 * não é implementada, garantindo que rodar o sync nunca altere dados.
 */
final class LoggingCallSink implements AmbulatorioCallSinkInterface
{
    public function __construct(
        private readonly LoggerInterface $logger,
    ) {
    }

    public function anunciar(ChamadaResolvida $chamada): void
    {
        $consulta = $chamada->consulta;
        $this->logger->info('[aghu][dry-run] chamada resolvida', [
            'id_externo' => $consulta->idExterno,
            'paciente' => $consulta->pacienteNome,
            'servico' => $chamada->servico->getNome(),
            'servico_id' => $chamada->servico->getId(),
            'sala' => $consulta->sala,
            'situacao' => $consulta->situacao,
        ]);
    }
}
