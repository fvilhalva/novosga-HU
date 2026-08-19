<?php

declare(strict_types=1);

namespace App\Aghu\Source;

use App\Aghu\Dto\ConsultaAghu;
use DateTimeImmutable;

/**
 * Implementação-stub da fonte do AGHU: devolve consultas fixas de exemplo.
 *
 * Serve para exercitar a integração (resolver + sink + command) sem acesso ao
 * AGHU. Será substituída pela implementação DBAL read-only real depois — basta
 * trocar o binding da {@see AghuAgendaSourceInterface} em services.yaml.
 */
final class StubAghuAgendaSource implements AghuAgendaSourceInterface
{
    public function getConsultas(): array
    {
        return [
            new ConsultaAghu(
                idExterno: 'stub-1001',
                pacienteNome: 'Maria da Silva',
                ambulatorioOrigem: 'AMB1',
                situacao: 'chamado',
                sala: '3',
                chamadoEm: new DateTimeImmutable(),
            ),
            new ConsultaAghu(
                idExterno: 'stub-1002',
                pacienteNome: 'João de Souza',
                ambulatorioOrigem: 'AMB2',
                situacao: 'agendado',
                sala: '5',
            ),
        ];
    }
}
