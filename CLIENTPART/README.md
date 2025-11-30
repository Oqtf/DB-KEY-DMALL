# 📱 CLIENTPART - Application Client

## 📁 Contenu de ce dossier

Tous les fichiers à distribuer aux clients pour utiliser l'application.

### 📦 Fichiers Inclus

| Fichier | Description |
|---------|-------------|
| **start.bat** | Interface de lancement pour le client |
| **dmallreadable.js** | Programme principal (Discord DM Tool) |
| **license.js** | Système de validation de licence |
| **package.json** | Dépendances Node.js |

---

## 🚀 Installation (Client)

### 1. Prérequis
- Node.js installé (https://nodejs.org/)

### 2. Installation
```bash
# Dans le dossier CLIENTPART
npm install
```

### 3. Lancement
```bash
start.bat
```

### 4. Activation
- Entrer la clé de licence fournie
- La clé est enregistrée automatiquement

---

## 📋 Distribution

### Option 1 : Package Simple
Copiez tout le contenu de ce dossier + `node_modules/`

### Option 2 : Via create_package.bat (Admin)
Utilisez le script dans ADMINPART pour créer automatiquement un package complet.

---

## 💡 Notes

- Les clients n'ont PAS besoin de `valid_keys.json`
- La validation se fait via GitHub (si configuré) ou localement
- Chaque clé est liée à UNE seule machine (HWID)
