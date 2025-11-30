// UTILITAIRE - Synchroniser les clés embarquées dans license.js

const fs = require('fs');
const path = require('path');

const KEYS_FILE = path.join(__dirname, 'valid_keys.json');
const LICENSE_MODULE = path.join(__dirname, 'license.js');
const CLIENT_LICENSE = path.join(__dirname, '..', 'CLIENTPART', 'license.js');

function syncEmbeddedKeys() {
    try {
        // Lire valid_keys.json
        if (!fs.existsSync(KEYS_FILE)) {
            console.log('❌ Fichier valid_keys.json introuvable');
            return;
        }

        const keysData = JSON.parse(fs.readFileSync(KEYS_FILE, 'utf8'));
        const allKeys = Object.keys(keysData);

        console.log(`\n📋 Clés trouvées dans valid_keys.json : ${allKeys.length}`);
        allKeys.forEach((key, index) => {
            const data = keysData[key];
            console.log(`   ${index + 1}. ${key} - ${data.username} ${data.activated ? '✓' : '○'}`);
        });

        // Lire license.js
        let licenseContent = fs.readFileSync(LICENSE_MODULE, 'utf8');

        // Créer le nouveau tableau EMBEDDED_KEYS
        const embeddedKeysArray = allKeys.map(k => `    "${k}"`).join(',\n');
        const newEmbeddedKeys = `// Liste des clés valides embarquées (mise à jour automatiquement)\nconst EMBEDDED_KEYS = [\n${embeddedKeysArray}\n];`;

        // Remplacer dans license.js
        const regex = /\/\/ Liste des clés valides embarquées[\s\S]*?const EMBEDDED_KEYS = \[[\s\S]*?\];/;
        
        if (regex.test(licenseContent)) {
            licenseContent = licenseContent.replace(regex, newEmbeddedKeys);
            fs.writeFileSync(LICENSE_MODULE, licenseContent, 'utf8');
            
            // Aussi mettre à jour la version client
            if (fs.existsSync(CLIENT_LICENSE)) {
                let clientLicenseContent = fs.readFileSync(CLIENT_LICENSE, 'utf8');
                if (regex.test(clientLicenseContent)) {
                    clientLicenseContent = clientLicenseContent.replace(regex, newEmbeddedKeys);
                    fs.writeFileSync(CLIENT_LICENSE, clientLicenseContent, 'utf8');
                    console.log('✅ Version CLIENT aussi mise à jour !');
                }
            }
            
            console.log('\n✅ Fichier license.js mis à jour avec succès !');
            console.log(`📦 ${allKeys.length} clés embarquées dans le module\n`);
        } else {
            console.log('\n❌ Impossible de trouver la section EMBEDDED_KEYS dans license.js');
        }

    } catch (error) {
        console.error('❌ Erreur:', error.message);
    }
}

// Exécuter
console.log('\n╔════════════════════════════════════════════════════════════╗');
console.log('║        SYNCHRONISATION DES CLÉS EMBARQUÉES                 ║');
console.log('╚════════════════════════════════════════════════════════════╝');

syncEmbeddedKeys();
