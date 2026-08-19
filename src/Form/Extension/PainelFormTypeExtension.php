<?php

declare(strict_types=1);

namespace App\Form\Extension;

use App\Entity\Painel;
use Novosga\PanelBundle\Form\PainelFormType;
use Symfony\Component\Form\AbstractTypeExtension;
use Symfony\Component\Form\Extension\Core\Type\CheckboxType;
use Symfony\Component\Form\Extension\Core\Type\ChoiceType;
use Symfony\Component\Form\Extension\Core\Type\NumberType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\Validator\Constraints\GreaterThanOrEqual;
use Symfony\Component\Validator\Constraints\LessThanOrEqual;

/**
 * Estende o formulário de painel do NovoSGA (vendor) acrescentando as opções
 * de chamada por voz — sem modificar o bundle original.
 *
 * Os campos são mapeados diretamente na entidade {@see Painel}, então o
 * próprio save() do controller do vendor persiste os valores.
 */
final class PainelFormTypeExtension extends AbstractTypeExtension
{
    public static function getExtendedTypes(): iterable
    {
        return [PainelFormType::class];
    }

    public function buildForm(FormBuilderInterface $builder, array $options): void
    {
        $builder
            ->add('vozAtiva', CheckboxType::class, [
                'label' => 'Ativar chamada por voz',
                'required' => false,
            ])
            ->add('falarNome', CheckboxType::class, [
                'label' => 'Falar o nome do paciente',
                'required' => false,
            ])
            ->add('vozModelo', ChoiceType::class, [
                'label' => 'Modelo de voz',
                'choices' => [
                    'Piper (rápido, leve)' => 'piper',
                    'Kokoro (qualidade superior)' => 'kokoro',
                ],
            ])
            ->add('vozVelocidade', NumberType::class, [
                'label' => 'Velocidade da fala (1.0 = normal, maior = mais devagar)',
                'scale' => 1,
                'html5' => true,
                'attr' => [
                    'step' => '0.1',
                    'min' => '0.5',
                    'max' => '2.0',
                    // datalist com presets: permite digitar OU escolher.
                    'list' => 'voz-velocidade-presets',
                ],
                'constraints' => [
                    new GreaterThanOrEqual(0.5),
                    new LessThanOrEqual(2.0),
                ],
            ]);
    }
}
