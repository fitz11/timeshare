/**
 * Migration: [DESCRIPTION]
 *
 * Purpose:
 *   [Explain what this migration does and why it's needed]
 *
 * Changes:
 *   - [Change 1]
 *   - [Change 2]
 *
 * Run with: node migrate.js --migration=[NNN]
 * Preview with: node migrate.js --migration=[NNN] --dry-run
 */

export default async function migrate(db, { dryRun, FieldValue }) {
  // Stats object - always return this
  const stats = { scanned: 0, updated: 0, errors: 0 };

  // ============================================================
  // EXAMPLE 1: Update documents in a collection
  // ============================================================

  const collectionRef = db.collection('your_collection');
  const snapshot = await collectionRef.get();

  console.log(`  Processing ${snapshot.size} documents...`);

  for (const doc of snapshot.docs) {
    stats.scanned++;

    const data = doc.data();
    const updates = {};

    // Check if field needs to be added/updated
    if (data.someField === undefined) {
      updates.someField = 'default_value';
      console.log(`    [${doc.id}] Missing someField - will set to default`);
    }

    // Apply updates if any
    if (Object.keys(updates).length > 0) {
      if (!dryRun) {
        try {
          await collectionRef.doc(doc.id).update(updates);
          stats.updated++;
        } catch (error) {
          console.error(`    [${doc.id}] Error: ${error.message}`);
          stats.errors++;
        }
      } else {
        stats.updated++;
        console.log(`    [${doc.id}] Would update: ${JSON.stringify(Object.keys(updates))}`);
      }
    }
  }

  return stats;
}

// ============================================================
// COMMON PATTERNS (copy what you need into the function above)
// ============================================================

/*
// --- Add a field with default value ---
if (data.newField === undefined || data.newField === null) {
  updates.newField = 'default';
}

// --- Delete a field ---
if (data.oldField !== undefined) {
  updates.oldField = FieldValue.delete();
}

// --- Rename a field ---
if (data.oldName !== undefined && data.newName === undefined) {
  updates.newName = data.oldName;
  updates.oldName = FieldValue.delete();
}

// --- Convert array to different format ---
if (Array.isArray(data.items)) {
  updates.items = data.items.map(item => ({
    ...item,
    newProperty: 'value'
  }));
}

// --- Add timestamp ---
updates.createdAt = FieldValue.serverTimestamp();

// --- Process subcollection ---
const subRef = collectionRef.doc(doc.id).collection('subcollection');
const subSnapshot = await subRef.get();
for (const subDoc of subSnapshot.docs) {
  // process subcollection documents
}

// --- Batch writes (for large updates) ---
const batch = db.batch();
let batchCount = 0;
const BATCH_LIMIT = 500;

for (const doc of snapshot.docs) {
  batch.update(doc.ref, { field: 'value' });
  batchCount++;

  if (batchCount >= BATCH_LIMIT) {
    await batch.commit();
    batch = db.batch();
    batchCount = 0;
  }
}
if (batchCount > 0) {
  await batch.commit();
}

// --- Query with conditions ---
const filtered = await collectionRef
  .where('status', '==', 'active')
  .where('createdAt', '<', someDate)
  .get();

// --- Generate UUID ---
import { randomUUID } from 'crypto';
const newId = randomUUID();
*/
