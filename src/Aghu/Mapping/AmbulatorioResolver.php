<?php

declare(strict_types=1);

namespace App\Aghu\Mapping;

use App\Aghu\Config\AghuServicoConfig;
use App\Aghu\Dto\ChamadaResolvida;
use App\Aghu\Dto\ConsultaAghu;

/**
 * Resolve uma consulta do AGHU para o serviço de destino no NovoSGA.
 *
 * A resolução é feita pelo código do ambulatório de origem (de-para configurável
 * em {@see AghuServicoConfig}). Se não houver serviço habilitado para aquele
 * código, devolve null (a consulta é ignorada — nunca quebra).
 */
final class AmbulatorioResolver
{
    public function __construct(
        private readonly AghuServicoConfig $config,
    ) {
    }

    public function resolve(ConsultaAghu $consulta): ?ChamadaResolvida
    {
        $servico = $this->config->getServicoByAmbulatorio($consulta->ambulatorioOrigem);
        if ($servico === null) {
            return null;
        }

        return new ChamadaResolvida($consulta, $servico);
    }
}
