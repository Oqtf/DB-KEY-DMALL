# 🚀 CONFIGURATION GITHUB EN 5 MINUTES

## ✅ Étape 1 : Créer un Repository GitHub

1. Allez sur **https://github.com**
2. Cliquez sur **"New repository"** (bouton vert)
3. Remplissez :
   - **Repository name** : `dmall-licenses` (ou autre nom)
   - **Description** : `Système de licences DMALL2OQTF`
   - **Visibility** : 
     - ✅ **Private** (recommandé - personne ne voit vos clés)
     - ou Public (si ça ne vous dérange pas)
4. **NE cochez PAS** "Initialize with README"
5. Cliquez sur **"Create repository"**

---

## ✅ Étape 2 : Configurer Git Localement

### Si Git n'est pas installé :
```bash
# Télécharger et installer Git depuis :
https://git-scm.com/download/win
```

### Initialiser Git dans votre dossier :
```bash
# Ouvrir PowerShell dans C:\Users\sdnes\Desktop\DMALL2OQTF

# Initialiser le repo
git init

# Configurer votre identité
git config --global user.name "Votre Nom"
git config --global user.email "votre@email.com"

# Lier au repo GitHub (remplacez USERNAME et REPO)
git remote add origin https://github.com/Oqtf/DB-KEY-DMALL

# Vérifier que c'est bien lié
git remote -v
```

---

## ✅ Étape 3 : Premier Upload

```bash
# Ajouter valid_keys.json
git add valid_keys.json

# Créer un commit
git commit -m "Premier upload des clés"

# Envoyer sur GitHub
git push -u origin main
```

Si vous avez une erreur `main` n'existe pas, essayez :
```bash
git branch -M main
git push -u origin main
```

---

## ✅ Étape 4 : Récupérer l'URL RAW

1. Allez sur votre repo GitHub
2. Cliquez sur `valid_keys.json`
3. Cliquez sur le bouton **"Raw"** (en haut à droite)
4. Copiez l'URL complète de la page

**Exemple d'URL RAW :**
```
https://raw.githubusercontent.com/Oqtf/DB-KEY-DMALL/refs/heads/main/ADMINPART/valid_keys.json?token=GHSAT0AAAAAADQH2I6KKHKDUAZOTFWLWV5A2JMLFGA
```

---

## ✅ Étape 5 : Configurer license.js

1. Ouvrez `license.js`
2. Ligne 16, remplacez :
```javascript
const GITHUB_KEYS_URL = 'https://raw.githubusercontent.com/sdnes/dmall-licenses/main/valid_keys.json';
```

3. Sauvegardez

---

## ✅ Étape 6 : Tester

```bash
# Tester la validation en ligne
node test_license.js
```

Si ça fonctionne, vous verrez :
```
✅ Licence trouvée
✅ Validation en ligne active
```

---

## 🔄 Workflow Quotidien

### Quand vous modifiez une clé :

#### Option 1 : Script Automatique (Recommandé)
```bash
update_github.bat
```

#### Option 2 : Manuel
```bash
git add valid_keys.json
git commit -m "Ajout/suppression de clé"
git push origin main
```

**Résultat :**
- ✅ La clé est mise à jour sur GitHub
- ✅ Les clients vérifient automatiquement
- ✅ Révocation instantanée si vous supprimez une clé

---

## 🎯 EXEMPLE COMPLET

### Scénario : Révoquer une clé

```bash
# 1. Ouvrir panel.bat
panel.bat → [3] Révoquer une clé

# 2. La clé est supprimée de valid_keys.json

# 3. Pousser sur GitHub
update_github.bat

# 4. Le client essaie de lancer l'app
# → Vérification en ligne
# → Clé non trouvée dans valid_keys.json
# → ❌ Accès refusé !
```

**C'est INSTANTANÉ !** 🚀

---

## 🔧 Dépannage

### Erreur : "fatal: not a git repository"
```bash
git init
git remote add origin https://github.com/USERNAME/REPO.git
```

### Erreur : "Permission denied"
```bash
# Configurer l'authentification GitHub
# Utilisez un Personal Access Token

1. GitHub → Settings → Developer settings
2. Personal access tokens → Tokens (classic)
3. Generate new token
4. Cochez "repo"
5. Copiez le token

# Utilisez le token comme mot de passe quand Git demande
```

### Erreur : "Updates were rejected"
```bash
git pull origin main --rebase
git push origin main
```

---

## 📊 Vérifier que ça Fonctionne

### Depuis votre PC (test local) :
```bash
node test_license.js
# Devrait afficher : "Validation en ligne : ACTIVE"
```

### Depuis un navigateur :
```
Ouvrez votre URL RAW dans un navigateur
→ Vous devriez voir le contenu JSON de valid_keys.json
```

### Depuis le code :
```javascript
// Dans license.js, vérifiez :
this.useOnlineValidation // Devrait être true
```

---

## ✅ C'EST PRÊT !

Maintenant :
1. ✅ Les clés sont sur GitHub
2. ✅ La validation se fait en ligne
3. ✅ Vous pouvez révoquer instantanément
4. ✅ Les clients n'ont plus besoin de valid_keys.json

**Testez en révoquant une clé et en essayant de l'utiliser !** 🎉
