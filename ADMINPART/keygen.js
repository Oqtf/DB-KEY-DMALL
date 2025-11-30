// GÉNÉRATEUR DE CLÉS DE LICENCE

const readline = require('readline');
const LicenseManager = require('./license');

const licenseManager = new LicenseManager();

function askQuestion(question) {
    const rl = readline.createInterface({
        input: process.stdin,
        output: process.stdout
    });
    
    return new Promise(resolve => {
        rl.question(question, answer => {
            rl.close();
            resolve(answer.trim());
        });
    });
}

function displayBanner() {
    console.clear();
    console.log('\n╔════════════════════════════════════════════════════════════╗');
    console.log('║         GÉNÉRATEUR DE CLÉS - DMALL2OQTF v1.0              ║');
    console.log('╚════════════════════════════════════════════════════════════╝\n');
}

function displayMenu() {
    console.log('┌────────────────────────────────────────────────────────────┐');
    console.log('│  [1] Générer une nouvelle clé                              │');
    console.log('│  [2] Lister toutes les clés                                │');
    console.log('│  [3] Révoquer une clé                                      │');
    console.log('│  [4] Quitter                                               │');
    console.log('└────────────────────────────────────────────────────────────┘\n');
}

async function generateNewKey() {
    console.log('\n─── GÉNÉRATION D\'UNE NOUVELLE CLÉ ───\n');
    
    const username = await askQuestion('Nom d\'utilisateur : ');
    const duration = await askQuestion('Durée en jours (laisser vide pour illimité) : ');
    
    const days = duration ? parseInt(duration) : null;
    const key = licenseManager.generateKey(username, days);
    
    console.log('\n╔════════════════════════════════════════════════════════════╗');
    console.log('║                  CLÉ GÉNÉRÉE AVEC SUCCÈS                   ║');
    console.log('╚════════════════════════════════════════════════════════════╝');
    console.log(`\n  Utilisateur : ${username}`);
    console.log(`  Clé         : ${key}`);
    console.log(`  Durée       : ${days ? days + ' jours' : 'Illimitée'}`);
    console.log(`  Créée le    : ${new Date().toLocaleString('fr-FR')}\n`);
    
    await askQuestion('Appuyez sur Entrée pour continuer...');
}

async function listAllKeys() {
    console.log('\n─── LISTE DES CLÉS GÉNÉRÉES ───\n');
    
    const keys = licenseManager.listKeys();
    const keyArray = Object.entries(keys);
    
    if (keyArray.length === 0) {
        console.log('  Aucune clé générée.\n');
    } else {
        keyArray.forEach(([key, data], index) => {
            const status = data.activated ? '✓ Activée' : '○ Non activée';
            const expiration = data.expiresAt 
                ? new Date(data.expiresAt).toLocaleDateString('fr-FR')
                : 'Illimitée';
            
            console.log(`┌─ CLÉ #${index + 1} ─────────────────────────────────────────────┐`);
            console.log(`│ Clé         : ${key}`);
            console.log(`│ Utilisateur : ${data.username}`);
            console.log(`│ Statut      : ${status}`);
            console.log(`│ Expiration  : ${expiration}`);
            if (data.activated) {
                console.log(`│ Activée le  : ${new Date(data.activatedAt).toLocaleString('fr-FR')}`);
            }
            console.log('└────────────────────────────────────────────────────────────┘\n');
        });
    }
    
    await askQuestion('Appuyez sur Entrée pour continuer...');
}

async function revokeKey() {
    console.log('\n─── RÉVOQUER UNE CLÉ ───\n');
    
    const key = await askQuestion('Entrez la clé à révoquer : ');
    
    if (licenseManager.revokeKey(key)) {
        console.log('\n✓ Clé révoquée avec succès !\n');
    } else {
        console.log('\n✗ Clé non trouvée.\n');
    }
    
    await askQuestion('Appuyez sur Entrée pour continuer...');
}

async function main() {
    let running = true;
    
    while (running) {
        displayBanner();
        displayMenu();
        
        const choice = await askQuestion('Votre choix : ');
        
        switch (choice) {
            case '1':
                await generateNewKey();
                break;
            case '2':
                await listAllKeys();
                break;
            case '3':
                await revokeKey();
                break;
            case '4':
                console.log('\nAu revoir !\n');
                running = false;
                break;
            default:
                console.log('\nChoix invalide.\n');
                await askQuestion('Appuyez sur Entrée pour continuer...');
        }
    }
}

main();
