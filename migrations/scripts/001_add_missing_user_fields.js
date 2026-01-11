/**
 * Migration: Add missing fields to user documents
 *
 * This migration ensures all user documents have the required fields:
 * - joinedAt: Timestamp (defaults to current time if missing)
 * - friends: Array (defaults to empty array if missing)
 * - isAdmin: Boolean (defaults to false if missing)
 * - photoUrl: String (already nullable, no action needed)
 *
 * Run with: node migrate.js
 * Preview with: node migrate.js --dry-run
 */

export default async function migrate(db, { dryRun, FieldValue }) {
  const stats = { scanned: 0, updated: 0, errors: 0 };

  const usersRef = db.collection('users');
  const snapshot = await usersRef.get();

  console.log(`  Processing ${snapshot.size} user documents...`);

  for (const doc of snapshot.docs) {
    stats.scanned++;

    const data = doc.data();
    const updates = {};

    // Check for missing joinedAt field
    if (data.joinedAt === undefined || data.joinedAt === null) {
      // Use current timestamp as fallback for existing users
      updates.joinedAt = FieldValue.serverTimestamp();
      console.log(`    [${doc.id}] Missing joinedAt - will set to current time`);
    }

    // Check for missing friends field
    if (data.friends === undefined || data.friends === null) {
      updates.friends = [];
      console.log(`    [${doc.id}] Missing friends - will set to empty array`);
    }

    // Check for missing isAdmin field
    if (data.isAdmin === undefined || data.isAdmin === null) {
      updates.isAdmin = false;
      console.log(`    [${doc.id}] Missing isAdmin - will set to false`);
    }

    // Apply updates if any
    if (Object.keys(updates).length > 0) {
      if (!dryRun) {
        try {
          await usersRef.doc(doc.id).update(updates);
          stats.updated++;
        } catch (error) {
          console.error(`    [${doc.id}] Error updating: ${error.message}`);
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
