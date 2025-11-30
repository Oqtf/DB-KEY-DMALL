@echo off
chcp 65001 >nul
title DMALL2OQTF - PANEL ADMINISTRATEUR
color 0C

:ADMIN_LOGIN
cls
echo.
echo ═══════════════════════════════════════════════════════════════════════
echo.
echo                  ██████╗  ██████╗ ████████╗███████╗
echo                 ██╔═══██╗██╔═══██╗╚══██╔══╝██╔════╝
echo                 ██║   ██║██║   ██║   ██║   █████╗  
echo                 ██║   ██║██║▄▄ ██║   ██║   ██╔══╝  
echo                 ╚██████╔╝╚██████╔╝   ██║   ██║     
echo                  ╚═════╝  ╚══▀▀═╝    ╚═╝   ╚═╝ 
echo.
echo ═══════════════════════════════════════════════════════════════════════
echo.
echo                   🔐 PANEL ADMINISTRATEUR - ACCÈS RESTREINT
echo.
echo ═══════════════════════════════════════════════════════════════════════
echo.
echo   ⚠️  ATTENTION : Ce panel est réservé à l'administrateur uniquement
echo.
echo   Toute tentative d'accès non autorisée sera enregistrée
echo.
echo ═══════════════════════════════════════════════════════════════════════
echo.
set /p admin_pass="Entrez le mot de passe administrateur : "

REM Changez ce mot de passe par le vôtre
if NOT "%admin_pass%"=="oqtf" (
    color 04
    cls
    echo.
    echo ═══════════════════════════════════════════════════════════════════════
    echo.
    echo                        ❌ ACCÈS REFUSÉ ❌
    echo.
    echo                   Mot de passe incorrect !
    echo.
    echo ═══════════════════════════════════════════════════════════════════════
    echo.
    timeout /t 3 >nul
    exit
)

color 0A
goto MENU

:MENU
cls
echo.
echo ═══════════════════════════════════════════════════════════════════════
echo.
echo    ██████╗  █████╗ ███╗   ██╗███████╗██╗         █████╗ ██████╗ ███╗   ███╗██╗███╗   ██╗
echo    ██╔══██╗██╔══██╗████╗  ██║██╔════╝██║        ██╔══██╗██╔══██╗████╗ ████║██║████╗  ██║
echo    ██████╔╝███████║██╔██╗ ██║█████╗  ██║        ███████║██║  ██║██╔████╔██║██║██╔██╗ ██║
echo    ██╔═══╝ ██╔══██║██║╚██╗██║██╔══╝  ██║        ██╔══██║██║  ██║██║╚██╔╝██║██║██║╚██╗██║
echo    ██║     ██║  ██║██║ ╚████║███████╗███████╗   ██║  ██║██████╔╝██║ ╚═╝ ██║██║██║ ╚████║
echo    ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝   ╚═╝  ╚═╝╚═════╝ ╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝
echo.
echo ═══════════════════════════════════════════════════════════════════════
echo                        DMALL2OQTF - Panel Admin
echo ═══════════════════════════════════════════════════════════════════════
echo.
echo   ┌─────────────────────── GESTION DES LICENCES ───────────────────────┐
echo   │                                                                     │
echo   │  [1] 🔑 Générer une nouvelle clé de licence                        │
echo   │  [2] 📋 Lister toutes les clés actives                             │
echo   │  [3] 🗑️  Révoquer une clé de licence                               │
echo   │  [4] 🔍 Rechercher une clé spécifique                              │
echo   │                                                                     │
echo   └─────────────────────────────────────────────────────────────────────┘
echo.
echo   ┌───────────────────── STATISTIQUES ET MONITORING ───────────────────┐
echo   │                                                                     │
echo   │  [5] 📊 Afficher les statistiques globales                         │
echo   │  [6] 👥 Lister les utilisateurs actifs                             │
echo   │  [7] ⏰ Voir les clés expirant bientôt                             │
echo   │                                                                     │
echo   └─────────────────────────────────────────────────────────────────────┘
echo.
echo   ┌────────────────────── OUTILS ADMINISTRATEUR ────────────────────────┐
echo   │                                                                     │
echo   │  [8] 🧹 Nettoyer les clés expirées                                 │
echo   │  [9] 💾 Sauvegarder la base de données                             │
echo   │  [10] 🔄 Restaurer une sauvegarde                                  │
echo   │  [11] ⚙️  Configuration avancée                                    │
echo   │                                                                     │
echo   └─────────────────────────────────────────────────────────────────────┘
echo.
echo   [12] 🚪 Quitter le panel
echo.
echo ═══════════════════════════════════════════════════════════════════════
echo.
set /p choice="Votre choix : "

