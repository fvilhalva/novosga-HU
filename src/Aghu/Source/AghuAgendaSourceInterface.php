<?php

declare(strict_types=1);

namespace App\Aghu\Source;

use App\Aghu\Dto\ConsultaAghu;

/**
 * Fonte da agenda do AGHU (read-only).
 *
 * Esta é a costura onde a leitura REAL do AGHU (query DBAL somente leitura)
 * entra depois. Por enquanto o binding padrão aponta para o
 * {@see StubAghuAgendaSource}, permitindo montar e testar toda a integração
 * sem acesso ao banco do AGHU.
 */
interface AghuAgendaSourceInterface
{
    /**
     * Consultas relevantes do dia (já normalizadas em {@see ConsultaAghu}).
     *
     * @return list<ConsultaAghu>
     */
    public function getConsultas(): array;
}
