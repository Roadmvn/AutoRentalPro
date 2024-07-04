<?php

namespace App\Entity;

use App\Repository\CarRepository;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity(repositoryClass: CarRepository::class)]
class Car
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\Column(length: 255)]
    private ?string $marque = null;

    #[ORM\Column(length: 255)]
    private ?string $couleur = null;

    #[ORM\Column]
    private ?int $annee = null;

    #[ORM\Column]
    private ?bool $type_car = null;

    #[ORM\Column]
    private ?bool $type_achat = null;

    #[ORM\Column(nullable: true)]
    private ?int $puissance = null;

    #[ORM\Column]
    private ?bool $carburant = null;

    #[ORM\Column]
    private ?bool $boite_vitesse = null;

    #[ORM\Column]
    private ?int $kilometrage = null;

    #[ORM\Column(length: 255, nullable: true)]
    private ?string $modele = null;

    #[ORM\Column(type: Types::TEXT, nullable: true)]
    private ?string $description = null;

    #[ORM\Column(type: Types::DECIMAL, precision: 20, scale: 2)]
    private ?string $prix = null;

    #[ORM\Column(nullable: true)]
    private ?int $nombre_portes = null;

    #[ORM\Column(nullable: true)]
    private ?int $nombre_places = null;

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getMarque(): ?string
    {
        return $this->marque;
    }

    public function setMarque(string $marque): static
    {
        $this->marque = $marque;

        return $this;
    }

    public function getCouleur(): ?string
    {
        return $this->couleur;
    }

    public function setCouleur(string $couleur): static
    {
        $this->couleur = $couleur;

        return $this;
    }

    public function getAnnee(): ?int
    {
        return $this->annee;
    }

    public function setAnnee(int $annee): static
    {
        $this->annee = $annee;

        return $this;
    }

    public function isTypeCar(): ?bool
    {
        return $this->type_car;
    }

    public function setTypeCar(bool $type_car): static
    {
        $this->type_car = $type_car;

        return $this;
    }

    public function isTypeAchat(): ?bool
    {
        return $this->type_achat;
    }

    public function setTypeAchat(bool $type_achat): static
    {
        $this->type_achat = $type_achat;

        return $this;
    }

    public function getPuissance(): ?int
    {
        return $this->puissance;
    }

    public function setPuissance(?int $puissance): static
    {
        $this->puissance = $puissance;

        return $this;
    }

    public function isCarburant(): ?bool
    {
        return $this->carburant;
    }

    public function setCarburant(bool $carburant): static
    {
        $this->carburant = $carburant;

        return $this;
    }

    public function isBoiteVitesse(): ?bool
    {
        return $this->boite_vitesse;
    }

    public function setBoiteVitesse(bool $boite_vitesse): static
    {
        $this->boite_vitesse = $boite_vitesse;

        return $this;
    }

    public function getKilometrage(): ?int
    {
        return $this->kilometrage;
    }

    public function setKilometrage(int $kilometrage): static
    {
        $this->kilometrage = $kilometrage;

        return $this;
    }

    public function getModele(): ?string
    {
        return $this->modele;
    }

    public function setModele(?string $modele): static
    {
        $this->modele = $modele;

        return $this;
    }

    public function getDescription(): ?string
    {
        return $this->description;
    }

    public function setDescription(?string $description): static
    {
        $this->description = $description;

        return $this;
    }

    public function getPrix(): ?string
    {
        return $this->prix;
    }

    public function setPrix(string $prix): static
    {
        $this->prix = $prix;

        return $this;
    }

    public function getNombrePortes(): ?int
    {
        return $this->nombre_portes;
    }

    public function setNombrePortes(?int $nombre_portes): static
    {
        $this->nombre_portes = $nombre_portes;

        return $this;
    }

    public function getNombrePlaces(): ?int
    {
        return $this->nombre_places;
    }

    public function setNombrePlaces(?int $nombre_places): static
    {
        $this->nombre_places = $nombre_places;

        return $this;
    }
}
