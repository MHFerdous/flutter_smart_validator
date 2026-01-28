import 'package:flutter/material.dart';

/// A widget that displays validation error messages with smooth animations.
///
/// Automatically hides when there's no error and theme-aware with customizable styling.
///
/// Example:
/// ```dart
/// ValidationErrorText(
///   errorMessage: validationError,
/// )
/// ```
class ValidationErrorText extends StatelessWidget {
  /// The error message to display. Set to null to hide.
  final String? errorMessage;

  /// Custom text style. If null, uses theme's error color with bodySmall.
  final TextStyle? style;

  /// Icon to show before the error message.
  final IconData? icon;

  /// Padding around the error text.
  final EdgeInsets padding;

  /// Animation duration for fade in/out.
  final Duration animationDuration;

  const ValidationErrorText({
    super.key,
    required this.errorMessage,
    this.style,
    this.icon = Icons.error_outline,
    this.padding = const EdgeInsets.only(top: 6, left: 12),
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveStyle =
        style ??
        theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error);

    return AnimatedSwitcher(
      duration: animationDuration,
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            axisAlignment: -1,
            child: child,
          ),
        );
      },
      child: errorMessage == null || errorMessage!.isEmpty
          ? const SizedBox.shrink()
          : Padding(
              padding: padding,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 16, color: theme.colorScheme.error),
                    const SizedBox(width: 6),
                  ],
                  Expanded(child: Text(errorMessage!, style: effectiveStyle)),
                ],
              ),
            ),
    );
  }
}
