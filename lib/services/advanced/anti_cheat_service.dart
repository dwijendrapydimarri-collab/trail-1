import 'package:app/models/advanced/event_sourcing.dart';

class SuspiciousActivityFlag {
  final String reason;
  final String eventId;

  SuspiciousActivityFlag(this.reason, this.eventId);
}

class WorkoutValidationService {
  List<SuspiciousActivityFlag> validateEvents(
    List<WorkoutEvent> sessionEvents,
  ) {
    List<SuspiciousActivityFlag> flags = [];

    for (var event in sessionEvents) {
      if (event is SetLoggedEvent || event is SetUpdatedEvent) {
        final double weight =
            (event.payload['weight'] as num?)?.toDouble() ?? 0.0;
        final int reps = event.payload['reps'] ?? 0;

        // Validation 1: Impossible Volume (Increased threshold for elite powerlifters like Hafþór Björnsson deadlifting 501kg for reps)
        // Set to 20,000kg in a single set (e.g. 500kg x 40 reps, which is impossible)
        if (weight * reps > 20000) {
          flags.add(
            SuspiciousActivityFlag(
              'Impossible volume in a single set (>20,000kg)',
              event.id,
            ),
          );
        }

        // Validation 2: Impossible Rep Count (e.g., someone just putting 999 to max out volume)
        if (reps > 500) {
          flags.add(
            SuspiciousActivityFlag(
              'Impossible rep count (>500 reps)',
              event.id,
            ),
          );
        }
      }
    }

    return flags; // Non-blocking flag array meant to hide from public leaderboards only
  }
}
