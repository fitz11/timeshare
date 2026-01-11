/**
 * Migration: Add missing fields to calendar and event documents
 *
 * Calendars:
 * - sharedWith: Array (defaults to empty array if missing)
 *
 * Events (subcollection of calendars):
 * - color: Number (defaults to 0xFF000000 / black if missing)
 * - shape: String (defaults to "circle" if missing)
 * - recurrence: String (defaults to "none" if missing)
 *
 * Run with: node migrate.js
 * Preview with: node migrate.js --dry-run
 */

export default async function migrate(db, { dryRun }) {
  const stats = { scanned: 0, updated: 0, errors: 0 };

  const calendarsRef = db.collection('calendars');
  const calendarsSnapshot = await calendarsRef.get();

  console.log(`  Processing ${calendarsSnapshot.size} calendar documents...`);

  for (const calDoc of calendarsSnapshot.docs) {
    stats.scanned++;

    const calData = calDoc.data();
    const calUpdates = {};

    // Check for missing sharedWith field
    if (calData.sharedWith === undefined || calData.sharedWith === null) {
      calUpdates.sharedWith = [];
      console.log(`    [calendar/${calDoc.id}] Missing sharedWith - will set to empty array`);
    }

    // Apply calendar updates if any
    if (Object.keys(calUpdates).length > 0) {
      if (!dryRun) {
        try {
          await calendarsRef.doc(calDoc.id).update(calUpdates);
          stats.updated++;
        } catch (error) {
          console.error(`    [calendar/${calDoc.id}] Error: ${error.message}`);
          stats.errors++;
        }
      } else {
        stats.updated++;
      }
    }

    // Process events subcollection
    const eventsRef = calendarsRef.doc(calDoc.id).collection('events');
    const eventsSnapshot = await eventsRef.get();

    for (const eventDoc of eventsSnapshot.docs) {
      stats.scanned++;

      const eventData = eventDoc.data();
      const eventUpdates = {};

      // Check for missing color field (default: black = 0xFF000000 = 4278190080)
      if (eventData.color === undefined || eventData.color === null) {
        eventUpdates.color = 4278190080;
        console.log(`    [calendar/${calDoc.id}/events/${eventDoc.id}] Missing color - will set to black`);
      }

      // Check for missing shape field
      if (eventData.shape === undefined || eventData.shape === null) {
        eventUpdates.shape = 'circle';
        console.log(`    [calendar/${calDoc.id}/events/${eventDoc.id}] Missing shape - will set to circle`);
      }

      // Check for missing recurrence field
      if (eventData.recurrence === undefined || eventData.recurrence === null) {
        eventUpdates.recurrence = 'none';
        console.log(`    [calendar/${calDoc.id}/events/${eventDoc.id}] Missing recurrence - will set to none`);
      }

      // Apply event updates if any
      if (Object.keys(eventUpdates).length > 0) {
        if (!dryRun) {
          try {
            await eventsRef.doc(eventDoc.id).update(eventUpdates);
            stats.updated++;
          } catch (error) {
            console.error(`    [events/${eventDoc.id}] Error: ${error.message}`);
            stats.errors++;
          }
        } else {
          stats.updated++;
        }
      }
    }
  }

  return stats;
}
