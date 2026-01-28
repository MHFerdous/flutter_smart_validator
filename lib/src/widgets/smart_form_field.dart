import 'package:flutter/material.dart';
import '../smart_validator.dart';
import 'validation_error_text.dart';
import 'validation_hints_list.dart';

/// An optional wrapper widget that combines TextFormField with validation feedback.
///
/// This is a convenience widget - you can always use your own custom UI.
/// Provides automatic error display and optional live hints.
///
/// Example:
/// ```dart
/// SmartFormField(
///   validator: SmartValidator().required().email().build(),
///   decoration: InputDecoration(labelText: 'Email'),
/// )
/// ```
class SmartFormField extends StatefulWidget {
  /// The validator function for this field.
  final String? Function(String?)? validator;

  /// The SmartValidator instance for live hints (optional).
  final SmartValidator? smartValidator;

  /// The controller for the text field.
  final TextEditingController? controller;

  /// Input decoration for the text field.
  final InputDecoration? decoration;

  /// Whether to show live validation hints as the user types.
  final bool showLiveHints;

  /// Whether to show error messages automatically.
  final bool showErrors;

  /// Initial value for the text field.
  final String? initialValue;

  /// Keyboard type.
  final TextInputType? keyboardType;

  /// Whether the field is obscured (for passwords).
  final bool obscureText;

  /// Text input action.
  final TextInputAction? textInputAction;

  /// Auto-validate mode.
  final AutovalidateMode? autovalidateMode;

  /// On changed callback.
  final void Function(String)? onChanged;

  /// On submitted callback.
  final void Function(String)? onFieldSubmitted;

  /// Maximum lines.
  final int? maxLines;

  /// Minimum lines.
  final int? minLines;

  /// Maximum length.
  final int? maxLength;

  /// Whether the field is enabled.
  final bool enabled;

  const SmartFormField({
    super.key,
    this.validator,
    this.smartValidator,
    this.controller,
    this.decoration,
    this.showLiveHints = false,
    this.showErrors = true,
    this.initialValue,
    this.keyboardType,
    this.obscureText = false,
    this.textInputAction,
    this.autovalidateMode,
    this.onChanged,
    this.onFieldSubmitted,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.enabled = true,
  });

  @override
  State<SmartFormField> createState() => _SmartFormFieldState();
}

class _SmartFormFieldState extends State<SmartFormField> {
  late TextEditingController _controller;
  String? _currentError;
  List<String> _currentHints = [];
  bool _isOwnController = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _isOwnController = widget.controller == null;

    if (widget.showLiveHints && widget.smartValidator != null) {
      _controller.addListener(_updateLiveHints);
    }
  }

  @override
  void didUpdateWidget(SmartFormField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      if (_isOwnController) {
        _controller.dispose();
      }
      _controller = widget.controller ?? TextEditingController();
      _isOwnController = widget.controller == null;

      if (widget.showLiveHints && widget.smartValidator != null) {
        _controller.addListener(_updateLiveHints);
      }
    }
  }

  @override
  void dispose() {
    if (_isOwnController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _updateLiveHints() {
    if (widget.smartValidator != null) {
      setState(() {
        _currentHints = widget.smartValidator!.getLiveHints(_controller.text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: _controller,
          initialValue: widget.initialValue,
          decoration: widget.decoration,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          textInputAction: widget.textInputAction,
          autovalidateMode: widget.autovalidateMode,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          enabled: widget.enabled,
          validator: (value) {
            final error = widget.validator?.call(value);
            setState(() {
              _currentError = error;
            });
            return widget.showErrors
                ? null
                : error; // Return null to prevent default error display
          },
          onChanged: (value) {
            if (widget.showLiveHints && widget.smartValidator != null) {
              _updateLiveHints();
            }
            widget.onChanged?.call(value);
          },
          onFieldSubmitted: widget.onFieldSubmitted,
        ),

        // Custom error display
        if (widget.showErrors) ValidationErrorText(errorMessage: _currentError),

        // Live hints
        if (widget.showLiveHints && _currentHints.isNotEmpty)
          ValidationHintsList(hints: _currentHints),
      ],
    );
  }
}
