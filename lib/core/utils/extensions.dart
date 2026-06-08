import 'package:flutter/material.dart';

/// Dart extension methods — production quality, zero framework bloat
/// Provides syntactic sugar across the StreamX codebase

// ============================================================
// String Extensions
// ============================================================

extension StringExtensions on String {
  /// Capitalize first letter only
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Title case — capitalize each word
  String get titleCase {
    if (isEmpty) return this;
    return split(' ')
        .map((word) => word.isEmpty ? word : word.capitalize)
        .join(' ');
  }

  /// Truncate string with ellipsis
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }

  /// Check if string is a valid email
  bool get isValidEmail {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(this);
  }

  /// Check if string is a valid URL
  bool get isValidUrl {
    return Uri.tryParse(this)?.hasAbsolutePath ?? false;
  }

  /// Remove leading/trailing whitespace and normalize internal spaces
  String get normalized => trim().replaceAll(RegExp(r'\s+'), ' ');

  /// Check if string contains only digits
  bool get isNumeric => RegExp(r'^[0-9]+$').hasMatch(this);
}

extension NullableStringExtensions on String? {
  /// Return value or empty string if null
  String get orEmpty => this ?? '';

  /// Return true if null or empty
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Return true if not null and not empty
  bool get isNotNullOrEmpty => !isNullOrEmpty;
}

// ============================================================
// Duration Extensions
// ============================================================

extension DurationExtensions on Duration {
  /// Format as mm:ss (e.g., "05:42")
  String get formatted {
    final minutes = inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  /// Format as h:mm:ss for durations >= 1 hour (e.g., "1:05:42")
  String get formattedLong {
    if (inHours > 0) {
      final hours = inHours.toString();
      final minutes = inMinutes.remainder(60).toString().padLeft(2, '0');
      final seconds = inSeconds.remainder(60).toString().padLeft(2, '0');
      return '$hours:$minutes:$seconds';
    }
    return formatted;
  }

  /// Human-readable short form (e.g., "5m", "1h 30m")
  String get humanReadable {
    if (inHours > 0) {
      final remainingMinutes = inMinutes.remainder(60);
      return remainingMinutes > 0
          ? '${inHours}h ${remainingMinutes}m'
          : '${inHours}h';
    }
    if (inMinutes > 0) return '${inMinutes}m';
    return '${inSeconds}s';
  }
}

extension IntDurationExtensions on int {
  /// Convert seconds to Duration
  Duration get seconds => Duration(seconds: this);

  /// Convert minutes to Duration
  Duration get minutes => Duration(minutes: this);

  /// Format seconds as mm:ss string directly
  String get asTimeString => Duration(seconds: this).formatted;
}

// ============================================================
// DateTime Extensions
// ============================================================

extension DateTimeExtensions on DateTime {
  /// Format as "Jan 5, 2024"
  String get displayDate {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[month - 1]} $day, $year';
  }

  /// Relative time (e.g., "2 hours ago", "3 days ago")
  String get timeAgo {
    final difference = DateTime.now().difference(this);
    if (difference.inSeconds < 60) return 'Just now';
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    }
    if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    }
    if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    }
    if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}w ago';
    }
    if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()}mo ago';
    }
    return '${(difference.inDays / 365).floor()}y ago';
  }
}

// ============================================================
// Number Extensions
// ============================================================

extension IntExtensions on int {
  /// Format large numbers compactly (e.g., 1500 → "1.5K", 1200000 → "1.2M")
  String get compactFormat {
    if (this >= 1000000) {
      return '${(this / 1000000).toStringAsFixed(1)}M';
    }
    if (this >= 1000) {
      return '${(this / 1000).toStringAsFixed(1)}K';
    }
    return toString();
  }
}

extension DoubleExtensions on double {
  /// Format rating to 1 decimal (e.g., 8.567 → "8.6")
  String get ratingFormatted => toStringAsFixed(1);

  /// Clamp to percentage (0.0 - 1.0)
  double get clampedPercent => clamp(0.0, 1.0);
}

// ============================================================
// BuildContext Extensions
// ============================================================

extension BuildContextExtensions on BuildContext {
  /// Screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Screen height
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Check if tablet (width > 600)
  bool get isTablet => screenWidth > 600;

  /// Check if landscape orientation
  bool get isLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;

  /// Theme shortcut
  ThemeData get theme => Theme.of(this);

  /// Text theme shortcut
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Color scheme shortcut
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Safe area padding
  EdgeInsets get padding => MediaQuery.of(this).padding;

  /// Bottom navigation bar height
  double get bottomBarHeight => MediaQuery.of(this).padding.bottom;

  /// Status bar height
  double get statusBarHeight => MediaQuery.of(this).padding.top;

  /// Show a snackbar
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

// ============================================================
// List Extensions
// ============================================================

extension ListExtensions<T> on List<T> {
  /// Get element at index safely — returns null if out of bounds
  T? safeGet(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }

  /// Split list into chunks of given size
  List<List<T>> chunked(int size) {
    final chunks = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      chunks.add(sublist(i, (i + size).clamp(0, length)));
    }
    return chunks;
  }

  /// Return list or empty if null
  static List<T> orEmpty<T>(List<T>? list) => list ?? [];
}
