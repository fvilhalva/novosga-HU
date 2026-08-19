<?php

declare(strict_types=1);

namespace App\Command;

use App\Aghu\Mapping\AmbulatorioResolver;
use App\Aghu\Sink\AmbulatorioCallSinkInterface;
use App\Aghu\Source\AghuAgendaSourceInterface;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Style\SymfonyStyle;

/**
 * Sincroniza a agenda do AGHU com o NovoSGA (esqueleto da integração).
 *
 * Fluxo: SOURCE (lê AGHU) → RESOLVER (mapeia p/ serviço) → SINK (anuncia).
 * Com o binding padrão (stub + logging sink), rodar este comando NÃO altera o
 * banco — serve para validar a estrutura antes de plugar a query real e a
 * escrita real.
 */
#[AsCommand(
    name: 'app:aghu:sync',
    description: 'Lê a agenda do AGHU e anuncia as chamadas no NovoSGA (esqueleto).',
)]
final class AghuSyncCommand extends Command
{
    public function __construct(
        private readonly AghuAgendaSourceInterface $source,
        private readonly AmbulatorioResolver $resolver,
        private readonly AmbulatorioCallSinkInterface $sink,
    ) {
        parent::__construct();
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $io = new SymfonyStyle($input, $output);

        $consultas = $this->source->getConsultas();
        $io->text(sprintf('Consultas lidas da fonte: %d', count($consultas)));

        $anunciadas = 0;
        $ignoradas = 0;

        foreach ($consultas as $consulta) {
            $chamada = $this->resolver->resolve($consulta);
            if ($chamada === null) {
                $ignoradas++;
                $io->writeln(sprintf(
                    '  <comment>ignorada</comment>: %s (ambulatório "%s" sem serviço configurado)',
                    $consulta->pacienteNome,
                    $consulta->ambulatorioOrigem,
                ));
                continue;
            }

            $this->sink->anunciar($chamada);
            $anunciadas++;
            $io->writeln(sprintf(
                '  <info>anunciada</info>: %s → serviço "%s"',
                $consulta->pacienteNome,
                $chamada->servico->getNome(),
            ));
        }

        $io->success(sprintf('Sync concluído. Anunciadas: %d | Ignoradas: %d', $anunciadas, $ignoradas));

        return Command::SUCCESS;
    }
}
