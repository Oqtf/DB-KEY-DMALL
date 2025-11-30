// MODULES

const readline = require('readline');
const axios = require('axios');
const { Client } = require('discord.js-selfbot-v13');
const fs = require('fs');
const LicenseManager = require('./license');

const progressFile = 'progress.json';
const licenseManager = new LicenseManager();

// FONCTIONS
function displayBanner() {
    console.log('\n╔════════════════════════════════════════════════════════════╗');
    console.log('║              DMALL2OQTF - Version Protégée                 ║');
    console.log('╚════════════════════════════════════════════════════════════╝\n');
}

async function checkLicense() {
    const licenseCheck = licenseManager.checkLicense();
    
    if (licenseCheck.valid) {
        console.log('✓ Licence valide - Accès autorisé\n');
        return true;
    }
    
    console.log('✗ Licence invalide ou expirée\n');
    console.log('─── ACTIVATION DE LA LICENCE ───\n');
    
    const key = await askQuestion('Entrez votre clé de licence : ');
    const activation = licenseManager.activateKey(key);
    
    if (activation.valid) {
        console.log('\n✓ Licence activée avec succès !\n');
        return true;
    } else {
        console.log(`\n✗ Échec de l'activation : ${activation.reason}\n`);
        console.log('Contactez l\'administrateur pour obtenir une clé valide.\n');
        return false;
    }
}

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
async function saveProgress(index) {
    fs.writeFileSync(progressFile, JSON.stringify({ lastIndex: index }), 'utf8');
}
function loadProgress() {
    if (fs.existsSync(progressFile)) {
        try {
            const data = fs.readFileSync(progressFile, 'utf8');
            return JSON.parse(data).lastIndex || 0;
        } catch {
            return 0;
        }
    }
    return 0;
}

// PROCESSUS DM

async function startDMProcess(client, token, message) {
    console.log('COMMENCER LE PROCESSUS DM');
    
    let friends = [];
    
    try {
        const response = await axios.get('https://discord.com/api/v9/users/@me/relationships', {
            headers: { 'authorization': token }
        });
        friends = response.data.filter(relationship => 
            relationship.type === 1 && 
            relationship.user?.id && 
            relationship.user?.username && 
            !relationship.user.username.includes('clyde')
        );
        
    } catch (error) {
        console.error('Erreur de récupération des amis :', error.message);
        return;
    }
    
    let messageCount = 1;
    let startIndex = loadProgress();
    
    console.log(`Reprise à partir de l'ami #${startIndex + 1}`);
    for (let i = startIndex; i < friends.length; i++) {
        const { id: userId, username } = friends[i].user;
        
        try {
            const personalizedMessage = message.replaceAll('{user}', `<@${userId}>`);
            await client.users.send(userId, personalizedMessage);
            
            console.log(`${username} - Message envoyé #${messageCount}`);
            messageCount++;
            await saveProgress(i + 1);
            
        } catch (error) {
            console.log(`${username} - Échec`);
            console.error(`Erreur lors de l'envoi du DM à ${username} (${userId}) : ${error.message || error.message}`);
        }
        await new Promise(resolve => setTimeout(resolve, 2000));
        
       
        if (messageCount % 50 === 0) {
            console.log('Pause de 3 minutes...');
            await new Promise(resolve => setTimeout(resolve, 180000)); // 3 minutes
        }
    }
    
    
    if (fs.existsSync(progressFile)) {
        fs.unlinkSync(progressFile);
    }
    
    console.log('DM TERMINÉ');
}

// PROGRAMME PRINCIPAL

(async () => {
    try {
        displayBanner();
        
        // Vérifier la licence avant de continuer
        const hasValidLicense = await checkLicense();
        
        if (!hasValidLicense) {
            console.log('Programme terminé - Licence requise.\n');
            process.exit(1);
        }
        
        const token = await askQuestion('Entrez votre token Discord : ');
        const message = await askQuestion('Entrez votre message : ');
        

        const client = new Client({ checkUpdate: false });
        
        client.on('ready', () => {
            startDMProcess(client, token, message);
        });
        
        client.login(token);
        
    } catch (error) {
        console.error('Erreur fatale:', error);
    }
})();

process.on('uncaughtException', (error) => {
    console.error('Exception non gérée :', error.message);
});

process.on('unhandledRejection', (error) => {
    console.error('Promesse non gérée :', error);
});
