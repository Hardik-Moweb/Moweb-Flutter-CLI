import 'package:{{project_name}}/utils/import.dart';
import 'package:intl/intl.dart';

/// Extension and helper methods for Date and Time
extension DateHelpers on DateTime {
  bool isToday() {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
}

///Get time difference between now and a given ISO time string in HH:MM format
String getTimeDifferenceHHMM(String isoTime) {
  if (isoTime.isEmpty) return "";
  final targetTime = DateTime.parse(isoTime).toLocal();
  final now = DateTime.now();

  Duration diff = now.difference(targetTime);

  if (diff.isNegative) return "00:00";

  final hours = diff.inHours;
  final minutes = diff.inMinutes.remainder(60);

  return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}";
}

///Get time difference between two ISO time strings in HH:MM format
String getTimeDifferenceBetweenHHMM(String startIsoTime, String? endIsoTime) {
  if (startIsoTime.isEmpty) return "00:00";
  
  final startTime = DateTime.parse(startIsoTime).toLocal();
  final DateTime endTime = endIsoTime == null || endIsoTime.isEmpty 
      ? DateTime.now() 
      : DateTime.parse(endIsoTime).toLocal();

  Duration diff = endTime.difference(startTime);

  if (diff.isNegative) return "00:00";

  final hours = diff.inHours;
  final minutes = diff.inMinutes.remainder(60);

  return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}";
}

///Format ISO date string to "Jan 13, 2026 14:24" format
String formatDateTimeDisplay(String? isoTime) {
  if (isoTime == null || isoTime.isEmpty) return "";
  try {
    final dateTime = DateTime.parse(isoTime).toLocal();
    return DateFormat(DateFormats.mmmDdYyyyHhmm).format(dateTime);
  } catch (e) {
    return "";
  }
}

///Format ISO date string to "Jan 13, 2026" format
String formatDateDisplay(String? isoTime) {
  if (isoTime == null || isoTime.isEmpty) return "";
  try {
    final trimmed = isoTime.trim();
    DateTime dateTime;
    if (trimmed.contains('/') &&
        RegExp(r'^\d{1,2}/\d{1,2}/\d{4}$').hasMatch(trimmed)) {
      // Handle "10/12/2025" format: try dd/MM/yyyy first, then MM/dd/yyyy
      try {
        dateTime = DateFormat(DateFormats.ddMMyyyySlash).parse(trimmed);
      } catch (_) {
        dateTime = DateFormat(DateFormats.mmDdYyyySlash).parse(trimmed);
      }
    } else {
      dateTime = DateTime.parse(trimmed).toLocal();
    }
    return DateFormat(DateFormats.ddMmmYyyySpace).format(dateTime);
  } catch (e) {
    return "";
  }
}

///Format ISO date string to 12-hour time with AM/PM (e.g. "2:24 PM")
String formatTimeDisplay(String? isoTime) {
  if (isoTime == null || isoTime.isEmpty) return "-";
  try {
    final dateTime = DateTime.parse(isoTime).toLocal();
    return DateFormat(DateFormats.hhmmA).format(dateTime);
  } catch (e) {
    return "";
  }
}

///Parse IOS date to local datetime return DateTime
DateTime? parseIsoToDateTime(String? isoTime) {
  if (isoTime == null || isoTime.isEmpty) return null;
  try {
    return DateTime.parse(isoTime).toLocal();
  } catch (e) {
    return null;
  }
}

///General Date Format convert
String formatDate(String? dateStr) {
  if (dateStr == null || dateStr.isEmpty) return 'N/A';

  try {
    final date = DateTime.parse(dateStr);
    return DateFormat(DateFormats.ddMMyyyy).format(date);
  } catch (e) {
    return dateStr;
  }
}

