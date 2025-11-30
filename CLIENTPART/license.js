// SYSTÈME DE GESTION DES LICENCES

const crypto = require('crypto');
const fs = require('fs');
const path = require('path');
const https = require('https');

const LICENSE_FILE = path.join(__dirname, '.license');
const KEYS_FILE = path.join(__dirname, 'valid_keys.json');

// Clé secrète pour le chiffrement (CHANGEZ CETTE VALEUR)
const SECRET_KEY = 'OQTFSOUSCHIFFREMENTSECRET1337';

// URL de votre fichier valid_keys.json sur GitHub (RAW)
// Laissez vide pour désactiver la validation en ligne
const GITHUB_KEYS_URL = 'https://raw.githubusercontent.com/Oqtf/DB-KEY-DMALL/main/ADMINPART/valid_keys.json';

// Liste des clés valides embarquées (mise à jour automatiquement)
const EMBEDDED_KEYS = [
    "B57F6-2F108-1926A-80D43",
    "979B1-C2E71-B7602-B585F",
    "8A863-AE5B4-4E33A-1CCE4"
];

class LicenseManager {
    constructor() {
        this.validKeys = this.loadValidKeys();
        this.useOnlineValidation = GITHUB_KEYS_URL && GITHUB_KEYS_URL.length > 0;
    }

    // Charger les clés valides depuis le fichier
    loadValidKeys() {
        if (fs.existsSync(KEYS_FILE)) {
            try {
                const data = fs.readFileSync(KEYS_FILE, 'utf8');
                return JSON.parse(data);
            } catch (error) {
                return {};
            }
        }
        return {};
    }

    // Sauvegarder les clés valides
    saveValidKeys() {
        fs.writeFileSync(KEYS_FILE, JSON.stringify(this.validKeys, null, 2), 'utf8');
    }

    // Récupérer les clés depuis GitHub
    fetchKeysFromGithub() {
        return new Promise((resolve, reject) => {
            if (!GITHUB_KEYS_URL || GITHUB_KEYS_URL.length === 0) {
                reject(new Error('URL GitHub non configurée'));
                return;
            }

            https.get(GITHUB_KEYS_URL, (res) => {
                let data = '';

                res.on('data', (chunk) => {
                    data += chunk;
                });

                res.on('end', () => {
                    try {
                        const keys = JSON.parse(data);
                        resolve(keys);
                    } catch (error) {
                        reject(error);
                    }
                });
            }).on('error', (error) => {
                reject(error);
            });
        });
    }

    // Vérifier une clé en ligne via GitHub
    async validateKeyOnline(key) {
        try {
            const onlineKeys = await this.fetchKeysFromGithub();
            
            if (!onlineKeys[key]) {
                return { valid: false, reason: 'Clé invalide ou révoquée' };
            }

            const keyData = onlineKeys[key];

            // Vérifier l'expiration
            if (keyData.expiresAt && Date.now() > keyData.expiresAt) {
                return { valid: false, reason: 'Clé expirée' };
            }

            // Vérifier le HWID si la clé est déjà activée
            const currentHWID = this.getHWID();
            if (keyData.activated && keyData.hwid !== currentHWID) {
                return { valid: false, reason: 'Clé déjà utilisée sur une autre machine' };
            }

            return { valid: true, keyData: keyData };
        } catch (error) {
            // Fallback sur la validation locale en cas d'erreur réseau
            return this.validateKeyOffline(key);
        }
    }

    // Validation locale (fallback quand hors ligne)
    validateKeyOffline(key) {
        key = key.toUpperCase().trim();
        
        // Vérifier le format
        if (!key.match(/^[A-Z0-9]{5}-[A-Z0-9]{5}-[A-Z0-9]{5}-[A-Z0-9]{5}$/)) {
            return { valid: false, reason: 'Format de clé invalide' };
        }

        // Vérifier dans EMBEDDED_KEYS
        if (EMBEDDED_KEYS.includes(key)) {
            return { valid: true, keyData: { key: key } };
        }

        // Vérifier dans valid_keys.json si disponible
        if (this.validKeys[key]) {
            const keyData = this.validKeys[key];

            if (keyData.expiresAt && Date.now() > keyData.expiresAt) {
                return { valid: false, reason: 'Clé expirée' };
            }

            const currentHWID = this.getHWID();
            if (keyData.activated && keyData.hwid !== currentHWID) {
                return { valid: false, reason: 'Clé déjà utilisée sur une autre machine' };
            }

            return { valid: true, keyData: keyData };
        }

        return { valid: false, reason: 'Clé invalide' };
    }

