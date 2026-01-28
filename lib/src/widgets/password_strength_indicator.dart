import 'package:flutter/material.dart';
import '../utils/password_strength.dart';

/// A visual password strength indicator with color gradient and label.
///
/// Displays a progress bar that changes color based on password strength
/// (red → orange → yellow → green) with a text label.
///
/// Example:
/// ```dart
/// PasswordStrengthIndicator(
///   password: passwordController.text,
/// )
/// ```
class PasswordStrengthIndicator extends StatelessWidget {
  /// The password to analyze.
  final String password;

  /// Whether to show the strength label (Weak, Medium, Strong).
  final bool showLabel;

  /// Whether to show the score percentage.
  final bool showScore;

  /// Whether to show improvement suggestions.
  final bool showSuggestions;

  /// Height of the strength bar.
  final double barHeight;

  /// Border radius of the strength bar.
  final double borderRadius;

  /// Custom text style for the label.
  final TextStyle? labelStyle;

  /// Padding around the widget.
  final EdgeInsets padding;

  const PasswordStrengthIndicator({
    super.key,
    required this.password,
    this.showLabel = true,
    this.showScore = false,
    this.showSuggestions = false,
    this.barHeight = 6,
    this.borderRadius = 3,
    this.labelStyle,
    this.padding = const EdgeInsets.only(top: 8, left: 12, right: 12),
  });

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) {
      return const SizedBox.shrink();
    }

    final result = PasswordStrength.analyze(password);
    final theme = Theme.of(context);
    final color = _getColorFromHex(result.colorHint);

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progress bar
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: barHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: theme.colorScheme.surfaceContainerHighest,
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: result.score,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  gradient: LinearGradient(
                    colors: [color, color.withValues(alpha: 0.8)],
                  ),
                ),
              ),
            ),
          ),

          // Label and score
          if (showLabel || showScore) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                if (showLabel)
                  Text(
                    result.level,
                    style:
                        labelStyle ??
                        theme.textTheme.bodySmall?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                  ),
                if (showLabel && showScore) const SizedBox(width: 8),
                if (showScore)
                  Text(
                    '${(result.score * 100).toInt()}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ],

          // Suggestions
          if (showSuggestions && result.suggestions.isNotEmpty) ...[
            const SizedBox(height: 6),
            ...result.suggestions.map(
              (suggestion) => Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 12,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        suggestion,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getColorFromHex(String hexColor) {
    final hex = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }
}
