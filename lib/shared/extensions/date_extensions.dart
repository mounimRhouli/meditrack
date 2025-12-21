// lib/shared/extensions/date_extensions.dart

import 'package:intl/intl.dart';

extension DateExtensions on DateTime {
  /// Formats the date into a 'dd/MM/yyyy' string.
  String toFormattedDateString() {
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(this);
  }

  /// Formats the time into a 'HH:mm' string.
  String toFormattedTimeString() {
    final formatter = DateFormat('HH:mm');
    return formatter.format(this);
  }

  /// Returns a relative time string like '2 hours ago', 'Yesterday', etc.
  String toTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 1) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}