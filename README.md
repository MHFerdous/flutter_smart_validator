# Smart Form Validator

[![pub package](https://img.shields.io/pub/v/flutter_smart_validator.svg)](https://pub.dev/packages/flutter_smart_validator)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/platform-flutter-blue.svg)](https://flutter.dev/)

A **clean, chainable, and developer-friendly** form validation package for Flutter. Build complex validation rules with minimal boilerplate using a fluent API.

```dart
// Simple, elegant, powerful
TextFormField(
  validator: SmartValidator()
      .required()
      .email()
      .minLength(8)
      .build(),
)
```

---

## ✨ Why Smart Form Validator?

| Problem                     | Solution                                           |
| --------------------------- | -------------------------------------------------- |
| 😫 Verbose validation code  | ✅ **Chainable API** - One line, infinite rules    |
| 🔁 Repetitive boilerplate   | ✅ **Built-in rules** - 9+ validators ready to use |
| 📡 Complex async validation | ✅ **Debounced async** - API calls made simple     |
| 🎨 Inconsistent UI feedback | ✅ **Optional widgets** - Beautiful, consistent UI |
| 🔧 Hard to customize        | ✅ **Custom rules** - Add any validation logic     |
| 📚 Poor documentation       | ✅ **5 example demos** - Learn by doing            |

---

## 🚀 Features

### Core Capabilities

- ⛓️ **Fluent Chainable API** - Readable, maintainable validation rules
- 📦 **9+ Built-in Rules** - Required, email, length, number, case, matching, and more
- 🔌 **Custom Validation** - Extend with your own logic in seconds
- ⚡ **Async Support** - Debounced API validation (username availability, etc.)
- 💡 **Live Hints** - Real-time feedback as users type
- 🎨 **UI Widgets** - Pre-built components for errors, hints, and password strength
- 🔗 **Field Matching** - Password confirmation made easy
- 🌍 **Platform Agnostic** - Works everywhere Flutter runs
- 📱 **Zero Dependencies** - Only requires Flutter SDK

### Developer Experience

- 🎯 **Type-safe** - Null safety and strong typing
- 📖 **Well-documented** - Clear examples and API docs
- 🧪 **Tested** - Comprehensive unit tests
- 🔄 **Flexible** - Use with forms, controllers, or standalone
- 🎓 **Easy to learn** - Start validating in 60 seconds

---

## 📦 Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_smart_validator: ^0.0.1
```

Then install:

```bash
flutter pub get
```

Import in your Dart file:

```dart
import 'package:flutter_smart_validator/flutter_smart_validator.dart';
```

---

## 🎯 Quick Start

### Basic Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_smart_validator/flutter_smart_validator.dart';

class LoginForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Email'),
            validator: SmartValidator()
                .required(message: 'Email is required')
                .email()
                .build(),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: SmartValidator()
                .required()
                .minLength(8)
                .uppercase()
                .number()
                .build(),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Form is valid - proceed with login
              }
            },
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}
```

**That's it!** 🎉 You now have elegant, powerful validation with minimal code.

---

## 📚 Built-in Validation Rules

| Rule           | Description                       | Example                               |
| -------------- | --------------------------------- | ------------------------------------- |
| `required()`   | Field cannot be empty             | `.required(message: 'Required')`      |
| `email()`      | Valid email format                | `.email()`                            |
| `minLength(n)` | Minimum n characters              | `.minLength(8)`                       |
| `maxLength(n)` | Maximum n characters              | `.maxLength(50)`                      |
| `number()`     | Numeric value with optional range | `.number(min: 0, max: 100)`           |
| `uppercase()`  | Contains uppercase letters        | `.uppercase(minCount: 2)`             |
| `lowercase()`  | Contains lowercase letters        | `.lowercase(minCount: 1)`             |
| `matchField()` | Matches another field value       | `.matchField('password', 'Password')` |
| `custom()`     | Your custom logic                 | `.custom((v) => /* logic */)`         |

### Chaining Rules

Combine any rules together:

```dart
SmartValidator()
  .required()
  .email()
  .minLength(10)
  .maxLength(100)
  .build()
```

---

## 🌟 Advanced Features

### 1. Live Validation Hints

Show progressive feedback as users type:

```dart
class PasswordField extends StatefulWidget {
  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  final _validator = SmartValidator()
      .required()
      .minLength(8)
      .uppercase()
      .lowercase()
      .number();

  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          onChanged: (value) => setState(() => _password = value),
          validator: _validator.build(),
        ),
        ValidationHintsList(
          hints: _validator.getLiveHints(_password),
        ),
      ],
    );
  }
}
```

### 2. Password Strength Indicator

```dart
PasswordStrengthIndicator(
  password: currentPassword,
  showLabel: true,
  showSuggestions: true,
)
```

### 3. Async Validation (API Calls)

Perfect for checking username/email availability:

```dart
final asyncValidator = AsyncValidator(
  (value) async {
    // Call your API
    final response = await checkUsernameAvailability(value);

    if (response.isTaken) {
      return ValidationResult.invalid('Username is taken');
    }
    return ValidationResult.valid();
  },
  debounceMilliseconds: 500,  // Prevents excessive API calls
  syncRules: [
    RequiredRule(),
    MinLengthRule(3),
  ],
);

// Use it
final result = await asyncValidator.validate('john_doe');
```

### 4. Custom Validation Rules

Add any logic you need:

```dart
TextFormField(
  validator: SmartValidator()
      .required()
      .custom((value) {
        if (!value!.endsWith('@company.com')) {
          return 'Must be a company email';
        }
        return null;  // Valid
      })
      .build(),
)
```

### 5. Field Matching (Password Confirmation)

```dart
final passwordController = TextEditingController();

// Password field
TextFormField(
  controller: passwordController,
  validator: SmartValidator().required().minLength(8).build(),
)

// Confirm password field
TextFormField(
  validator: SmartValidator({
    'password': passwordController.text,  // Context
  })
      .required()
      .matchField('password', 'Password')
      .build(),
)
```

### 6. Get All Errors

Instead of stopping at the first error:

```dart
final validator = SmartValidator()
    .required()
    .email()
    .minLength(10);

final errors = validator.validateAll('abc');
// Returns: ['Must be a valid email address', 'Minimum length is 10']
```

---

## 🎨 Optional UI Widgets

Pre-built, customizable components for common validation UI patterns:

### ValidationErrorText

```dart
ValidationErrorText(
  errorMessage: 'Password must be at least 8 characters',
)
```

### ValidationHintsList

```dart
ValidationHintsList(
  hints: validator.getLiveHints(currentValue),
  showIcons: true,
  successColor: Colors.green,
  errorColor: Colors.red,
)
```

### PasswordStrengthIndicator

```dart
PasswordStrengthIndicator(
  password: currentPassword,
  showLabel: true,
  showSuggestions: true,
)
```

### SmartFormField

A complete form field with built-in error display and hint support.

---

## 📱 Platform Support

Smart Form Validator works on **all Flutter platforms**:

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

---

## 🎓 Examples

The package includes **5 complete example apps** demonstrating all features:

1. **Basic Form** - Simple login with email and password
2. **Advanced Form** - Registration with live hints and password strength
3. **Custom Validation** - Custom rules for username format and age validation
4. **Async Validation** - Username availability check with debouncing
5. **Controller-Based** - Programmatic validation without forms

### Run the Examples

```bash
cd example
flutter run
```

Or try on web:

```bash
cd example
flutter run -d chrome
```

---

## 💡 Usage Patterns

### With TextFormField (Recommended)

```dart
TextFormField(
  validator: SmartValidator().required().email().build(),
)
```

### Standalone Validation

```dart
final validator = SmartValidator().required().email();
final error = validator.build()('user@example.com');  // null if valid
```

### With State Management

```dart
// In your Bloc/Provider/Controller
final emailValidator = SmartValidator().required().email();

void validateEmail(String email) {
  final error = emailValidator.build()(email);
  if (error != null) {
    emit(ValidationError(error));
  }
}
```

---

## 🔧 API Reference

### SmartValidator

Main validator class with chainable methods.

```dart
SmartValidator([Map<String, dynamic>? context])
```

**Methods:**

- `required({String? message})` - Required field validation
- `email({String? message})` - Email format validation
- `minLength(int length, {String? message})` - Minimum length
- `maxLength(int length, {String? message})` - Maximum length
- `number({num? min, num? max, bool allowDecimals, String? message})` - Number validation
- `uppercase({int minCount, String? message})` - Uppercase letter requirement
- `lowercase({int minCount, String? message})` - Lowercase letter requirement
- `matchField(String key, String name, {String? message})` - Field matching
- `custom(Function validator, {String? message, Function? hintsGenerator})` - Custom rule
- `build()` - Build the validator function
- `validateAll(String? value)` - Get all validation errors
- `getLiveHints(String? value)` - Get live validation hints

### AsyncValidator

Async validation with debouncing.

```dart
AsyncValidator(
  Future<ValidationResult> Function(String?) validator,
  {int debounceMilliseconds = 300,
  List<ValidationRule> syncRules = const []}
)
```

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### How to Contribute

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Support

If you find this package helpful, please:

- ⭐ Star the repository
- 🐛 Report bugs and issues
- 💡 Suggest new features
- 📢 Share with other Flutter developers

---

## 📞 Contact & Links

- 📦 [Pub.dev Package](https://pub.dev/packages/flutter_smart_validator)
- 📖 [API Documentation](https://pub.dev/documentation/flutter_smart_validator/latest/)
- 🐛 [Issue Tracker](https://github.com/yourusername/flutter_smart_validator/issues)
- 💬 [Discussions](https://github.com/yourusername/flutter_smart_validator/discussions)

---

<p align="center">Made with ❤️ for the Flutter community</p>
