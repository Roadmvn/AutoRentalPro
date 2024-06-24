#!/bin/bash

# Fonction pour afficher un message d'erreur et quitter le script
function error_exit {
    echo "$1" 1>&2
    exit 1
}

# Vérification et installation de Docker
if ! [ -x "$(command -v docker)" ]; then
    echo "Docker n'est pas installé. Installation de Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh || error_exit "Échec de l'installation de Docker"
    rm get-docker.sh
else
    echo "Docker est déjà installé."
fi

# Vérification et installation de Docker Compose
if ! [ -x "$(command -v docker-compose)" ]; then
    echo "Docker Compose n'est pas installé. Installation de Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose || error_exit "Échec de l'installation de Docker Compose"
else
    echo "Docker Compose est déjà installé."
fi

# Arrêter le service MySQL local
echo "Arrêt du service MySQL local..."
sudo service mysql stop || echo "Le service MySQL local n'est pas en cours d'exécution."

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
echo "Nettoyage du cache npm et installation des dépendances pour le frontend web..."
docker-compose exec frontend sh -c "rm -rf node_modules package-lock.json && npm cache clean --force && npm install" || error_exit "Échec du nettoyage et de l'installation des dépendances du frontend"
docker-compose exec frontend npm run build || error_exit "Échec de la construction du frontend web"

echo "Le projet a été initialisé avec succès."
