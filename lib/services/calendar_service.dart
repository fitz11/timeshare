import 'package:timeshare/data/cache/calendar_cache.dart';
import 'package:timeshare/data/models/calendar/calendar.dart';
import 'package:timeshare/data/repo/calendar_repo.dart';

class CalendarService {
  final CalendarRepository repo;
  final CalendarCache local;

  CalendarService({required this.repo, required this.local});

  // TODO: fix implementation
  Future<Calendar> getCalendar(String calID) async {
    if (local.contains(calID)) {
      return local.get(calID);
    }

    try {
      final cal = await repo.getCalendarById(calID);
      local.set(calID, cal);
      return cal!;
    } catch (e) {
      throw (Exception);
    }
  }
}
