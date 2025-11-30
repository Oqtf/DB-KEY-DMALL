# 🔐 ADMINPART - Panel Administrateur

## 📁 Contenu de ce dossier

Tous les fichiers nécessaires pour gérer les licences et générer les packages clients.

### 🔧 Fichiers Principaux

| Fichier | Description |
|---------|-------------|
| **panel.bat** | Panel administrateur complet |
| **keygen.js** | Générateur de clés de licence |
| **license.js** | Système de gestion des licences (version complète) |
| **valid_keys.json** | Base de données des clés générées |

### 🛠️ Outils

| Fichier | Description |
|---------|-------------|
| **sync_keys.js** | Synchronise les clés dans license.js |
| **update_github.bat** | Met à jour GitHub automatiquement |
| **create_package.bat** | Crée un package client complet |
| **api_server.js** | Serveur API optionnel (si vous voulez votre propre API) |

### 📚 Documentation

| Fichier | Description |
|---------|-------------|
| **SETUP_GITHUB.md** | Guide configuration GitHub |
| **GUIDE_VALIDATION_ONLINE.md** | Documentation validation en ligne |
| **README_SOLUTION_CLEF.md** | Explication du système de clés |

---

## 🚀 Démarrage Rapide

### 1. Gérer les licences
```bash
panel.bat
```

### 2. Créer un package client
```bash
create_package.bat
> Nom du client : NomDuClient
```

### 3. Mettre à jour GitHub (optionnel)
```bash
update_github.bat
```

---

## ⚠️ IMPORTANT

**NE DISTRIBUEZ JAMAIS ce dossier aux clients !**

Seul le dossier `CLIENTPART` doit être distribué.

---

## 🔐 Sécurité

- Gardez `valid_keys.json` secret
- Changez le mot de passe dans `panel.bat`
- Sauvegardez régulièrement `valid_keys.json`
