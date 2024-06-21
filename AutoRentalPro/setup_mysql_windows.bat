@echo off
setlocal

REM Fonction pour afficher un message d'erreur et quitter le script
:ERROR_EXIT
echo %1 1>&2
exit /b 1

REM Arrêter le service MySQL sur la machine hôte
echo Arrêt du service MySQL local...
net stop MySQL || call :ERROR_EXIT "Échec de l'arrêt du service MySQL"

REM Vérifier et tuer les processus utilisant le port 3306
echo Vérification du port 3306...
for /F "tokens=5" %%P in ('netstat -aon ^| findstr :3306') do (
    echo Killing process using port 3306: %%P
    taskkill /PID %%P /F || call :ERROR_EXIT "Échec de la terminaison des processus utilisant le port 3306"
)
echo Le service MySQL local a été arrêté et le port 3306 est maintenant libre.
endlocal