///Display the day ago, yesterday, today LABEL in comment list
String commentDateLabel(String dateString) {
  DateTime date = DateTime.parse(dateString);
  DateTime now = DateTime.now();

  Duration difference = now.difference(date);

  if (difference.inDays > 365) {
    int years = (difference.inDays / 365).floor();
    return years == 1 ? '1 year ago' : '$years years ago';
  } else if (difference.inDays > 30) {
    int months = (difference.inDays / 30).floor();
    return months == 1 ? '1 month ago' : '$months months ago';
  } else if (difference.inDays > 7) {
    int weeks = (difference.inDays / 7).floor();
    return weeks == 1 ? '1 week ago' : '$weeks weeks ago';
  } else if (difference.inDays > 0) {
    return difference.inDays == 1
        ? 'Yesterday'
        : '${difference.inDays} days ago';
  } else if (difference.inHours > 0) {
    return difference.inHours == 1
        ? '1 hour ago'
        : '${difference.inHours} hours ago';
  } else if (difference.inMinutes > 0) {
    return difference.inMinutes == 1
        ? '1 minute ago'
        : '${difference.inMinutes} minutes ago';
  } else if (difference.inSeconds > 0) {
    return difference.inSeconds == 1
        ? '1 second ago'
        : '${difference.inSeconds} seconds ago';
  } else {
    return 'Just now';
  }
}

calculateTimeDifference(DateTime backendDate) {
  // Get the current date
  DateTime currentDate = DateTime.now();

  // Calculate the difference
  Duration difference = currentDate.difference(backendDate);

  // Convert the difference to total hours and minutes
  int totalHours = difference.inHours;
  int minutes = difference.inMinutes % 60;

  // Format the difference
  return '${totalHours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
}

displayFormat(String dateString, bool isEmptyTime, {bool fromReport = false}) {
  // Combine date and time into a single DateTime object
  if (isEmptyTime) {
    DateTime dateTime = DateTime.parse(dateString.trim());

    // Format the DateTime object
    String formattedDate = DateFormat(DateFormats.ddMmmYyyySpace).format(dateTime);

    return formattedDate;
  } else {
    DateTime dateTime = DateTime.parse(dateString.trim());

    // Format the DateTime object
    String formattedDate = DateFormat(
      fromReport ? '${DateFormats.ddMMMyyyy} hh:mm a' : '${DateFormats.ddMMMyyyy} • hh:mm a',
    ).format(dateTime);

    return formattedDate;
  }
}

modifiedTime(timeString) {
  // Parse the original time string
  DateTime originalTime = DateFormat(DateFormats.hhMmSsSss).parse(timeString);

  // Create a new DateTime object with seconds and milliseconds set to zero
  DateTime modifiedTime = DateTime(
    originalTime.year,
    originalTime.month,
    originalTime.day,
    originalTime.hour,
    originalTime.minute,
    0,
    0,
  );

  // Format the new DateTime object
  String formattedTime = DateFormat(DateFormats.hhMmSsSss).format(modifiedTime);
  return formattedTime;
}

dateSameDay(dateString, end) {
  // Combine date and time into a single DateTime object
  DateTime selectedDateTime = DateTime.parse('$dateString');
  // Get the current date

  DateTime endDate = DateTime.parse(end);
  // Check if the selected date is today
  bool isToday =
      selectedDateTime.year == endDate.year &&
      selectedDateTime.month == endDate.month &&
      selectedDateTime.day ==
          endDate
              .day;

  return isToday;
}

///Take Nearest to 5or10 for the time picker interval
DateTime roundToNearestValue({DateTime? dateTime, bool endSelect = false}) {
  dateTime ??= DateTime.now();
  int interval = 5; // Round to nearest 5 min
  int minute = dateTime.minute;
  int remainder = minute % interval;

  // Round up to the next interval
  int roundedMinute = remainder == 0
      ? minute
      : (minute + (interval - remainder));

  // Handle overflow to next hour
  if (roundedMinute >= 60) {
    dateTime = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour + 1,
      0,
    );
  } else {
    dateTime = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      roundedMinute,
    );
  }

  // If it's for end time, add 5 minutes after rounding
  if (endSelect) {
    dateTime = dateTime.add(Duration(minutes: interval));
  }

  return dateTime;
}

