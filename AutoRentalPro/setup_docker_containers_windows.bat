@echo off
setlocal

REM Fonction pour afficher un message d'erreur et quitter le script
:ERROR_EXIT
echo %1 1>&2
exit /b 1

REM Démarrer les conteneurs Docker
echo Démarrage des conteneurs Docker...
docker-compose down --remove-orphans || call :ERROR_EXIT "Échec de l'arrêt des conteneurs Docker"
docker-compose up -d --build || call :ERROR_EXIT "Échec du démarrage des conteneurs Docker"

REM Attendre quelques secondes pour s'assurer que les conteneurs sont bien démarrés
timeout /t 10

REM Installation des dépendances pour le backend Symfony
echo Installation des dépendances pour le backend Symfony...
docker-compose exec backend composer install || call :ERROR_EXIT "Échec de l'installation des dépendances du backend"
docker-compose exec backend php bin/console doctrine:schema:update --force || call :ERROR_EXIT "Échec de la mise à jour du schéma de la base de données"
docker-compose exec backend php bin/console doctrine:fixtures:load -n || call :ERROR_EXIT "Échec du chargement des fixtures"

REM Installation des dépendances pour l'application React Native
echo Installation des dépendances pour l'application React Native...
docker-compose exec app npm install || call :ERROR_EXIT "Échec de l'installation des dépendances de l'application mobile"
docker-compose exec app npm start || call :ERROR_EXIT "Échec du démarrage du serveur de développement React Native"

REM Installation des dépendances pour le frontend web
echo Installation des dépendances pour le frontend web...
docker-compose exec frontend npm install || call :ERROR_EXIT "Échec de l'installation des dépendances du frontend"
docker-compose exec frontend npm run build || call :ERROR_EXIT "Échec de la construction du frontend web"

echo Le projet a été initialisé avec succès.
endlocal
