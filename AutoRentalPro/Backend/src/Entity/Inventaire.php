<?php

namespace App\Entity;

use App\Repository\InventaireRepository;
use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity(repositoryClass: InventaireRepository::class)]
class Inventaire
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\Column]
    private ?int $quantitÃe = null;

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getQuantitÃe(): ?int
    {
        return $this->quantitÃe;
    }

    public function setQuantitÃe(int $quantitÃe): static
    {
        $this->quantitÃe = $quantitÃe;

        return $this;
    }
}
