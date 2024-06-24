@echo off

:: Fonction pour afficher un message d'erreur et quitter le script
:ErrorExit
echo %1 1>&2
exit /b 1

:: Vérifier et installer Docker si nécessaire
where docker >nul 2>nul
IF %ERRORLEVEL% NEQ 0 (
    echo Docker n'est pas installé. Installation de Docker...
    powershell -Command "Start-Process 'powershell' -ArgumentList 'Invoke-WebRequest -Uri https://get.docker.com -OutFile get-docker.ps1; .\get-docker.ps1' -NoNewWindow -Wait"
    IF %ERRORLEVEL% NEQ 0 (
        call :ErrorExit "Échec de l'installation de Docker"
    )
) ELSE (
    echo Docker est déjà installé.
)

:: Vérifier et installer Docker Compose si nécessaire
where docker-compose >nul 2>nul
IF %ERRORLEVEL% NEQ 0 (
    echo Docker Compose n'est pas installé. Installation de Docker Compose...
    powershell -Command "Start-Process 'powershell' -ArgumentList 'Invoke-WebRequest https://github.com/docker/compose/releases/download/1.29.2/docker-compose-Windows-x86_64.exe -OutFile %ProgramFiles%\Docker\Docker\resources\bin\docker-compose.exe' -NoNewWindow -Wait"
    IF %ERRORLEVEL% NEQ 0 (
        call :ErrorExit "Échec de l'installation de Docker Compose"
    )
) ELSE (
    echo Docker Compose est déjà installé.
)

:: Arrêter le service MySQL local
echo Arrêt du service MySQL local...
net stop MySQL || call :ErrorExit "Échec de l'arrêt du service MySQL"

:: Vérifier et tuer les processus utilisant le port 3306
echo Vérification du port 3306...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :3306') do (
    echo Killing process %%a using port 3306
    taskkill /F /PID %%a || call :ErrorExit "Échec de la terminaison des processus utilisant le port 3306"
)

echo Le service MySQL local a été arrêté et le port 3306 est maintenant libre.

:: Démarrer les conteneurs Docker
echo Démarrage des conteneurs Docker...
docker-compose down --remove-orphans || call :ErrorExit "Échec de l'arrêt des conteneurs Docker"
docker-compose up -d --build || call :ErrorExit "Échec du démarrage des conteneurs Docker"

:: Attendre quelques secondes pour s'assurer que les conteneurs sont bien démarrés
timeout /T 10

:: Installation des dépendances pour le backend Symfony
echo Installation des dépendances pour le backend Symfony...
docker-compose exec backend composer install || call :ErrorExit "Échec de l'installation des dépendances du backend"
docker-compose exec backend php bin/console doctrine:schema:update --force || call :ErrorExit "Échec de la mise à jour du schéma de la base de données"
docker-compose exec backend php bin/console doctrine:fixtures:load -n || call :ErrorExit "Échec du chargement des fixtures"

:: Installation des dépendances pour l'application React Native
echo Installation des dépendances pour l'application React Native...
docker-compose exec app npm install || call :ErrorExit "Échec de l'installation des dépendances de l'application mobile"
docker-compose exec app npm start || call :ErrorExit "Échec du démarrage du serveur de développement React Native"

:: Installation des dépendances pour le frontend web
echo Installation des dépendances pour le frontend web...
docker-compose exec frontend npm install || call :ErrorExit "Échec de l'installation des dépendances du frontend"
docker-compose exec frontend npm run build || call :ErrorExit "Échec de la construction du frontend web"

echo Le projet a été initialisé avec succès.