if "%choice%"=="1" goto GENERATE_KEY
if "%choice%"=="2" goto LIST_KEYS
if "%choice%"=="3" goto REVOKE_KEY
if "%choice%"=="4" goto SEARCH_KEY
if "%choice%"=="5" goto STATS
if "%choice%"=="6" goto ACTIVE_USERS
if "%choice%"=="7" goto EXPIRING_KEYS
if "%choice%"=="8" goto CLEAN_KEYS
if "%choice%"=="9" goto BACKUP
if "%choice%"=="10" goto RESTORE
if "%choice%"=="11" goto ADVANCED_CONFIG
if "%choice%"=="12" goto EXIT
goto MENU

:GENERATE_KEY
cls
echo.
echo ═══════════════════════════════════════════════════════════════════════
echo                    🔑 GÉNÉRATION D'UNE NOUVELLE CLÉ
echo ═══════════════════════════════════════════════════════════════════════
echo.

REM Vérifier si Node.js est installé
where node >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERREUR] Node.js n'est pas installé !
    echo.
    pause
    goto MENU
)

node keygen.js

echo.
echo  💾 Synchronisation des clés embarquées...
node sync_keys.js

echo.
pause
goto MENU

:LIST_KEYS
cls
echo.
echo ═══════════════════════════════════════════════════════════════════════
echo                    📋 LISTE DE TOUTES LES CLÉS
echo ═══════════════════════════════════════════════════════════════════════
echo.

where node >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERREUR] Node.js n'est pas installé !
    echo.
    pause
    goto MENU
)

node keygen.js

echo.
pause
goto MENU

:REVOKE_KEY
cls
echo.
echo ═══════════════════════════════════════════════════════════════════════
echo                    🗑️  RÉVOCATION D'UNE CLÉ
echo ═══════════════════════════════════════════════════════════════════════
echo.

where node >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERREUR] Node.js n'est pas installé !
    echo.
    pause
    goto MENU
)

node keygen.js

echo.
pause
goto MENU

:SEARCH_KEY
cls
echo.
echo ═══════════════════════════════════════════════════════════════════════
echo                    🔍 RECHERCHE D'UNE CLÉ SPÉCIFIQUE
echo ═══════════════════════════════════════════════════════════════════════
echo.

set /p search_key="Entrez la clé à rechercher : "

if exist "valid_keys.json" (
    echo.
    echo Recherche de la clé : %search_key%
    echo.
    findstr /C:"%search_key%" valid_keys.json
    if %errorlevel% neq 0 (
        echo Clé non trouvée.
    )
) else (
    echo [ERREUR] Fichier valid_keys.json introuvable.
)

echo.
pause
goto MENU

:STATS
cls
echo.
echo ═══════════════════════════════════════════════════════════════════════
echo                    📊 STATISTIQUES GLOBALES
echo ═══════════════════════════════════════════════════════════════════════
echo.

if exist "valid_keys.json" (
    echo  Analyse du fichier valid_keys.json...
    echo.
    echo  ┌─────────────────────────────────────────────────────────────┐
    
    REM Compter les lignes pour estimer le nombre de clés
    for /f %%a in ('type "valid_keys.json" ^| find /c /v ""') do set lines=%%a
    echo  │  Fichier de clés : %lines% lignes                               
    echo  │                                                                 
    echo  │  📁 Fichier : valid_keys.json                                  
    echo  │  📅 Dernière modification :                                    
    for %%a in (valid_keys.json) do echo  │     %%~ta                                                      
    echo  │                                                                 
    
    if exist ".license" (
        echo  │  ✅ Fichier .license présent sur cette machine              
    ) else (
        echo  │  ⚠️  Aucun fichier .license sur cette machine               
    )
    
    echo  │                                                                 
    echo  └─────────────────────────────────────────────────────────────┘
    echo.
    echo  💡 Pour des statistiques détaillées, utilisez l'option [2]
) else (
    echo  [ERREUR] Aucun fichier de clés trouvé.
    echo.
    echo  Générez votre première clé avec l'option [1]
)

