<?php

declare(strict_types=1);

/*
 * This file is part of the NovoSGA project.
 *
 * (c) Rogerio Lino <rogeriolino@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Adiciona as opções de chamada por voz ao painel:
 * ativar voz, falar nome, modelo de voz e velocidade da fala.
 */
final class Version20260818000000 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Adds voice call options (voz_ativa, falar_nome, voz_modelo, voz_velocidade) to paineis table';
    }

    public function up(Schema $schema): void
    {
        $table = $schema->getTable('paineis');

        if (!$table->hasColumn('voz_ativa')) {
            $this->addSql("ALTER TABLE paineis ADD voz_ativa BOOLEAN DEFAULT true NOT NULL");
        }
        if (!$table->hasColumn('falar_nome')) {
            $this->addSql("ALTER TABLE paineis ADD falar_nome BOOLEAN DEFAULT true NOT NULL");
        }
        if (!$table->hasColumn('voz_modelo')) {
            $this->addSql("ALTER TABLE paineis ADD voz_modelo VARCHAR(20) DEFAULT 'piper' NOT NULL");
        }
        if (!$table->hasColumn('voz_velocidade')) {
            $this->addSql("ALTER TABLE paineis ADD voz_velocidade DOUBLE PRECISION DEFAULT 1.6 NOT NULL");
        }
    }

    public function down(Schema $schema): void
    {
        $table = $schema->getTable('paineis');

        if ($table->hasColumn('voz_ativa')) {
            $this->addSql('ALTER TABLE paineis DROP COLUMN voz_ativa');
        }
        if ($table->hasColumn('falar_nome')) {
            $this->addSql('ALTER TABLE paineis DROP COLUMN falar_nome');
        }
        if ($table->hasColumn('voz_modelo')) {
            $this->addSql('ALTER TABLE paineis DROP COLUMN voz_modelo');
        }
        if ($table->hasColumn('voz_velocidade')) {
            $this->addSql('ALTER TABLE paineis DROP COLUMN voz_velocidade');
        }
    }
}
