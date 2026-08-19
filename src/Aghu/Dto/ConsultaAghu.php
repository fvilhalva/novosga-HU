<?php

declare(strict_types=1);

namespace App\Aghu\Dto;

use DateTimeImmutable;

/**
 * Consulta lida do AGHU (fonte read-only), já normalizada.
 *
 * É o contrato de saída do SOURCE (a query real no AGHU entra depois, por trás
 * da {@see \App\Aghu\Source\AghuAgendaSourceInterface}); aqui só definimos os
 * campos que o restante da integração precisa — sem acoplar ao schema do AGHU.
 */
final class ConsultaAghu
{
    public function __construct(
        /** Id externo estável da consulta (aac_consultas), para idempotência. */
        public readonly string $idExterno,
        /** Nome do paciente (aip_pacientes.nome). */
        public readonly string $pacienteNome,
        /**
         * Código do ambulatório de origem no AGHU — é o que o resolver usa para
         * encontrar o serviço correspondente no NovoSGA (de-para configurável).
         */
        public readonly string $ambulatorioOrigem,
        /** Situação normalizada (ex.: agendado, chamado, em_atendimento, faltou). */
        public readonly string $situacao,
        /** Sala/consultório onde o paciente deve entrar (opcional). */
        public readonly ?string $sala = null,
        /** Documento do paciente (opcional). */
        public readonly ?string $pacienteDocumento = null,
        /** Momento da chamada pelo médico no AGHU, quando disponível. */
        public readonly ?DateTimeImmutable $chamadoEm = null,
    ) {
    }
}