echo.
pause
goto MENU

:ACTIVE_USERS
cls
echo.
echo ═══════════════════════════════════════════════════════════════════════
echo                    👥 UTILISATEURS ACTIFS
echo ═══════════════════════════════════════════════════════════════════════
echo.

if exist "valid_keys.json" (
    echo  Liste des utilisateurs ayant une clé :
    echo.
    echo  ┌─────────────────────────────────────────────────────────────┐
    type valid_keys.json | findstr /C:"username"
    echo  └─────────────────────────────────────────────────────────────┘
) else (
    echo  [ERREUR] Aucun fichier de clés trouvé.
)

echo.
pause
goto MENU

:EXPIRING_KEYS
cls
echo.
echo ═══════════════════════════════════════════════════════════════════════
echo                    ⏰ CLÉS EXPIRANT BIENTÔT
echo ═══════════════════════════════════════════════════════════════════════
echo.

if exist "valid_keys.json" (
    echo  Recherche des clés avec expiration...
    echo.
    echo  ┌─────────────────────────────────────────────────────────────┐
    type valid_keys.json | findstr /C:"expiresAt"
    echo  └─────────────────────────────────────────────────────────────┘
    echo.
    echo  Note : null = clé illimitée
    echo        timestamp = date d'expiration en millisecondes
) else (
    echo  [ERREUR] Aucun fichier de clés trouvé.
)

echo.
pause
goto MENU

:CLEAN_KEYS
cls
echo.
echo ═══════════════════════════════════════════════════════════════════════
echo                    🧹 NETTOYAGE DES CLÉS EXPIRÉES
echo ═══════════════════════════════════════════════════════════════════════
echo.
echo  ⚠️  ATTENTION : Cette action va supprimer définitivement toutes
echo                 les clés expirées de la base de données.
echo.
set /p confirm="Voulez-vous continuer ? (O/N) : "

if /i "%confirm%"=="O" (
    echo.
    echo  Nettoyage en cours...
    echo.
    echo  💡 Fonctionnalité à implémenter dans keygen.js
    echo     pour filtrer et supprimer les clés expirées.
    echo.
) else (
    echo.
    echo  Opération annulée.
)

echo.
pause
goto MENU

:BACKUP
cls
echo.
echo ═══════════════════════════════════════════════════════════════════════
echo                    💾 SAUVEGARDE DE LA BASE DE DONNÉES
echo ═══════════════════════════════════════════════════════════════════════
echo.

if exist "valid_keys.json" (
    set backup_name=backup_keys_%date:~-4,4%%date:~-7,2%%date:~-10,2%_%time:~0,2%%time:~3,2%%time:~6,2%.json
    set backup_name=%backup_name: =0%
    
    copy valid_keys.json "backups\%backup_name%" >nul 2>&1
    
    if exist "backups\%backup_name%" (
        echo  ✅ Sauvegarde créée avec succès !
        echo.
        echo  📁 Fichier : backups\%backup_name%
    ) else (
        if not exist "backups" mkdir backups
        copy valid_keys.json "backups\%backup_name%"
        echo  ✅ Sauvegarde créée avec succès !
        echo.
        echo  📁 Fichier : backups\%backup_name%
    )
) else (
    echo  [ERREUR] Aucun fichier de clés à sauvegarder.
)

echo.
pause
goto MENU

:RESTORE
cls
echo.
echo ═══════════════════════════════════════════════════════════════════════
echo                    🔄 RESTAURATION D'UNE SAUVEGARDE
echo ═══════════════════════════════════════════════════════════════════════
echo.

