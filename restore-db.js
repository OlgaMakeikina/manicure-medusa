const { exec } = require('child_process');
const fs = require('fs');
const path = require('path');
require('dotenv').config({ path: './backend/.env' });

const BACKUP_DIR = './backups/db';
const DB_URL = process.env.DATABASE_URL;

function parseDbUrl(url) {
    const match = url.match(/postgresql:\/\/([^:]+):([^@]+)@([^:]+):(\d+)\/(.+)/);
    if (!match) throw new Error('Invalid DATABASE_URL format');
    
    return {
        user: match[1],
        password: match[2],
        host: match[3],
        port: match[4],
        database: match[5]
    };
}

function getLatestBackup() {
    if (!fs.existsSync(BACKUP_DIR)) {
        throw new Error('Backup directory not found');
    }
    
    const files = fs.readdirSync(BACKUP_DIR)
        .filter(file => file.endsWith('.sql'))
        .map(file => ({
            name: file,
            path: path.join(BACKUP_DIR, file),
            mtime: fs.statSync(path.join(BACKUP_DIR, file)).mtime
        }))
        .sort((a, b) => b.mtime - a.mtime);
    
    if (files.length === 0) {
        throw new Error('No backup files found');
    }
    
    return files[0];
}

function restoreDatabase(backupFile) {
    return new Promise((resolve, reject) => {
        const dbConfig = parseDbUrl(DB_URL);
        
        if (!fs.existsSync(backupFile)) {
            reject(new Error(`Backup file not found: ${backupFile}`));
            return;
        }
        
        const command = `psql -h ${dbConfig.host} -p ${dbConfig.port} -U ${dbConfig.user} -d ${dbConfig.database} -f "${backupFile}"`;
        
        const env = { ...process.env, PGPASSWORD: dbConfig.password };
        
        exec(command, { env }, (error, stdout, stderr) => {
            if (error) {
                console.error('Restore failed:', error);
                reject(error);
                return;
            }
            
            console.log(`Database restored from: ${backupFile}`);
            resolve(backupFile);
        });
    });
}

async function main() {
    try {
        const backupFile = process.argv[2];
        
        if (backupFile) {
            await restoreDatabase(backupFile);
        } else {
            const latest = getLatestBackup();
            console.log(`Using latest backup: ${latest.name}`);
            await restoreDatabase(latest.path);
        }
        
        console.log('Restore completed successfully');
    } catch (error) {
        console.error('Restore process failed:', error);
        process.exit(1);
    }
}

if (require.main === module) {
    main();
}