    // Générer une nouvelle clé de licence
    generateKey(username, expirationDays = null) {
        const timestamp = Date.now();
        const expiration = expirationDays ? timestamp + (expirationDays * 24 * 60 * 60 * 1000) : null;
        
        // Créer une clé auto-validable qui contient les données encodées
        const keyData = {
            u: username,  // username
            c: timestamp, // created
            e: expiration // expiration
        };
        
        const dataString = JSON.stringify(keyData);
        const signature = crypto.createHmac('sha256', SECRET_KEY)
            .update(dataString)
            .digest('hex')
            .substring(0, 20)
            .toUpperCase();
        
        const encodedData = Buffer.from(dataString).toString('base64').substring(0, 20);
        const key = this.formatKey(signature);
        
        // Sauvegarder dans valid_keys.json pour le tracking admin uniquement
        this.validKeys[key] = {
            username: username,
            createdAt: timestamp,
            expiresAt: expiration,
            activated: false,
            activatedAt: null,
            hwid: null
        };
        
        this.saveValidKeys();
        return key;
    }

    // Formater la clé en format XXXXX-XXXXX-XXXXX-XXXXX
    formatKey(str) {
        return str.match(/.{1,5}/g).join('-');
    }

    // Générer un identifiant unique de machine
    getHWID() {
        const os = require('os');
        const data = `${os.hostname()}-${os.platform()}-${os.arch()}`;
        return crypto.createHash('md5').update(data).digest('hex');
    }

    // Vérifier si une clé est valide
    async validateKey(key) {
        // Si la validation en ligne est activée, essayer d'abord GitHub
        if (this.useOnlineValidation) {
            return await this.validateKeyOnline(key);
        }
        
        // Sinon, utiliser la validation locale
        return this.validateKeyOffline(key);
    }

    // Activer une clé
    async activateKey(key) {
        key = key.toUpperCase().trim();
        const validation = await this.validateKey(key);

        if (!validation.valid) {
            return validation;
        }

        const currentHWID = this.getHWID();
        
        // Vérifier le HWID si on a les données de la clé
        if (validation.keyData) {
            if (validation.keyData.activated && validation.keyData.hwid && validation.keyData.hwid !== currentHWID) {
                return { valid: false, reason: 'Clé déjà utilisée sur une autre machine' };
            }
        }
        
        // Mettre à jour dans valid_keys.json si on a accès (côté admin uniquement)
        if (this.validKeys[key]) {
            if (!this.validKeys[key].activated) {
                this.validKeys[key].activated = true;
                this.validKeys[key].activatedAt = Date.now();
                this.validKeys[key].hwid = currentHWID;
                this.saveValidKeys();
            } else if (this.validKeys[key].hwid !== currentHWID) {
                return { valid: false, reason: 'Clé déjà utilisée sur une autre machine' };
            }
        }

        // Sauvegarder la licence locale
        this.saveLicense(key);

        return { valid: true, message: 'Clé activée avec succès' };
    }

    // Sauvegarder la licence locale
    saveLicense(key) {
        const licenseData = {
            key: key,
            hwid: this.getHWID(),
            activatedAt: Date.now()
        };
        
        const encrypted = this.encrypt(JSON.stringify(licenseData));
        fs.writeFileSync(LICENSE_FILE, encrypted, 'utf8');
    }

    // Charger la licence locale
    loadLicense() {
        if (!fs.existsSync(LICENSE_FILE)) {
            return null;
        }

        try {
            const encrypted = fs.readFileSync(LICENSE_FILE, 'utf8');
            const decrypted = this.decrypt(encrypted);
            const licenseData = JSON.parse(decrypted);

            // Vérifier le HWID
            if (licenseData.hwid !== this.getHWID()) {
                return null;
            }

            return licenseData.key;
        } catch (error) {
            return null;
        }
    }

    // Vérifier la licence
    async checkLicense() {
        const savedKey = this.loadLicense();
        
        if (!savedKey) {
            return { valid: false, reason: 'Aucune licence trouvée' };
        }

        return await this.validateKey(savedKey);
    }

    // Chiffrement
    encrypt(text) {
        const cipher = crypto.createCipher('aes-256-cbc', SECRET_KEY);
        let encrypted = cipher.update(text, 'utf8', 'hex');
        encrypted += cipher.final('hex');
        return encrypted;
    }

    // Déchiffrement
    decrypt(encrypted) {
        const decipher = crypto.createDecipher('aes-256-cbc', SECRET_KEY);
        let decrypted = decipher.update(encrypted, 'hex', 'utf8');
        decrypted += decipher.final('utf8');
        return decrypted;
    }

    // Révoquer une clé
    revokeKey(key) {
        key = key.toUpperCase().trim();
        if (this.validKeys[key]) {
            delete this.validKeys[key];
            this.saveValidKeys();
            return true;
        }
        return false;
    }

    // Lister toutes les clés
    listKeys() {
        return this.validKeys;
    }
}

module.exports = LicenseManager;
