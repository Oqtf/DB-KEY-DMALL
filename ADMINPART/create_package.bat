@echo off
chcp 65001 >nul
title Créateur de Package Client
color 0B

REM Se positionner dans le dossier parent
cd ..

cls
echo.
echo ═══════════════════════════════════════════════════════════════════════
echo              📦 CRÉATEUR DE PACKAGE CLIENT DMALL2OQTF
echo ═══════════════════════════════════════════════════════════════════════
echo.
echo  Cet outil crée automatiquement un package prêt à distribuer
echo  à vos clients avec uniquement les fichiers nécessaires.
echo.
echo ═══════════════════════════════════════════════════════════════════════
echo.

set /p client_name="Nom du client (sans espaces) : "

if "%client_name%"=="" (
    echo.
    echo [ERREUR] Nom du client requis !
    pause
    exit
)

set package_dir=client_package_%client_name%

echo.
echo ─────────────────────────────────────────────────────────────────────
echo  Création du package pour : %client_name%
echo ─────────────────────────────────────────────────────────────────────
echo.

REM Créer le dossier du package
if exist "%package_dir%" (
    echo  ⚠️  Le dossier %package_dir% existe déjà.
    set /p overwrite="Écraser ? (O/N) : "
    if /i not "!overwrite!"=="O" (
        echo  Opération annulée.
        pause
        exit
    )
    rmdir /s /q "%package_dir%"
)

mkdir "%package_dir%"
echo  ✓ Dossier créé : %package_dir%

REM Copier les fichiers clients
echo.
echo  Copie des fichiers...

if exist "CLIENTPART\start.bat" (
    copy CLIENTPART\start.bat "%package_dir%\" >nul
    echo  ✓ start.bat
) else (
    echo  ✗ start.bat manquant !
)

if exist "CLIENTPART\dmallreadable.js" (
    copy CLIENTPART\dmallreadable.js "%package_dir%\" >nul
    echo  ✓ dmallreadable.js
) else (
    echo  ✗ dmallreadable.js manquant !
)

if exist "CLIENTPART\license.js" (
    copy CLIENTPART\license.js "%package_dir%\" >nul
    echo  ✓ license.js
) else (
    echo  ✗ license.js manquant !
)

if exist "CLIENTPART\package.json" (
    copy CLIENTPART\package.json "%package_dir%\" >nul
    echo  ✓ package.json
) else (
    echo  ✗ package.json manquant !
)

if exist "CLIENTPART\README.md" (
    copy CLIENTPART\README.md "%package_dir%\README.md" >nul
    echo  ✓ README.md (guide utilisateur)
) else (
    echo  ⚠️  README.md manquant
)

REM Copier node_modules si présent
if exist "node_modules" (
    echo.
    echo  Copie de node_modules (peut prendre quelques instants)...
    xcopy /E /I /Q "node_modules" "%package_dir%\node_modules" >nul
    echo  ✓ node_modules
) else (
    echo  ⚠️  node_modules manquant (le client devra faire npm install)
)

REM Créer un fichier d'instructions pour le client
echo.
echo  Création du fichier LISEZMOI.txt...

(
echo ═══════════════════════════════════════════════════════════════════════
echo                    DMALL2OQTF - INSTRUCTIONS D'INSTALLATION
echo ═══════════════════════════════════════════════════════════════════════
echo.
echo  Bonjour %client_name%,
echo.
echo  Merci d'avoir choisi DMALL2OQTF !
echo.
echo  ───────────────────────────────────────────────────────────────────
echo  ÉTAPE 1 : INSTALLATION
echo  ───────────────────────────────────────────────────────────────────
echo.
echo  1. Assurez-vous que Node.js est installé
echo     Télécharger : https://nodejs.org/
echo.
echo  2. Si le dossier node_modules n'est pas présent :
echo     - Ouvrir un terminal dans ce dossier
echo     - Exécuter : npm install
echo.
echo  ───────────────────────────────────────────────────────────────────
echo  ÉTAPE 2 : ACTIVATION
echo  ───────────────────────────────────────────────────────────────────
echo.
echo  1. Double-cliquez sur start.bat
echo  2. Choisissez l'option [1]
echo  3. Entrez votre clé de licence fournie
echo.
echo  Votre clé de licence : _________________________________
echo.
echo  ───────────────────────────────────────────────────────────────────
echo  ÉTAPE 3 : UTILISATION
echo  ───────────────────────────────────────────────────────────────────
echo.
echo  Pour les instructions détaillées, consultez README.md
echo.
echo  ───────────────────────────────────────────────────────────────────
echo  SUPPORT
echo  ───────────────────────────────────────────────────────────────────
echo.
echo  En cas de problème, contactez votre administrateur.
echo.
echo ═══════════════════════════════════════════════════════════════════════
) > "%package_dir%\LISEZMOI.txt"

echo  ✓ LISEZMOI.txt

echo.
echo ═══════════════════════════════════════════════════════════════════════
echo                          ✅ PACKAGE CRÉÉ !
echo ═══════════════════════════════════════════════════════════════════════
echo.
echo  📁 Dossier : %package_dir%
echo.
echo  Contenu :
echo   • start.bat           (Interface client)
echo   • dmallreadable.js    (Programme principal)
echo   • license.js          (Système de licence)
echo   • package.json        (Dépendances)
echo   • README.md           (Guide utilisateur)
echo   • LISEZMOI.txt        (Instructions)
if exist "%package_dir%\node_modules" echo   • node_modules\       (Bibliothèques)
echo.
echo ═══════════════════════════════════════════════════════════════════════
echo.
echo  📝 PROCHAINES ÉTAPES :
echo.
echo  1. Ouvrez panel.bat
echo  2. Générez une clé de licence pour %client_name%
echo  3. Notez la clé dans LISEZMOI.txt du package
echo  4. Compressez le dossier %package_dir% en ZIP
echo  5. Envoyez le ZIP au client avec la clé de licence
echo.
echo ═══════════════════════════════════════════════════════════════════════
echo.

set /p open_folder="Voulez-vous ouvrir le dossier du package ? (O/N) : "
if /i "%open_folder%"=="O" (
    start explorer "%package_dir%"
)

echo.
echo  Package prêt à être distribué ! 🚀
echo.
pause
