#!/bin/bash

# Fonction pour afficher un message d'erreur et quitter le script
function error_exit {
    echo "$1" 1>&2
    exit 1
}

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
