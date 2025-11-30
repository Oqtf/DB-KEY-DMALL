@echo off
chcp 65001 >nul
title DMALL2OQTF - Discord Mass DM Tool
color 0A

:MENU
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
echo.
echo                   Discord Mass DM Tool - Version 1.0
echo.
echo ═══════════════════════════════════════════════════════════════════════
echo.
echo   [1] Démarrer le programme
echo   [2] Instructions d'utilisation
echo   [3] Configuration et personnalisation
echo   [4] Quitter
echo.
echo ═══════════════════════════════════════════════════════════════════════
echo.
set /p choice="Votre choix : "

if "%choice%"=="1" goto START
if "%choice%"=="2" goto INSTRUCTIONS
if "%choice%"=="3" goto CONFIG
if "%choice%"=="4" goto EXIT
goto MENU

:INSTRUCTIONS
cls
echo.
echo ═══════════════════════════════════════════════════════════════════════
echo                       INSTRUCTIONS D'UTILISATION
echo ═══════════════════════════════════════════════════════════════════════
echo.
echo  [ÉTAPE 1] Récupérer votre token Discord
echo  ──────────────────────────────────────────────────────────────────────
echo   1. Ouvrez Discord (web ou application)
echo   2. Appuyez sur F12 pour ouvrir les outils développeur
echo   3. Allez dans l'onglet "Console"
echo   4. Tapez cette commande et appuyez sur Entrée :
echo      (webpackChunkdiscord_app.push([[''],{},e=>{m=[];for(let c in e.c)m.push(e.c[c])}]),m).find(m=>m?.exports?.default?.getToken!==void 0).exports.default.getToken()
echo   5. Copiez le token qui s'affiche (sans les guillemets)
echo.
echo  [ÉTAPE 2] Préparer votre message
echo  ──────────────────────────────────────────────────────────────────────
echo   • Utilisez {user} pour mentionner l'utilisateur dans le message
echo   • Exemple : "Salut {user}, comment vas-tu ?"
echo   • Le message sera envoyé à tous vos amis Discord
echo.
echo  [ÉTAPE 3] Lancer le programme
echo  ──────────────────────────────────────────────────────────────────────
echo   • Sélectionnez l'option 1 dans le menu principal
echo   • Collez votre token Discord
echo   • Entrez votre message personnalisé
echo   • Le programme enverra automatiquement les DMs
echo.
echo  [INFORMATIONS IMPORTANTES]
echo  ──────────────────────────────────────────────────────────────────────
echo   • Pause automatique toutes les 50 messages (3 minutes)
echo   • Sauvegarde de la progression automatique
echo   • Reprise possible en cas d'interruption
echo   • Délai de 2 secondes entre chaque message
echo.
echo ═══════════════════════════════════════════════════════════════════════
echo.
pause
goto MENU

:CONFIG
cls
echo.
echo ═══════════════════════════════════════════════════════════════════════
echo                  CONFIGURATION ET PERSONNALISATION
echo ═══════════════════════════════════════════════════════════════════════
echo.
echo  [COULEURS DISPONIBLES]
echo  ──────────────────────────────────────────────────────────────────────
echo   [1] Vert sur fond noir (Matrix)          - 0A
echo   [2] Bleu sur fond noir (Classique)       - 0B
echo   [3] Cyan sur fond noir (Moderne)         - 0C
echo   [4] Rouge sur fond noir (Alerte)         - 0C
echo   [5] Violet sur fond noir (Premium)       - 0D
echo   [6] Jaune sur fond noir (Avertissement)  - 0E
echo   [7] Blanc sur fond noir (Défaut)         - 0F
echo   [8] Retour au menu
echo.
echo ═══════════════════════════════════════════════════════════════════════
echo.
set /p color_choice="Choisissez votre thème de couleur : "

if "%color_choice%"=="1" color 0A
if "%color_choice%"=="2" color 0B
if "%color_choice%"=="3" color 0C
if "%color_choice%"=="4" color 0C
if "%color_choice%"=="5" color 0D
if "%color_choice%"=="6" color 0E
if "%color_choice%"=="7" color 0F
if "%color_choice%"=="8" goto MENU

echo.
echo Thème appliqué avec succès !
timeout /t 2 >nul
goto MENU

:START
cls
echo.
echo ═══════════════════════════════════════════════════════════════════════
echo                     DÉMARRAGE DU PROGRAMME...
echo ═══════════════════════════════════════════════════════════════════════
echo.
echo  Vérification de l'environnement...
echo.

REM Vérifier si Node.js est installé
where node >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERREUR] Node.js n'est pas installé !
    echo.
    echo Veuillez installer Node.js depuis : https://nodejs.org/
    echo.
    pause
    goto MENU
)

REM Vérifier si les dépendances sont installées
if not exist "node_modules" (
    echo [INFO] Installation des dépendances...
    echo.
    call npm install
    echo.
)

echo [OK] Environnement prêt !
echo.
echo ═══════════════════════════════════════════════════════════════════════
echo                     LANCEMENT DE DMALL2OQTF
echo ═══════════════════════════════════════════════════════════════════════
echo.

node dmallreadable.js

echo.
echo ═══════════════════════════════════════════════════════════════════════
echo                     PROGRAMME TERMINÉ
echo ═══════════════════════════════════════════════════════════════════════
echo.
pause
goto MENU

:EXIT
cls
echo.
echo ═══════════════════════════════════════════════════════════════════════
echo.
echo                  Merci d'avoir utilisé DMALL2OQTF !
echo.
echo                          À bientôt ! 👋
echo.
echo ═══════════════════════════════════════════════════════════════════════
echo.
timeout /t 2 >nul
exit
