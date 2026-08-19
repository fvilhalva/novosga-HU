<?php

declare(strict_types=1);

namespace App\Aghu\Sink;

use App\Aghu\Dto\ChamadaResolvida;

/**
 * Destino de uma chamada resolvida: o que efetivamente acontece no NovoSGA.
 *
 * Esta é a costura da ESCRITA. A implementação real (criar/atualizar a senha via
 * AtendimentoService nativo, marcar como chamada e disparar a voz) entra depois,
 * atrás desta interface. Por enquanto o binding padrão é o {@see LoggingCallSink}
 * (dry-run), que não toca o banco.
 */
interface AmbulatorioCallSinkInterface
{
    public function anunciar(ChamadaResolvida $chamada): void;
}
