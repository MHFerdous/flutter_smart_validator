## 0.0.1 - 2026-01-28

### 🎉 Initial Release

A clean, chainable, and developer-friendly form validation package for Flutter.

#### ✨ Features Added

**Core Validation**

- Fluent, chainable API for building validators (`SmartValidator().required().email().build()`)
- Context-aware validation support for field matching
- Validate single error or all errors at once
- Works with `TextFormField` and standalone controllers

**Built-in Validation Rules**

- `required()` - Field cannot be empty or whitespace
- `email()` - Valid email format validation
- `minLength(int)` - Minimum character length
- `maxLength(int)` - Maximum character length
- `number(min, max, allowDecimals)` - Numeric validation with range support
- `uppercase(minCount)` - Requires uppercase letters
- `lowercase(minCount)` - Requires lowercase letters
- `matchField(key, name)` - Field matching (password confirmation)
- `custom(validator)` - Custom validation function support

**Async Validation**

- `AsyncValidator` class for API-based validation
- Built-in debouncing to prevent excessive API calls
- Synchronous pre-validation before async calls
- Username/email availability checking support

**User Experience**

- Live validation hints with `getLiveHints()`
- Progressive feedback as users type
- Password strength calculation and utilities
- Clear, customizable error messages

**Optional UI Widgets**

- `ValidationErrorText` - Styled error message display
- `ValidationHintsList` - Live validation hints with icons
- `PasswordStrengthIndicator` - Visual password strength meter
- `SmartFormField` - Complete form field with built-in validation UI

**Developer Experience**

- Zero external dependencies (Flutter SDK only)
- Comprehensive documentation and examples
- 5 complete example demos included
- Full unit test coverage
- Type-safe API with null safety

#### 📚 Documentation

- Complete README with installation and usage guides
- API documentation for all public methods
- Code examples for every feature
- Example app demonstrating all capabilities

#### 🎨 Example App Demos

1. Basic login form with email and password validation
2. Advanced registration with live hints and password strength
3. Custom validation rules (username format, age range)
4. Async validation (username availability check)
5. Controller-based programmatic validation

#### 🏗️ Package Structure

```
lib/
├── smart_form_validator.dart       # Main export file
└── src/
    ├── smart_validator.dart        # Core validator class
    ├── async/
    │   └── async_validator.dart    # Async validation support
    ├── models/
    │   ├── validation_result.dart  # Validation result model
    │   └── validation_rule.dart    # Base validation rule
    ├── rules/                      # Built-in validation rules
    ├── utils/
    │   └── password_strength.dart  # Password utilities
    └── widgets/                    # Optional UI components
```

#### 📱 Platform Support

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

#### 🔧 Requirements

- Dart SDK: >=3.0.0 <4.0.0
- Flutter: >=3.0.0

---

### Future Roadmap

Planned features for upcoming releases:

- Phone number validation rules
- Credit card validation
- URL validation
- RegExp pattern validation helpers
- Conditional validation (validate if...)
- Multi-field validation groups
- Internationalization (i18n) support for error messages
