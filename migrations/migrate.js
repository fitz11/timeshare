#!/usr/bin/env node

/**
 * Firestore Migration Runner
 *
 * Usage:
 *   node migrate.js                    # Run all pending migrations
 *   node migrate.js --dry-run          # Preview changes without applying
 *   node migrate.js --migration=001    # Run a specific migration
 *
 * Prerequisites:
 *   1. Install dependencies: npm install
 *   2. Authenticate with Firebase: firebase login
 *   3. Set your project: firebase use <project-id>
 *
 * The script uses Application Default Credentials (ADC) from the Firebase CLI.
 */

import { initializeApp, applicationDefault, cert } from 'firebase-admin/app';
import { getFirestore, FieldValue } from 'firebase-admin/firestore';
import { readdir, readFile } from 'fs/promises';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';
import { existsSync } from 'fs';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Parse command line arguments
const args = process.argv.slice(2);
const dryRun = args.includes('--dry-run');
const specificMigration = args.find(a => a.startsWith('--migration='))?.split('=')[1];
const projectArg = args.find(a => a.startsWith('--project='))?.split('=')[1];
const keyFileArg = args.find(a => a.startsWith('--key='))?.split('=')[1];
const keyFile = keyFileArg || process.env.GOOGLE_APPLICATION_CREDENTIALS;
const projectId = projectArg || process.env.GCLOUD_PROJECT || process.env.FIREBASE_PROJECT_ID;

// Colors for console output
const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  red: '\x1b[31m',
  cyan: '\x1b[36m',
  dim: '\x1b[2m',
};

function log(message, color = colors.reset) {
  console.log(`${color}${message}${colors.reset}`);
}

async function main() {
  log('\n========================================', colors.cyan);
  log('  Firestore Migration Runner', colors.cyan);
  log('========================================\n', colors.cyan);

  if (dryRun) {
    log('DRY RUN MODE - No changes will be made\n', colors.yellow);
  }

  // Initialize Firebase Admin
  try {
    let credential;
    let resolvedProjectId = projectId;

    if (keyFile) {
      // Use service account key file
      if (!existsSync(keyFile)) {
        log(`Service account key file not found: ${keyFile}`, colors.red);
        process.exit(1);
      }
      const keyFileContent = JSON.parse(await readFile(keyFile, 'utf8'));
      credential = cert(keyFileContent);
      resolvedProjectId = resolvedProjectId || keyFileContent.project_id;
      log(`Using service account: ${keyFileContent.client_email}`, colors.dim);
    } else {
      // Use Application Default Credentials
      credential = applicationDefault();
    }

    if (!resolvedProjectId) {
      log('No project ID specified!', colors.red);
      log('\nProvide a project ID using one of these methods:', colors.yellow);
      log('  node migrate.js --project=timeshare-32d37', colors.dim);
      log('  node migrate.js --key=service-account.json', colors.dim);
      log('  FIREBASE_PROJECT_ID=timeshare-32d37 node migrate.js', colors.dim);
      process.exit(1);
    }

    log(`Project: ${resolvedProjectId}`, colors.cyan);

    initializeApp({
      credential: credential,
      projectId: resolvedProjectId,
    });
    log('Firebase initialized successfully', colors.green);
  } catch (error) {
    log(`Failed to initialize Firebase: ${error.message}`, colors.red);
    log('\nAuthentication options:', colors.yellow);
    log('  1. Use a service account key:', colors.dim);
    log('     node migrate.js --key=service-account.json', colors.dim);
    log('  2. Use gcloud ADC:', colors.dim);
    log('     gcloud auth application-default login', colors.dim);
    log('     node migrate.js --project=timeshare-32d37', colors.dim);
    process.exit(1);
  }

  const db = getFirestore();

  // Load migrations from the scripts directory
  const scriptsDir = join(__dirname, 'scripts');
  let migrationFiles;

  try {
    migrationFiles = (await readdir(scriptsDir))
      .filter(f => f.endsWith('.js') && !f.startsWith('_'))
      .sort();
  } catch (error) {
    log(`No migrations directory found at ${scriptsDir}`, colors.red);
    log('Create your first migration in migrations/scripts/', colors.yellow);
    process.exit(1);
  }

  if (migrationFiles.length === 0) {
    log('No migration files found in migrations/scripts/', colors.yellow);
    process.exit(0);
  }

  // Filter to specific migration if requested
  if (specificMigration) {
    migrationFiles = migrationFiles.filter(f => f.includes(specificMigration));
    if (migrationFiles.length === 0) {
      log(`No migration found matching: ${specificMigration}`, colors.red);
      process.exit(1);
    }
  }

  log(`\nFound ${migrationFiles.length} migration(s):\n`, colors.cyan);

  // Run each migration
  for (const file of migrationFiles) {
    log(`Running: ${file}`, colors.cyan);

    try {
      const migrationPath = join(scriptsDir, file);
      const migration = await import(migrationPath);

      const stats = await migration.default(db, { dryRun, FieldValue });

      log(`  Documents scanned: ${stats.scanned}`, colors.dim);
      log(`  Documents updated: ${stats.updated}`, dryRun ? colors.yellow : colors.green);
      if (stats.errors > 0) {
        log(`  Errors: ${stats.errors}`, colors.red);
      }
      log('');
    } catch (error) {
      log(`  Error: ${error.message}`, colors.red);
      console.error(error);
      process.exit(1);
    }
  }

  log('========================================', colors.cyan);
  log(dryRun ? '  Dry run complete!' : '  All migrations complete!', colors.green);
  log('========================================\n', colors.cyan);
}

main().catch(console.error);
