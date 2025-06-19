const { exec } = require('child_process');
const fs = require('fs');
const path = require('path');
require('dotenv').config({ path: './backend/.env' });

const BACKUP_DIR = './backups/db';
const DB_URL = process.env.DATABASE_URL;
const DB_NAME = process.env.DB_NAME;

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

function createBackupDir() {
    if (!fs.existsSync(BACKUP_DIR)) {
        fs.mkdirSync(BACKUP_DIR, { recursive: true });
    }
}

function backupDatabase() {
    return new Promise((resolve, reject) => {
        const dbConfig = parseDbUrl(DB_URL);
        const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
        const backupFile = path.join(BACKUP_DIR, `${DB_NAME}-${timestamp}.sql`);
        
        const command = `pg_dump -h ${dbConfig.host} -p ${dbConfig.port} -U ${dbConfig.user} -d ${dbConfig.database} -f "${backupFile}"`;
        
        const env = { ...process.env, PGPASSWORD: dbConfig.password };
        
        exec(command, { env }, (error, stdout, stderr) => {
            if (error) {
                console.error('Backup failed:', error);
                reject(error);
                return;
            }
            
            console.log(`Database backup created: ${backupFile}`);
            resolve(backupFile);
        });
    });
}

function cleanOldBackups(keepDays = 7) {
    const cutoffTime = Date.now() - (keepDays * 24 * 60 * 60 * 1000);
    
    fs.readdir(BACKUP_DIR, (err, files) => {
        if (err) return;
        
        files.forEach(file => {
            const filePath = path.join(BACKUP_DIR, file);
            fs.stat(filePath, (err, stats) => {
                if (err) return;
                
                if (stats.mtime.getTime() < cutoffTime) {
                    fs.unlink(filePath, (err) => {
                        if (!err) console.log(`Deleted old backup: ${file}`);
                    });
                }
            });
        });
    });
}

async function main() {
    try {
        createBackupDir();
        await backupDatabase();
        cleanOldBackups();
        console.log('Backup completed successfully');
    } catch (error) {
        console.error('Backup process failed:', error);
        process.exit(1);
    }
}

if (require.main === module) {
    main();
}

module.exports = { backupDatabase, createBackupDir };