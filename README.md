# 🔐 DMALL2OQTF - Discord Mass DM Tool avec Système de Licences

## 📁 Structure du Projet

```
DMALL2OQTF/
├── ADMINPART/          ← Outils d'administration (NE PAS distribuer)
│   ├── panel.bat               Panel administrateur
│   ├── keygen.js               Générateur de clés
│   ├── license.js              Système de licences (complet)
│   ├── valid_keys.json         Base de données des clés
│   ├── sync_keys.js            Synchronisation
│   ├── update_github.bat       Mise à jour GitHub
│   ├── create_package.bat      Créateur de packages
│   └── Documentation/
│
├── CLIENTPART/         ← Application client (À distribuer)
│   ├── start.bat               Interface client
│   ├── dmallreadable.js        Programme principal
│   ├── license.js              Validation de licence
│   └── package.json            Dépendances
│
├── node_modules/       ← Dépendances (partagées)
└── package.json        ← Configuration principale
```

---

## 🎯 Utilisation

### Pour VOUS (Administrateur)

1. **Gérer les licences**
   ```bash
   cd ADMINPART
   panel.bat
   ```

2. **Créer un package client**
   ```bash
   cd ADMINPART
   create_package.bat
   ```

3. **Mettre à jour GitHub** (optionnel)
   ```bash
   cd ADMINPART
   update_github.bat
   ```

---

### Pour les CLIENTS

1. **Recevoir le package**
   - Décompresser le package reçu

2. **Installer**
   ```bash
   npm install
   ```

3. **Lancer**
   ```bash
   start.bat
   ```

4. **Activer**
   - Entrer la clé fournie
   - Profiter !

---

## 🔒 Sécurité

### ✅ À distribuer :
- Tout le contenu de `CLIENTPART/`
- `node_modules/`
- `package.json`

### ❌ NE JAMAIS distribuer :
- `ADMINPART/` (tout le dossier)
- `valid_keys.json`
- `.license` (fichier de licence local)

---

## 📚 Documentation

- `ADMINPART/README.md` - Guide administrateur
- `ADMINPART/SETUP_GITHUB.md` - Configuration GitHub
- `CLIENTPART/README.md` - Guide client

---

## ⚡ Démarrage Rapide

### Première utilisation :

1. Installez les dépendances :
   ```bash
   npm install
   ```

2. Générez votre première clé :
   ```bash
   cd ADMINPART
   panel.bat
   ```

3. Configurez GitHub (optionnel) :
   - Lisez `ADMINPART/SETUP_GITHUB.md`

4. Créez un package client :
   ```bash
   cd ADMINPART
   create_package.bat
   ```

---

## 🎉 C'est prêt !

Votre système de licences est opérationnel et bien organisé.