///Check the date is today or future else return today
DateTime getValidDate(DateTime date) {
  DateTime today = DateTime.now();

  // Remove the time part for comparison by considering only the date part
  DateTime dateOnly = DateTime(
    date.year,
    date.month,
    date.day,
    date.hour,
    date.minute,
  );
  DateTime todayOnly = DateTime(
    today.year,
    today.month,
    today.day,
    today.hour,
    today.minute,
  );

  // Check if the date is today or in the future
  if (dateOnly.isAtSameMomentAs(todayOnly) || dateOnly.isAfter(todayOnly)) {
    return date; // return the given date if it's today or in the future
  } else {
    return todayOnly; // return today's date if the given date is in the past
  }
}

String ampmTime(String? dateTime) {
  if (dateTime == null || dateTime.isEmpty) return "";
  String formattedTime = DateFormat(DateFormats.hhmmA).format(DateTime.parse(dateTime));
  return formattedTime;
}

timeisOld(String date) {
  DateTime apiDate = DateTime.parse(date);
  DateTime currentDate = DateTime.now();
  return apiDate.isBefore(currentDate);
}

bool isDateBetween(DateTime date, DateTime startDate, DateTime endDate) {
  // Check if the date is on or after the start date and on or before the end date
  return (date.isAfter(startDate) || date.isAtSameMomentAs(startDate)) &&
      (date.isBefore(endDate) || date.isAtSameMomentAs(endDate));
}

Map<String, String> getCurrentMonthDateRange() {
  final now = DateTime.now();

  // Start date of the current month
  final startOfMonth = DateTime(now.year, now.month, 1);

  // End date of the current month
  final nextMonth = DateTime(now.year, now.month + 1, 1);
  final endOfMonth = nextMonth.subtract(const Duration(days: 1));

  return {
    'start': DateFormat(DateFormats.yyyyMMdd).format(startOfMonth).toString(),
    'end': DateFormat(DateFormats.yyyyMMdd).format(endOfMonth).toString(),
  };
}

/// Convert UTC time string to local device time
String toMyTime(String dateTime) {
  DateTime backendTime = DateTime.parse(dateTime);
  DateTime utcTime = DateTime.utc(
    backendTime.year,
    backendTime.month,
    backendTime.day,
    backendTime.hour,
    backendTime.minute,
    backendTime.second,
    backendTime.millisecond,
    backendTime.microsecond,
  );
  DateTime localTime = utcTime.toLocal();
  return localTime.toString();
}

///Set My Time Value Common Function with null || empty check
setMyTime(value) {
  if (value == null) return null;
  return (value is String && value.isNotEmpty) ? toMyTime(value) : value;
}

///Convert Current Device Time Zone to UTC
toUTCTime(String dateTime) {
  DateTime myTime = DateTime.parse(dateTime);
  // Assuming a 3-hour difference for this specific logic (can be adjusted if needed)
  DateTime utcTime = myTime.subtract(const Duration(hours: 3));
  return DateFormat(DateFormats.yyyyMmDdHhMmSs).format(utcTime);
}

///Set My Time Value Common Function with null || empty check
setUTCTime(value) {
  return (value is String && value.isNotEmpty) ? toUTCTime(value) : value;
}

//Get AM/PM time format
String getAMPMTime(String? dateTimeString) {
  if (dateTimeString == null || dateTimeString.isEmpty) return "";
  DateTime dateTime = DateTime.parse(dateTimeString);
  DateFormat formatter = DateFormat(DateFormats.hhmmA.replaceAll(' ', '')); // Needs 'hh:mma'
  return formatter.format(dateTime);
}
