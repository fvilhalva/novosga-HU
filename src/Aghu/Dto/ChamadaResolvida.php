<?php

declare(strict_types=1);

namespace App\Aghu\Dto;

use Novosga\Entity\ServicoInterface;

/**
 * Uma consulta do AGHU já resolvida para o destino no NovoSGA.
 *
 * Produzida pelo {@see \App\Aghu\Mapping\AmbulatorioResolver} e consumida pelo
 * SINK. A resolução de unidade/local é responsabilidade do SINK real (depende
 * de como o serviço está configurado nas unidades) e por isso não é fixada aqui.
 */
final class ChamadaResolvida
{
    public function __construct(
        public readonly ConsultaAghu $consulta,
        public readonly ServicoInterface $servico,
    ) {
    }
}
