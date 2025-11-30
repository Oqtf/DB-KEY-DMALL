@echo off
chcp 65001 >nul
title Mise à jour GitHub - Clés de Licence
color 0B

cls
echo.
echo ═══════════════════════════════════════════════════════════════════════
echo              📤 MISE À JOUR DES CLÉS SUR GITHUB
echo ═══════════════════════════════════════════════════════════════════════
echo.

REM Vérifier si Git est installé
where git >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo ❌ Git n'est pas installé !
    echo.
    echo Téléchargez Git depuis : https://git-scm.com/
    echo.
    pause
    exit
)

REM Vérifier si c'est un repo Git
if not exist ".git" (
    echo ⚠️  Ce dossier n'est pas un repository Git.
    echo.
    echo Voulez-vous initialiser un repo Git maintenant ? (O/N)
    set /p init_git="Votre choix : "
    
    if /i "%init_git%"=="O" (
        echo.
        echo 📝 Initialisation du repository Git...
        git init
        echo ✅ Repository Git créé !
        echo.
        echo 💡 N'oubliez pas de :
        echo    1. Créer un repo sur GitHub
        echo    2. Lier ce dossier au repo : git remote add origin URL_DU_REPO
        echo.
        pause
        exit
    ) else (
        echo Opération annulée.
        pause
        exit
    )
)

echo 📋 Fichiers à mettre à jour :
echo    • ADMINPART/valid_keys.json
echo.
echo ─────────────────────────────────────────────────────────────────────
echo.

REM Afficher le statut Git
git status --short

echo.
echo ─────────────────────────────────────────────────────────────────────
echo.
set /p confirm="Voulez-vous pousser ces modifications sur GitHub ? (O/N) : "

if /i not "%confirm%"=="O" (
    echo.
    echo Opération annulée.
    pause
    exit
)

echo.
echo 📦 Ajout des fichiers...
git add ADMINPART/valid_keys.json

echo.
echo 💬 Message du commit :
set /p commit_msg="Entrez un message (ou Entrée pour 'Mise à jour des clés') : "

if "%commit_msg%"=="" (
    set commit_msg=Mise à jour des clés de licence
)

echo.
echo ✍️  Création du commit...
git commit -m "%commit_msg%"

echo.
echo 📤 Envoi vers GitHub...
git push origin main

if %errorlevel% neq 0 (
    echo.
    echo ⚠️  Échec du push. Essayez avec 'master' au lieu de 'main'...
    git push origin master
    
    if %errorlevel% neq 0 (
        echo.
        color 0C
        echo ❌ Échec de l'envoi !
        echo.
        echo Vérifiez :
        echo   1. Que vous avez configuré le remote : git remote -v
        echo   2. Que vous êtes authentifié sur GitHub
        echo   3. Que la branche est correcte (main ou master)
        echo.
        pause
        exit
    )
)

color 0A
echo.
echo ═══════════════════════════════════════════════════════════════════════
echo                        ✅ MISE À JOUR RÉUSSIE !
echo ═══════════════════════════════════════════════════════════════════════
echo.
echo  Les clés ont été mises à jour sur GitHub.
echo  Les clients vérifieront automatiquement la nouvelle version !
echo.
echo  💡 Conseil : Testez avec un client pour vérifier que ça fonctionne.
echo.
echo ═══════════════════════════════════════════════════════════════════════
echo.
pause
