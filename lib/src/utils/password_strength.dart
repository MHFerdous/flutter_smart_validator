/// Utility class for analyzing password strength.
///
/// Provides scoring and suggestions for password improvement.
class PasswordStrength {
  /// Analyzes the strength of a password and returns a score from 0.0 to 1.0.
  ///
  /// Scoring criteria:
  /// - Length (0-0.3): Longer passwords are stronger
  /// - Character variety (0-0.4): Mix of uppercase, lowercase, numbers, special chars
  /// - Patterns (0-0.2): Avoids common patterns like '123', 'abc', 'qwerty'
  /// - Common words (0-0.1): Avoids dictionary words
  ///
  /// Returns a [PasswordStrengthResult] with score and suggestions.
  ///
  /// Example:
  /// ```dart
  /// final result = PasswordStrength.analyze('MyP@ssw0rd123');
  /// print('Score: ${result.score}'); // 0.85
  /// print('Level: ${result.level}'); // Strong
  /// ```
  static PasswordStrengthResult analyze(String password) {
    if (password.isEmpty) {
      return const PasswordStrengthResult(
        score: 0.0,
        suggestions: ['Password is required'],
      );
    }

    double score = 0.0;
    final suggestions = <String>[];

    // Length score (0-0.3)
    final lengthScore = _calculateLengthScore(password);
    score += lengthScore;
    if (lengthScore < 0.3) {
      suggestions.add('Use at least 12 characters for maximum strength');
    }

    // Character variety score (0-0.4)
    final varietyScore = _calculateVarietyScore(password);
    score += varietyScore;
    if (!_hasUppercase(password)) {
      suggestions.add('Add uppercase letters');
    }
    if (!_hasLowercase(password)) {
      suggestions.add('Add lowercase letters');
    }
    if (!_hasNumbers(password)) {
      suggestions.add('Add numbers');
    }
    if (!_hasSpecialChars(password)) {
      suggestions.add('Add special characters (!@#\$%^&*)');
    }

    // Pattern penalty (0-0.2)
    final patternScore = _calculatePatternScore(password);
    score += patternScore;
    if (patternScore < 0.15) {
      suggestions.add('Avoid common patterns like 123 or abc');
    }

    // Common words penalty (0-0.1)
    final commonWordScore = _calculateCommonWordScore(password);
    score += commonWordScore;
    if (commonWordScore < 0.05) {
      suggestions.add('Avoid common words');
    }

    // Cap score at 1.0
    score = score > 1.0 ? 1.0 : score;

    return PasswordStrengthResult(score: score, suggestions: suggestions);
  }

  /// Calculates length score (0-0.3).
  static double _calculateLengthScore(String password) {
    final length = password.length;
    if (length >= 16) return 0.3;
    if (length >= 12) return 0.25;
    if (length >= 8) return 0.15;
    if (length >= 6) return 0.1;
    return length * 0.01;
  }

  /// Calculates character variety score (0-0.4).
  static double _calculateVarietyScore(String password) {
    double score = 0.0;
    if (_hasUppercase(password)) score += 0.1;
    if (_hasLowercase(password)) score += 0.1;
    if (_hasNumbers(password)) score += 0.1;
    if (_hasSpecialChars(password)) score += 0.1;
    return score;
  }

  /// Calculates pattern score (0-0.2).
  static double _calculatePatternScore(String password) {
    final lower = password.toLowerCase();

    // Check for sequential numbers
    if (lower.contains('123') ||
        lower.contains('234') ||
        lower.contains('345') ||
        lower.contains('456') ||
        lower.contains('567') ||
        lower.contains('678') ||
        lower.contains('789')) {
      return 0.05;
    }

    // Check for sequential letters
    if (lower.contains('abc') ||
        lower.contains('bcd') ||
        lower.contains('cde') ||
        lower.contains('def')) {
      return 0.05;
    }

    // Check for keyboard patterns
    if (lower.contains('qwerty') ||
        lower.contains('asdf') ||
        lower.contains('zxcv')) {
      return 0.0;
    }

    // Check for repeating characters
    if (RegExp(r'(.)\1{2,}').hasMatch(password)) {
      return 0.1;
    }

    return 0.2;
  }

  /// Calculates common word penalty (0-0.1).
  static double _calculateCommonWordScore(String password) {
    final lower = password.toLowerCase();

    // Common weak passwords and words
    const commonWords = [
      'password',
      'admin',
      'user',
      'login',
      'welcome',
      'hello',
      'test',
      'demo',
      'letmein',
      'monkey',
      'dragon',
      'master',
      'sunshine',
      'princess',
      'football',
    ];

    for (final word in commonWords) {
      if (lower.contains(word)) {
        return 0.0;
      }
    }

    return 0.1;
  }

  static bool _hasUppercase(String password) {
    return password.contains(RegExp(r'[A-Z]'));
  }

  static bool _hasLowercase(String password) {
    return password.contains(RegExp(r'[a-z]'));
  }

  static bool _hasNumbers(String password) {
    return password.contains(RegExp(r'[0-9]'));
  }

  static bool _hasSpecialChars(String password) {
    return password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }
}

/// Result of password strength analysis.
class PasswordStrengthResult {
  /// The strength score from 0.0 (very weak) to 1.0 (very strong).
  final double score;

  /// Suggestions for improving the password.
  final List<String> suggestions;

  const PasswordStrengthResult({
    required this.score,
    this.suggestions = const [],
  });

  /// Returns the strength level as a string.
  ///
  /// - 0.0 - 0.3: Very Weak
  /// - 0.3 - 0.5: Weak
  /// - 0.5 - 0.7: Medium
  /// - 0.7 - 0.85: Strong
  /// - 0.85 - 1.0: Very Strong
  String get level {
    if (score < 0.3) return 'Very Weak';
    if (score < 0.5) return 'Weak';
    if (score < 0.7) return 'Medium';
    if (score < 0.85) return 'Strong';
    return 'Very Strong';
  }

  /// Returns a color hint for UI representation.
  ///
  /// Can be used with Flutter's Color class or CSS colors.
  String get colorHint {
    if (score < 0.3) return '#D32F2F'; // Red
    if (score < 0.5) return '#F57C00'; // Orange
    if (score < 0.7) return '#FBC02D'; // Yellow
    if (score < 0.85) return '#689F38'; // Light Green
    return '#388E3C'; // Dark Green
  }

  @override
  String toString() {
    return 'PasswordStrengthResult(score: ${score.toStringAsFixed(2)}, level: $level, suggestions: ${suggestions.length})';
  }
}
