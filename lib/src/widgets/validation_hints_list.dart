import 'package:flutter/material.dart';

/// A widget that displays live validation hints as a checklist.
///
/// Shows checkmarks for satisfied requirements and X marks for unsatisfied ones.
/// Perfect for password requirements or progressive validation feedback.
///
/// Example:
/// ```dart
/// ValidationHintsList(
///   hints: validator.getLiveHints(currentValue),
/// )
/// ```
class ValidationHintsList extends StatelessWidget {
  /// The list of validation hints to display.
  final List<String> hints;

  /// Whether to show icons (checkmark/X) before each hint.
  final bool showIcons;

  /// Custom color for satisfied hints (those starting with ✓).
  final Color? successColor;

  /// Custom color for unsatisfied hints (those starting with ✗).
  final Color? errorColor;

  /// Custom text style for hints.
  final TextStyle? textStyle;

  /// Padding around the hints list.
  final EdgeInsets padding;

  /// Spacing between hint items.
  final double spacing;

  const ValidationHintsList({
    super.key,
    required this.hints,
    this.showIcons = true,
    this.successColor,
    this.errorColor,
    this.textStyle,
    this.padding = const EdgeInsets.only(top: 8, left: 12),
    this.spacing = 4,
  });

  @override
  Widget build(BuildContext context) {
    if (hints.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final effectiveSuccessColor = successColor ?? Colors.green[700];
    final effectiveErrorColor = errorColor ?? theme.colorScheme.error;
    final effectiveTextStyle =
        textStyle ?? theme.textTheme.bodySmall?.copyWith(fontSize: 12);

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: hints.asMap().entries.map((entry) {
          final hint = entry.value;
          final isSatisfied = hint.startsWith('✓');
          final isUnsatisfied = hint.startsWith('✗');

          // Remove the ✓ or ✗ marker if present
          final displayText = isSatisfied || isUnsatisfied
              ? hint.substring(1).trim()
              : hint;

          final iconData = isSatisfied
              ? Icons.check_circle
              : isUnsatisfied
              ? Icons.cancel
              : Icons.circle_outlined;

          final iconColor = isSatisfied
              ? effectiveSuccessColor
              : isUnsatisfied
              ? effectiveErrorColor
              : theme.colorScheme.onSurface.withValues(alpha: 0.5);

          return Padding(
            padding: EdgeInsets.only(
              bottom: entry.key < hints.length - 1 ? spacing : 0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showIcons) ...[
                  Icon(iconData, size: 14, color: iconColor),
                  const SizedBox(width: 6),
                ],
                Expanded(
                  child: Text(
                    displayText,
                    style: effectiveTextStyle?.copyWith(
                      color: isSatisfied
                          ? effectiveSuccessColor
                          : isUnsatisfied
                          ? effectiveErrorColor
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
