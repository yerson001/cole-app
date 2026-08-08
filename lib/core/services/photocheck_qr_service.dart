class PhotocheckQrService {
  PhotocheckQrService._();

  static String caesarShift(String text, int shift) {
    final result = StringBuffer();
    shift = shift % 26;
    const specialChars = 'áÁéÉíÍóÓúÚñÑ';

    for (final rune in text.runes) {
      final c = String.fromCharCode(rune);
      if (specialChars.contains(c)) {
        result.write(c);
      } else if (_isAlpha(c)) {
        final base = _isUpper(c) ? 'A'.codeUnitAt(0) : 'a'.codeUnitAt(0);
        final code = c.codeUnitAt(0);
        result.write(String.fromCharCode(((code - base + shift + 26) % 26) + base));
      } else if (_isDigit(c)) {
        final code = c.codeUnitAt(0);
        result.write(String.fromCharCode(((code - 48 + shift + 10) % 10) + 48));
      } else {
        result.write(c);
      }
    }

    return result.toString().replaceAll(r'$', ' ');
  }

  static String buildPrefix({
    required int tenantId,
    required int branchId,
    required int studentId,
  }) {
    final tenantPrefix = tenantId.toString().padLeft(2, '0');
    final branchPrefix = branchId.toString().padLeft(2, '0');
    final studentPrefix = studentId.toString().padLeft(4, '0');
    return '$tenantPrefix$branchPrefix$studentPrefix';
  }

  static String buildRawData({
    required int studentId,
    required String prefix,
    required String level,
    required String degree,
    required String section,
  }) {
    final levelChar = level.isEmpty ? '' : level.substring(0, 1).toUpperCase();
    final degreeChar = degree.isEmpty ? '' : degree.substring(0, 1).toUpperCase();
    final sectionChar = section.isEmpty ? '' : section.substring(0, 1).toUpperCase();
    return '$studentId#$prefix#$levelChar#$degreeChar#$sectionChar';
  }

  static String encryptData({
    required int tenantId,
    required int branchId,
    required int studentId,
    required String level,
    required String degree,
    required String section,
    int shift = 5,
  }) {
    final prefix = buildPrefix(
      tenantId: tenantId,
      branchId: branchId,
      studentId: studentId,
    );
    final raw = buildRawData(
      studentId: studentId,
      prefix: prefix,
      level: level,
      degree: degree,
      section: section,
    );
    return caesarShift(raw, shift);
  }

  static bool _isUpper(String c) {
    return c.codeUnitAt(0) >= 'A'.codeUnitAt(0) && c.codeUnitAt(0) <= 'Z'.codeUnitAt(0);
  }

  static bool _isAlpha(String c) {
    final code = c.codeUnitAt(0);
    return (code >= 'A'.codeUnitAt(0) && code <= 'Z'.codeUnitAt(0)) ||
        (code >= 'a'.codeUnitAt(0) && code <= 'z'.codeUnitAt(0));
  }

  static bool _isDigit(String c) {
    final code = c.codeUnitAt(0);
    return code >= '0'.codeUnitAt(0) && code <= '9'.codeUnitAt(0);
  }
}
