// lib/shared/extensions/string_extensions.dart

extension StringExtensions on String? {
  /// Capitalizes the first letter of the string.
  /// Returns an empty string if the original is null or empty.
  String capitalizeFirstLetter() {
    if (this == null || this!.isEmpty) {
      return '';
    }
    return '${this![0].toUpperCase()}${this!.substring(1).toLowerCase()}';
  }

  /// Checks if the string is null or empty.
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}