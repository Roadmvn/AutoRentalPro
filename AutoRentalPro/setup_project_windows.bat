@echo off

:: Fonction pour afficher un message d'erreur et quitter le script
:ERROR_EXIT
echo %1
exit /b 1

:: Vérification et installation de Docker
echo Vérification de Docker...
docker --version >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo Docker n'est pas installé. Installation de Docker...
    powershell -Command "Start-Process 'https://desktop.docker.com/win/stable/Docker%20Desktop%20Installer.exe' -Wait"
    IF %ERRORLEVEL% NEQ 0 (
        call :ERROR_EXIT "Échec de l'installation de Docker."
    )
) ELSE (
    echo Docker est déjà installé.
)

:: Vérification et installation de Docker Compose
echo Vérification de Docker Compose...
docker-compose --version >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo Docker Compose n'est pas installé. Installation de Docker Compose...
    powershell -Command "Start-Process 'https://github.com/docker/compose/releases/download/1.29.2/docker-compose-Windows-x86_64.exe' -Wait"
    IF %ERRORLEVEL% NEQ 0 (
        call :ERROR_EXIT "Échec de l'installation de Docker Compose."
    )
    move docker-compose-Windows-x86_64.exe %ProgramFiles%\Docker\Docker\resources\bin\docker-compose.exe
) ELSE (
    echo Docker Compose est déjà installé.
)

:: Vérification et installation de MySQL
echo Vérification de MySQL...
mysql --version >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo MySQL n'est pas installé. Installation de MySQL...
    powershell -Command "Start-Process 'https://dev.mysql.com/get/Downloads/MySQLInstaller/mysql-installer-web-community-8.0.23.0.msi' -Wait"
    IF %ERRORLEVEL% NEQ 0 (
        call :ERROR_EXIT "Échec de l'installation de MySQL."
    )
) ELSE (
    echo MySQL est déjà installé.
)

:: Arrêter le service MySQL local
echo Arrêt du service MySQL local...
net stop MySQL >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo "Échec de l'arrêt du service MySQL ou le service MySQL n'est pas en cours d'exécution."
)

:: Vérifier et tuer les processus utilisant le port 3306
echo Vérification du port 3306...
FOR /F "tokens=5" %%i IN ('netstat -aon ^| findstr :3306') DO (
    taskkill /PID %%i /F >nul 2>&1
)
echo Le service MySQL local a été arrêté et le port 3306 est maintenant libre.

:: Démarrer les conteneurs Docker
echo Démarrage des conteneurs Docker...
docker-compose down --remove-orphans || call :ERROR_EXIT "Échec de l'arrêt des conteneurs Docker"
docker-compose up -d --build || call :ERROR_EXIT "Échec du démarrage des conteneurs Docker"

:: Attendre quelques secondes pour s'assurer que les conteneurs sont bien démarrés
timeout /T 10

:: Installation des dépendances pour le backend Symfony
echo Installation des dépendances pour le backend Symfony...
docker-compose exec backend composer install || call :ERROR_EXIT "Échec de l'installation des dépendances du backend"
docker-compose exec backend php bin/console doctrine:schema:update --force || call :ERROR_EXIT "Échec de la mise à jour du schéma de la base de données"
docker-compose exec backend php bin/console doctrine:fixtures:load -n || call :ERROR_EXIT "Échec du chargement des fixtures"

:: Installation des dépendances pour l'application React Native
echo Installation des dépendances pour l'application React Native...
docker-compose exec app npm install || call :ERROR_EXIT "Échec de l'installation des dépendances de l'application mobile"
docker-compose exec app npm start || call :ERROR_EXIT "Échec du démarrage du serveur de développement React Native"

:: Installation des dépendances pour le frontend web
echo Installation des dépendances pour le frontend web...
docker-compose exec frontend rm -rf node_modules package-lock.json || call :ERROR_EXIT "Échec de la suppression de node_modules et package-lock.json"
docker-compose exec frontend npm cache clean --force || call :ERROR_EXIT "Échec du nettoyage du cache npm"
docker-compose exec frontend npm install || call :ERROR_EXIT "Échec de l'installation des dépendances du frontend"
docker-compose exec frontend npm run build || call :ERROR_EXIT "Échec de la construction du frontend web"

echo Le projet a été initialisé avec succès.
pause
