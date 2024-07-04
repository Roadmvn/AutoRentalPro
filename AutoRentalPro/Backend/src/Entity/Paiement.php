<?php

namespace App\Entity;

use App\Repository\PaiementRepository;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity(repositoryClass: PaiementRepository::class)]
class Paiement
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\Column(type: Types::DECIMAL, precision: 20, scale: 2)]
    private ?string $montant = null;

    #[ORM\Column(type: Types::DATE_MUTABLE)]
    private ?\DateTimeInterface $date_paiement = null;

    #[ORM\Column(length: 255)]
    private ?string $methode_paiement = null;

    #[ORM\Column]
    private ?bool $statut_paiement = null;

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getMontant(): ?string
    {
        return $this->montant;
    }

    public function setMontant(string $montant): static
    {
        $this->montant = $montant;

        return $this;
    }

    public function getDatePaiement(): ?\DateTimeInterface
    {
        return $this->date_paiement;
    }

    public function setDatePaiement(\DateTimeInterface $date_paiement): static
    {
        $this->date_paiement = $date_paiement;

        return $this;
    }

    public function getMethodePaiement(): ?string
    {
        return $this->methode_paiement;
    }

    public function setMethodePaiement(string $methode_paiement): static
    {
        $this->methode_paiement = $methode_paiement;

        return $this;
    }

    public function isStatutPaiement(): ?bool
    {
        return $this->statut_paiement;
    }

    public function setStatutPaiement(bool $statut_paiement): static
    {
        $this->statut_paiement = $statut_paiement;

        return $this;
    }
}
