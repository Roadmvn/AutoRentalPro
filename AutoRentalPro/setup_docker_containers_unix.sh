#!/bin/bash

# Fonction pour afficher un message d'erreur et quitter le script
function error_exit {
    echo "$1" 1>&2
    exit 1
}

# Démarrer les conteneurs Docker
echo "Démarrage des conteneurs Docker..."
docker-compose down --remove-orphans || error_exit "Échec de l'arrêt des conteneurs Docker"
docker-compose up -d --build || error_exit "Échec du démarrage des conteneurs Docker"

# Attendre quelques secondes pour s'assurer que les conteneurs sont bien démarrés
sleep 10

# Installation des dépendances pour le backend Symfony
echo "Installation des dépendances pour le backend Symfony..."
docker-compose exec backend composer install || error_exit "Échec de l'installation des dépendances du backend"
docker-compose exec backend php bin/console doctrine:schema:update --force || error_exit "Échec de la mise à jour du schéma de la base de données"
docker-compose exec backend php bin/console doctrine:fixtures:load -n || error_exit "Échec du chargement des fixtures"

# Installation des dépendances pour l'application React Native
echo "Installation des dépendances pour l'application React Native..."
docker-compose exec app npm install || error_exit "Échec de l'installation des dépendances de l'application mobile"
docker-compose exec app npm start || error_exit "Échec du démarrage du serveur de développement React Native"

# Installation des dépendances pour le frontend web
echo "Installation des dépendances pour le frontend web..."
docker-compose exec frontend npm install || error_exit "Échec de l'installation des dépendances du frontend"
docker-compose exec frontend npm run build || error_exit "Échec de la construction du frontend web"

echo "Le projet a été initialisé avec succès."
