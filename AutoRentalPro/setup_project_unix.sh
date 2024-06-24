#!/bin/bash

# Fonction pour afficher un message d'erreur et quitter le script
function error_exit {
    echo "$1" 1>&2
    exit 1
}

# Vérifier si Docker est installé
if ! [ -x "$(command -v docker)" ]; then
  echo 'Error: Docker is not installed.' >&2
  exit 1
fi
echo "Docker est déjà installé."

# Vérifier si Docker Compose est installé
if ! [ -x "$(command -v docker-compose)" ]; then
  echo 'Error: Docker Compose is not installed.' >&2
  exit 1
fi
echo "Docker Compose est déjà installé."

# Arrêter le service MySQL sur la machine hôte
echo "Arrêt du service MySQL local..."
sudo service mysql stop || error_exit "Échec de l'arrêt du service MySQL"

# Vérifier et tuer les processus utilisant le port 3306
echo "Vérification du port 3306..."
PIDS=$(sudo lsof -t -i:3306)
if [ -n "$PIDS" ]; then
    echo "Killing processes using port 3306: $PIDS"
    sudo kill -9 $PIDS || error_exit "Échec de la terminaison des processus utilisant le port 3306"
else
    echo "Aucun processus utilisant le port 3306 trouvé."
fi

echo "Le service MySQL local a été arrêté et le port 3306 est maintenant libre."

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
docker-compose exec frontend chmod +x /frontend/node_modules/.bin/react-scripts || error_exit "Échec de la mise à jour des permissions des scripts"
docker-compose exec frontend npm install || error_exit "Échec de l'installation des dépendances du frontend"
docker-compose exec frontend npm run build || error_exit "Échec de la construction du frontend web"

echo "Le projet a été initialisé avec succès."
