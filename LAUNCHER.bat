@echo off
chcp 65001 >nul
title DMALL2OQTF - Démarrage Rapide
color 0E

cls
echo.
echo ═══════════════════════════════════════════════════════════════════════
echo.
echo    ██████╗ ███╗   ███╗ █████╗ ██╗     ██╗     ██████╗  ██████╗  ██████╗ ████████╗███████╗
echo    ██╔══██╗████╗ ████║██╔══██╗██║     ██║     ╚════██╗██╔═══██╗██╔═══██╗╚══██╔══╝██╔════╝
echo    ██║  ██║██╔████╔██║███████║██║     ██║      █████╔╝██║   ██║██║   ██║   ██║   █████╗  
echo    ██║  ██║██║╚██╔╝██║██╔══██║██║     ██║     ██╔═══╝ ██║▄▄ ██║██║▄▄ ██║   ██║   ██╔══╝  
echo    ██████╔╝██║ ╚═╝ ██║██║  ██║███████╗███████╗███████╗╚██████╔╝╚██████╔╝   ██║   ██║     
echo    ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝ ╚══▀▀═╝  ╚══▀▀═╝    ╚═╝   ╚═╝     
echo.
echo ═══════════════════════════════════════════════════════════════════════
echo                        MENU PRINCIPAL
echo ═══════════════════════════════════════════════════════════════════════
echo.
echo   [1] 🔐 Panel Administrateur (Gérer les licences)
echo   [2] 🎮 Lancer l'Application Client (Test)
echo   [3] 📚 Ouvrir la Documentation
echo   [4] 🚪 Quitter
echo.
echo ═══════════════════════════════════════════════════════════════════════
echo.
set /p choice="Votre choix : "

if "%choice%"=="1" goto ADMIN
if "%choice%"=="2" goto CLIENT
if "%choice%"=="3" goto DOCS
if "%choice%"=="4" exit

goto MENU

:ADMIN
cls
echo.
echo Lancement du Panel Administrateur...
echo.
cd ADMINPART
call panel.bat
cd ..
goto END

:CLIENT
cls
echo.
echo Lancement de l'Application Client...
echo.
cd CLIENTPART
call start.bat
cd ..
goto END

:DOCS
cls
echo.
echo ═══════════════════════════════════════════════════════════════════════
echo                        📚 DOCUMENTATION
echo ═══════════════════════════════════════════════════════════════════════
echo.
echo   Documentation disponible :
echo.
echo   RACINE :
echo     • README.md - Vue d'ensemble du projet
echo.
echo   ADMINPART :
echo     • ADMINPART\README.md - Guide administrateur
echo     • ADMINPART\SETUP_GITHUB.md - Configuration GitHub
echo     • ADMINPART\GUIDE_VALIDATION_ONLINE.md - Validation en ligne
echo     • ADMINPART\README_SOLUTION_CLEF.md - Système de clés
echo.
echo   CLIENTPART :
echo     • CLIENTPART\README.md - Guide utilisateur
echo.
echo ═══════════════════════════════════════════════════════════════════════
echo.
set /p open_folder="Ouvrir le dossier du projet ? (O/N) : "
if /i "%open_folder%"=="O" (
    start explorer .
)
echo.
pause
goto MENU

:END
echo.
pause
