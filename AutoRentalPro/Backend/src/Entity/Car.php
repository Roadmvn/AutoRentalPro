<?php

namespace App\Entity;

use App\Repository\CarRepository;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;
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

    #[ORM\Column(length: 255)]
    private ?string $type = null;

    #[ORM\Column(nullable: true)]
    private ?int $puissance = null;

    #[ORM\Column(length: 255)]
    private ?string $carburant = null;

    #[ORM\Column(length: 255)]
    private ?string $boite_vitesse = null;

    #[ORM\Column(nullable: true)]
    private ?int $kilometrage = null;

    #[ORM\Column(length: 255)]
    private ?string $modele = null;

    #[ORM\Column(type: Types::TEXT, nullable: true)]
    private ?string $description = null;

    #[ORM\Column(type: Types::DECIMAL, precision: 20, scale: 4)]
    private ?string $prix = null;

    #[ORM\Column(nullable: true)]
    private ?int $nombre_places = null;

    #[ORM\Column(nullable: true)]
    private ?int $nombre_portes = null;

    #[ORM\Column(length: 255)]
    private ?string $categorie = null;

    #[ORM\Column(length: 255)]
    private ?string $type_commande = null;

    #[ORM\ManyToOne(inversedBy: 'car')]
    private ?Commande $commande = null;

    #[ORM\OneToMany(mappedBy: 'car', targetEntity: Entretien::class)]
    private Collection $entretien;

    #[ORM\OneToMany(mappedBy: 'car', targetEntity: Inventaire::class)]
    private Collection $inventaire;

    public function __construct()
    {
        $this->entretien = new ArrayCollection();
        $this->inventaire = new ArrayCollection();
    }

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

    public function getType(): ?string
    {
        return $this->type;
    }

    public function setType(string $type): static
    {
        $this->type = $type;

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

    public function getCarburant(): ?string
    {
        return $this->carburant;
    }

    public function setCarburant(string $carburant): static
    {
        $this->carburant = $carburant;

        return $this;
    }

    public function getBoiteVitesse(): ?string
    {
        return $this->boite_vitesse;
    }

    public function setBoiteVitesse(string $boite_vitesse): static
    {
        $this->boite_vitesse = $boite_vitesse;

        return $this;
    }

    public function getKilometrage(): ?int
    {
        return $this->kilometrage;
    }

    public function setKilometrage(?int $kilometrage): static
    {
        $this->kilometrage = $kilometrage;

        return $this;
    }

    public function getModele(): ?string
    {
        return $this->modele;
    }

    public function setModele(string $modele): static
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

    public function getNombrePlaces(): ?int
    {
        return $this->nombre_places;
    }

    public function setNombrePlaces(?int $nombre_places): static
    {
        $this->nombre_places = $nombre_places;

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

    public function getCategorie(): ?string
    {
        return $this->categorie;
    }

    public function setCategorie(string $categorie): static
    {
        $this->categorie = $categorie;

        return $this;
    }

    public function getTypeCommande(): ?string
    {
        return $this->type_commande;
    }

    public function setTypeCommande(string $type_commande): static
    {
        $this->type_commande = $type_commande;

        return $this;
    }

    public function getCommande(): ?Commande
    {
        return $this->commande;
    }

    public function setCommande(?Commande $commande): static
    {
        $this->commande = $commande;

        return $this;
    }

    /**
     * @return Collection<int, Entretien>
     */
    public function getEntretien(): Collection
    {
        return $this->entretien;
    }

    public function addEntretien(Entretien $entretien): static
    {
        if (!$this->entretien->contains($entretien)) {
            $this->entretien->add($entretien);
            $entretien->setCar($this);
        }

        return $this;
    }

    public function removeEntretien(Entretien $entretien): static
    {
        if ($this->entretien->removeElement($entretien)) {
            // set the owning side to null (unless already changed)
            if ($entretien->getCar() === $this) {
                $entretien->setCar(null);
            }
        }

        return $this;
    }

    /**
     * @return Collection<int, Inventaire>
     */
    public function getInventaire(): Collection
    {
        return $this->inventaire;
    }

    public function addInventaire(Inventaire $inventaire): static
    {
        if (!$this->inventaire->contains($inventaire)) {
            $this->inventaire->add($inventaire);
            $inventaire->setCar($this);
        }

        return $this;
    }

    public function removeInventaire(Inventaire $inventaire): static
    {
        if ($this->inventaire->removeElement($inventaire)) {
            // set the owning side to null (unless already changed)
            if ($inventaire->getCar() === $this) {
                $inventaire->setCar(null);
            }
        }

        return $this;
    }
}
