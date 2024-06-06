import sqlite3 from 'sqlite3';
import { exec } from 'child_process';
import crypto from 'crypto';

// Function to run a query with an obvious SQL injection vulnerability
export function runQuery(userInput) {
    const db = new sqlite3.Database(':memory:');
    // SQL Injection vulnerability
    const query = `SELECT * FROM users WHERE username = '${userInput}'`;
    db.all(query, (err, rows) => {
        if (err) {
            console.error(err);
            return;
        }
        console.log(rows);
    });
    db.close();
}

// Exposed GitHub Token
const githubToken = 'ghp_1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ';
console.log(`Using GitHub token: ${githubToken}`);
// Hardcoded API Key
const apikey = 'AIzaSyD-PRODKEY1234567890';
console.log(`Using API key: ${apiKey}`);
// Insecure Random Number Generation
export function generateRandomToken() {
    return Math.random().toString(36).substring(2);
}
console.log(`Generated insecure token: ${generateRandomToken()}`);
// Command Injection vulnerability
export function runCommand(userInput) {
    exec(`ls ${userInput}`, (err, stdout, stderr) => {
        if (err) {
            console.error(err);
            return;
        }
        console.log(stdout);
    });
}