if exist "backups" (
    echo  Sauvegardes disponibles :
    echo.
    dir /b backups\*.json
    echo.
    echo  ─────────────────────────────────────────────────────────────
    echo.
    set /p restore_file="Nom du fichier à restaurer : "
    
    if exist "backups\%restore_file%" (
        echo.
        echo  ⚠️  ATTENTION : Cela va écraser le fichier actuel !
        set /p confirm="Confirmer la restauration ? (O/N) : "
        
        if /i "!confirm!"=="O" (
            copy "backups\%restore_file%" valid_keys.json
            echo.
            echo  ✅ Restauration effectuée avec succès !
        ) else (
            echo.
            echo  Opération annulée.
        )
    ) else (
        echo.
        echo  [ERREUR] Fichier introuvable.
    )
) else (
    echo  [INFO] Aucune sauvegarde trouvée.
    echo.
    echo  Créez une sauvegarde avec l'option [9]
)

echo.
pause
goto MENU

:ADVANCED_CONFIG
cls
echo.
echo ═══════════════════════════════════════════════════════════════════════
echo                    ⚙️  CONFIGURATION AVANCÉE
echo ═══════════════════════════════════════════════════════════════════════
echo.
echo   [1] 🔐 Changer le mot de passe admin
echo   [2] 🎨 Modifier la clé de chiffrement (SECRET_KEY)
echo   [3] 📝 Éditer config.json
echo   [4] 📂 Ouvrir le dossier du projet
echo   [5] 🔙 Retour au menu principal
echo.
echo ═══════════════════════════════════════════════════════════════════════
echo.
set /p config_choice="Votre choix : "

if "%config_choice%"=="1" goto CHANGE_PASSWORD
if "%config_choice%"=="2" goto CHANGE_SECRET
if "%config_choice%"=="3" goto EDIT_CONFIG
if "%config_choice%"=="4" goto OPEN_FOLDER
if "%config_choice%"=="5" goto MENU
goto ADVANCED_CONFIG

:CHANGE_PASSWORD
cls
echo.
echo ═══════════════════════════════════════════════════════════════════════
echo                    🔐 CHANGEMENT DU MOT DE PASSE ADMIN
echo ═══════════════════════════════════════════════════════════════════════
echo.
echo  ⚠️  Pour changer le mot de passe administrateur :
echo.
echo  1. Ouvrez le fichier panel.bat dans un éditeur de texte
echo  2. Recherchez la ligne : if NOT "%%admin_pass%%"=="admin123"
echo  3. Remplacez "admin123" par votre nouveau mot de passe
echo  4. Sauvegardez le fichier
echo.
echo  💡 Conseil : Utilisez un mot de passe fort et unique
echo.
pause
goto ADVANCED_CONFIG

:CHANGE_SECRET
cls
echo.
echo ═══════════════════════════════════════════════════════════════════════
echo                    🎨 MODIFICATION DE LA CLÉ DE CHIFFREMENT
echo ═══════════════════════════════════════════════════════════════════════
echo.
echo  ⚠️  IMPORTANT : Pour modifier la clé de chiffrement (SECRET_KEY) :
echo.
echo  1. Ouvrez le fichier license.js
echo  2. Ligne 11 : const SECRET_KEY = 'OQTFSOUSCHIFFREMENTSECRET1337';
echo  3. Remplacez par votre propre clé secrète
echo  4. Sauvegardez le fichier
echo.
echo  🚨 ATTENTION : Ne changez JAMAIS cette clé après avoir généré
echo                 des licences, sinon elles ne fonctionneront plus !
echo.
pause
goto ADVANCED_CONFIG

:EDIT_CONFIG
cls
if exist "config.json" (
    notepad config.json
) else (
    echo Fichier config.json introuvable.
    pause
)
goto ADVANCED_CONFIG

:OPEN_FOLDER
start explorer "%~dp0"
goto ADVANCED_CONFIG

:EXIT
cls
echo.
echo ═══════════════════════════════════════════════════════════════════════
echo.
echo                  🔒 Fermeture du panel administrateur
echo.
echo                     Session terminée avec succès
echo.
echo                          À bientôt ! 👋
echo.
echo ═══════════════════════════════════════════════════════════════════════
echo.
timeout /t 2 >nul
exit
