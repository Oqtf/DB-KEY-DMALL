// SERVEUR API SIMPLE POUR VALIDATION DE LICENCES
// Hébergez ce fichier sur Vercel, Netlify, ou Render (gratuit)

const http = require('http');
const fs = require('fs');
const path = require('path');

const PORT = process.env.PORT || 3000;
const KEYS_FILE = path.join(__dirname, 'valid_keys.json');

// Charger les clés
function loadKeys() {
    if (fs.existsSync(KEYS_FILE)) {
        return JSON.parse(fs.readFileSync(KEYS_FILE, 'utf8'));
    }
    return {};
}

// Sauvegarder les clés
function saveKeys(keys) {
    fs.writeFileSync(KEYS_FILE, JSON.stringify(keys, null, 2), 'utf8');
}

// Créer le serveur
const server = http.createServer((req, res) => {
    // CORS pour accepter les requêtes depuis n'importe où
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
    res.setHeader('Content-Type', 'application/json');

    if (req.method === 'OPTIONS') {
        res.writeHead(200);
        res.end();
        return;
    }

    const url = new URL(req.url, `http://localhost:${PORT}`);

    // Route: Vérifier une clé
    if (url.pathname === '/validate' && req.method === 'POST') {
        let body = '';
        
        req.on('data', chunk => {
            body += chunk.toString();
        });

        req.on('end', () => {
            try {
                const { key, hwid } = JSON.parse(body);
                const keys = loadKeys();

                if (!keys[key]) {
                    res.writeHead(200);
                    res.end(JSON.stringify({ valid: false, reason: 'Clé invalide ou révoquée' }));
                    return;
                }

                const keyData = keys[key];

                // Vérifier l'expiration
                if (keyData.expiresAt && Date.now() > keyData.expiresAt) {
                    res.writeHead(200);
                    res.end(JSON.stringify({ valid: false, reason: 'Clé expirée' }));
                    return;
                }

                // Vérifier le HWID
                if (keyData.activated && keyData.hwid !== hwid) {
                    res.writeHead(200);
                    res.end(JSON.stringify({ valid: false, reason: 'Clé déjà utilisée sur une autre machine' }));
                    return;
                }

                res.writeHead(200);
                res.end(JSON.stringify({ valid: true, keyData: keyData }));
            } catch (error) {
                res.writeHead(400);
                res.end(JSON.stringify({ error: error.message }));
            }
        });
    }
    // Route: Activer une clé
    else if (url.pathname === '/activate' && req.method === 'POST') {
        let body = '';
        
        req.on('data', chunk => {
            body += chunk.toString();
        });

        req.on('end', () => {
            try {
                const { key, hwid } = JSON.parse(body);
                const keys = loadKeys();

                if (!keys[key]) {
                    res.writeHead(200);
                    res.end(JSON.stringify({ valid: false, reason: 'Clé invalide' }));
                    return;
                }

                const keyData = keys[key];

                // Vérifier l'expiration
                if (keyData.expiresAt && Date.now() > keyData.expiresAt) {
                    res.writeHead(200);
                    res.end(JSON.stringify({ valid: false, reason: 'Clé expirée' }));
                    return;
                }

                // Vérifier le HWID si déjà activée
                if (keyData.activated && keyData.hwid !== hwid) {
                    res.writeHead(200);
                    res.end(JSON.stringify({ valid: false, reason: 'Clé déjà utilisée sur une autre machine' }));
                    return;
                }

                // Activer la clé
                if (!keyData.activated) {
                    keys[key].activated = true;
                    keys[key].activatedAt = Date.now();
                    keys[key].hwid = hwid;
                    saveKeys(keys);
                }

                res.writeHead(200);
                res.end(JSON.stringify({ valid: true, message: 'Clé activée avec succès' }));
            } catch (error) {
                res.writeHead(400);
                res.end(JSON.stringify({ error: error.message }));
            }
        });
    }
    // Route: Lister toutes les clés (admin seulement)
    else if (url.pathname === '/keys' && req.method === 'GET') {
        const adminKey = url.searchParams.get('admin_key');
        
        // Mot de passe admin simple (changez-le !)
        if (adminKey !== 'VOTRE_MOT_DE_PASSE_ADMIN') {
            res.writeHead(403);
            res.end(JSON.stringify({ error: 'Accès refusé' }));
            return;
        }

        const keys = loadKeys();
        res.writeHead(200);
        res.end(JSON.stringify(keys));
    }
    // Route par défaut
    else {
        res.writeHead(404);
        res.end(JSON.stringify({ error: 'Route non trouvée' }));
    }
});

server.listen(PORT, () => {
    console.log(`\n╔════════════════════════════════════════════════════════════╗`);
    console.log(`║          API DE VALIDATION DE LICENCES                     ║`);
    console.log(`╚════════════════════════════════════════════════════════════╝`);
    console.log(`\n✅ Serveur démarré sur le port ${PORT}`);
    console.log(`\n📍 Endpoints disponibles :`);
    console.log(`   POST /validate  - Vérifier une clé`);
    console.log(`   POST /activate  - Activer une clé`);
    console.log(`   GET  /keys      - Lister les clés (admin)\n`);
});
