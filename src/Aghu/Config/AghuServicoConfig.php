<?php

declare(strict_types=1);

namespace App\Aghu\Config;

use App\Entity\ServicoMeta;
use Doctrine\ORM\EntityManagerInterface;
use Novosga\Entity\ServicoInterface;

/**
 * Config da integração AGHU por serviço, guardada em ServicoMeta (sem migration).
 *
 * Chaves (namespace "aghu"):
 *   - enabled      (bool)   → o serviço é alimentado pelo AGHU
 *   - ambulatorio  (string) → código do ambulatório de origem no AGHU
 *
 * O de-para é agnóstico a id fixo: qualquer serviço marcado como habilitado e
 * mapeado a um código vira destino — não depende de "Ambulatório 1/2" existirem
 * nem da unidade em que o serviço está.
 */
final class AghuServicoConfig
{
    public const NAMESPACE = 'aghu';
    public const KEY_ENABLED = 'enabled';
    public const KEY_AMBULATORIO = 'ambulatorio';

    public function __construct(
        private readonly EntityManagerInterface $em,
    ) {
    }

    /**
     * Encontra o serviço habilitado cujo código de ambulatório casa com $codigo.
     */
    public function getServicoByAmbulatorio(string $codigo): ?ServicoInterface
    {
        foreach ($this->getConfiguracoes() as $cfg) {
            if ($cfg['enabled'] && $cfg['ambulatorio'] !== null && $cfg['ambulatorio'] === $codigo) {
                return $cfg['servico'];
            }
        }

        return null;
    }

    /**
     * @return list<ServicoInterface>
     */
    public function getServicosHabilitados(): array
    {
        $servicos = [];
        foreach ($this->getConfiguracoes() as $cfg) {
            if ($cfg['enabled']) {
                $servicos[] = $cfg['servico'];
            }
        }

        return $servicos;
    }

    /**
     * Carrega e agrupa as metas do namespace "aghu" por serviço.
     *
     * @return list<array{servico: ServicoInterface, enabled: bool, ambulatorio: ?string}>
     */
    private function getConfiguracoes(): array
    {
        /** @var list<ServicoMeta> $metas */
        $metas = $this->em
            ->createQueryBuilder()
            ->select('m')
            ->from(ServicoMeta::class, 'm')
            ->where('m.namespace = :ns')
            ->setParameter('ns', self::NAMESPACE)
            ->getQuery()
            ->getResult();

        /** @var array<int, array{servico: ServicoInterface, enabled: bool, ambulatorio: ?string}> $porServico */
        $porServico = [];
        foreach ($metas as $meta) {
            $servico = $meta->getEntity();
            if (!$servico instanceof ServicoInterface) {
                continue;
            }
            $id = (int) $servico->getId();
            $porServico[$id] ??= ['servico' => $servico, 'enabled' => false, 'ambulatorio' => null];

            if ($meta->getName() === self::KEY_ENABLED) {
                $porServico[$id]['enabled'] = (bool) $meta->getValue();
            } elseif ($meta->getName() === self::KEY_AMBULATORIO) {
                $value = $meta->getValue();
                $porServico[$id]['ambulatorio'] = $value === null ? null : (string) $value;
            }
        }

        return array_values($porServico);
    }
}
