<?php

declare(strict_types=1);

namespace Novosga\Settings;

/**
 * Minimal compatibility class for painel settings.
 * The real implementation lives in the upstream Novosga packages;
 * this placeholder prevents runtime class-not-found errors in local dev.
 */
class PainelSettings
{
    // Properties referenced by the painel template.
    public ?string $corFundoDestaque = null;
    public ?string $corFundoRodape = null;
    public ?string $corFundoHistorico = null;
    public ?string $corFundoRelogio = null;
    public ?string $logo = null;
}
