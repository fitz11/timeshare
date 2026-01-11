/**
 * Migration: Move embedded events to subcollection
 *
 * OLD STRUCTURE (pre-refactor):
 *   calendars/{id}:
 *     - id, owner, name
 *     - sharedWith: string[] (array)
 *     - events: { "2024-01-15T00:00:00.000Z": [Event, Event], ... }
 *
 * NEW STRUCTURE (current):
 *   calendars/{id}:
 *     - id, owner, name
 *     - sharedWith: string[] (array, used as Set in app)
 *   calendars/{id}/events/{eventId}:
 *     - id, name, time, color, shape, recurrence, etc.
 *
 * This migration:
 * 1. Finds calendars with embedded 'events' field
 * 2. Extracts each event and creates it in the events subcollection
 * 3. Removes the 'events' field from the calendar document
 *
 * Run with: node migrate.js --migration=003
 * Preview with: node migrate.js --migration=003 --dry-run
 */

import { randomUUID } from 'crypto';

export default async function migrate(db, { dryRun, FieldValue }) {
  const stats = { scanned: 0, updated: 0, errors: 0, eventsMigrated: 0 };

  const calendarsRef = db.collection('calendars');
  const calendarsSnapshot = await calendarsRef.get();

  console.log(`  Processing ${calendarsSnapshot.size} calendar documents...`);

  for (const calDoc of calendarsSnapshot.docs) {
    stats.scanned++;

    const calData = calDoc.data();
    const calendarId = calDoc.id;

    // Check if this calendar has embedded events (old structure)
    if (calData.events && typeof calData.events === 'object') {
      const embeddedEvents = calData.events;
      const eventCount = countEmbeddedEvents(embeddedEvents);

      console.log(`    [${calendarId}] Found ${eventCount} embedded events to migrate`);

      if (!dryRun) {
        try {
          // Extract and create events in subcollection
          const eventsRef = calendarsRef.doc(calendarId).collection('events');
          let migratedCount = 0;

          for (const [dateKey, eventList] of Object.entries(embeddedEvents)) {
            if (!Array.isArray(eventList)) continue;

            for (const event of eventList) {
              // Generate ID if not present
              const eventId = event.id || randomUUID();

              // Normalize the event data
              const eventData = {
                id: eventId,
                name: event.name || 'Untitled Event',
                time: event.time || dateKey, // Use the map key as fallback
                color: event.color ?? 4278190080, // Default: black
                shape: event.shape || 'circle',
                recurrence: event.recurrence || 'none',
                recurrenceEndDate: event.recurrenceEndDate || null,
                atendees: event.atendees || null,
              };

              await eventsRef.doc(eventId).set(eventData);
              migratedCount++;
            }
          }

          // Remove the embedded events field from calendar
          await calendarsRef.doc(calendarId).update({
            events: FieldValue.delete(),
          });

          stats.eventsMigrated += migratedCount;
          stats.updated++;
          console.log(`    [${calendarId}] Migrated ${migratedCount} events to subcollection`);

        } catch (error) {
          console.error(`    [${calendarId}] Error: ${error.message}`);
          stats.errors++;
        }
      } else {
        // Dry run - just count
        stats.eventsMigrated += eventCount;
        stats.updated++;
        console.log(`    [${calendarId}] Would migrate ${eventCount} events to subcollection`);
      }
    }
  }

  console.log(`  Total events to migrate: ${stats.eventsMigrated}`);
  return stats;
}

/**
 * Count total events in the embedded events map
 */
function countEmbeddedEvents(eventsMap) {
  let count = 0;
  for (const eventList of Object.values(eventsMap)) {
    if (Array.isArray(eventList)) {
      count += eventList.length;
    }
  }
  return count;
}
