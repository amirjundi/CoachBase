import 'package:intl/intl.dart';
import 'package:fitness_app/l10n/app_localizations.dart';

class DateHelpers {
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  static String formatShortDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String formatFullDate(DateTime date) {
    return DateFormat('EEEE, dd MMMM yyyy').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('dd MMM yyyy, HH:mm').format(date);
  }

  static String formatRelative(DateTime date, dynamic l10n) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'الآن';
        }
        return '${difference.inMinutes} دقيقة مضت';
      }
      return '${difference.inHours} ساعة مضت';
    } else if (difference.inDays == 1) {
      return 'أمس';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} أيام مضت';
    } else {
      return formatDate(date);
    }
  }

  static String formatDuration(int seconds, dynamic l10n) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    
    final minStr = 'د';
    final secStr = 'ث';

    if (minutes == 0) {
      return '$remainingSeconds$secStr';
    } else if (remainingSeconds == 0) {
      return '$minutes$minStr';
    } else {
      return '$minutes$minStr $remainingSeconds$secStr';
    }
  }

  static String formatDaysRemaining(int days, dynamic l10n) {
    if (days < 0) {
      return 'منتهي';
    } else if (days == 0) {
      return 'تنتهي اليوم';
    } else if (days == 1) {
      return 'يوم واحد متبقي';
    } else {
      return '$days أيام متبقية';
    }
  }

  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }

  static DateTime addMonths(DateTime date, int months) {
    var month = date.month + months;
    var year = date.year;
    
    while (month > 12) {
      month -= 12;
      year++;
    }
    
    while (month < 1) {
      month += 12;
      year--;
    }
    
    // Handle edge case for months with different number of days
    final lastDayOfMonth = DateTime(year, month + 1, 0).day;
    final day = date.day > lastDayOfMonth ? lastDayOfMonth : date.day;
    
    return DateTime(year, month, day, date.hour, date.minute, date.second);
  }
}
