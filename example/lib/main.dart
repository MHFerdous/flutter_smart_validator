import 'package:flutter/material.dart';
import 'package:flutter_smart_validator/flutter_smart_validator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Form Validator Examples',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
      home: const ExamplesHomePage(),
    );
  }
}

class ExamplesHomePage extends StatefulWidget {
  const ExamplesHomePage({super.key});

  @override
  State<ExamplesHomePage> createState() => _ExamplesHomePageState();
}

class _ExamplesHomePageState extends State<ExamplesHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    BasicFormExample(),
    AdvancedFormExample(),
    CustomValidationExample(),
    AsyncValidationExample(),
    ControllerBasedExample(),
  ];

  final List<String> _pageTitles = const [
    'Basic Form',
    'Advanced Form',
    'Custom Validation',
    'Async Validation',
    'Controller-Based',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[_selectedIndex]),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.verified_user, size: 48, color: Colors.white),
                  SizedBox(height: 8),
                  Text(
                    'Smart Form Validator',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Examples & Demos',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            ..._pageTitles.asMap().entries.map((entry) {
              return ListTile(
                leading: Icon(_getIconForIndex(entry.key)),
                title: Text(entry.value),
                selected: _selectedIndex == entry.key,
                onTap: () {
                  setState(() {
                    _selectedIndex = entry.key;
                  });
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.login;
      case 1:
        return Icons.app_registration;
      case 2:
        return Icons.code;
      case 3:
        return Icons.cloud_sync;
      case 4:
        return Icons.settings_input_component;
      default:
        return Icons.article;
    }
  }
}

// ============================================================================
// 1. Basic Form Example
// ============================================================================
class BasicFormExample extends StatefulWidget {
  const BasicFormExample({super.key});

  @override
  State<BasicFormExample> createState() => _BasicFormExampleState();
}

class _BasicFormExampleState extends State<BasicFormExample> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✓ Login successful!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Simple Login Form',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Demonstrates basic validation with required, email, and minLength rules.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: SmartValidator()
                  .required(message: 'Email is required')
                  .email()
                  .build(),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
              validator: SmartValidator()
                  .required(message: 'Password is required')
                  .minLength(
                    6,
                    message: 'Password must be at least 6 characters',
                  )
                  .build(),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// 2. Advanced Form Example (Password with Live Hints & Strength)
// ============================================================================
class AdvancedFormExample extends StatefulWidget {
  const AdvancedFormExample({super.key});

  @override
  State<AdvancedFormExample> createState() => _AdvancedFormExampleState();
}

class _AdvancedFormExampleState extends State<AdvancedFormExample> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _passwordValidator =
      SmartValidator().required().minLength(8).uppercase().lowercase().number();

  String _currentPassword = '';

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() {
      setState(() {
        _currentPassword = _passwordController.text;
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✓ Registration successful!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Registration Form',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Features live validation hints, password strength indicator, and field matching.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: SmartValidator().required().email().build(),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
              validator: _passwordValidator.build(),
            ),
            ValidationHintsList(
              hints: _passwordValidator.getLiveHints(_currentPassword),
            ),
            PasswordStrengthIndicator(
              password: _currentPassword,
              showLabel: true,
              showSuggestions: true,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
                prefixIcon: Icon(Icons.lock_outline),
              ),
              obscureText: true,
              validator: SmartValidator({
                'password': _passwordController.text,
              }).required().matchField('password', 'Password').build(),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// 3. Custom Validation Example
// ============================================================================
class CustomValidationExample extends StatefulWidget {
  const CustomValidationExample({super.key});

  @override
  State<CustomValidationExample> createState() =>
      _CustomValidationExampleState();
}

class _CustomValidationExampleState extends State<CustomValidationExample> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _ageController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✓ Form is valid!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Custom Validation',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Demonstrates custom validation rules with .custom() method.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                prefixIcon: Icon(Icons.person),
                helperText:
                    'Must start with a letter and contain only letters and numbers',
              ),
              validator: SmartValidator().required().minLength(3).custom((
                value,
              ) {
                if (value == null || value.isEmpty) return null;
                // Must start with a letter
                if (!RegExp(r'^[a-zA-Z]').hasMatch(value)) {
                  return 'Must start with a letter';
                }
                // Only letters and numbers
                if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
                  return 'Can only contain letters and numbers';
                }
                return null;
              }).build(),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _ageController,
              decoration: const InputDecoration(
                labelText: 'Age',
                prefixIcon: Icon(Icons.cake),
                helperText: 'Must be between 18 and 100',
              ),
              keyboardType: TextInputType.number,
              validator: SmartValidator()
                  .required()
                  .number(min: 18, max: 100, allowDecimals: false)
                  .build(),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// 4. Async Validation Example
// ============================================================================
class AsyncValidationExample extends StatefulWidget {
  const AsyncValidationExample({super.key});

  @override
  State<AsyncValidationExample> createState() => _AsyncValidationExampleState();
}

class _AsyncValidationExampleState extends State<AsyncValidationExample> {
  final _usernameController = TextEditingController();
  String? _asyncError;
  bool _isChecking = false;

  late final AsyncValidator _asyncValidator;

  @override
  void initState() {
    super.initState();
    _asyncValidator = AsyncValidator(
      (value) async {
        // Simulate API call
        await Future.delayed(const Duration(seconds: 1));

        // Simulate checking username availability
        final unavailableUsernames = ['admin', 'test', 'user', 'john'];
        if (unavailableUsernames.contains(value?.toLowerCase())) {
          return const ValidationResult.invalid('Username is already taken');
        }

        return const ValidationResult.valid();
      },
      debounceMilliseconds: 500,
      syncRules: [const RequiredRule(), MinLengthRule(3)],
    );

    _usernameController.addListener(_onUsernameChanged);
  }

  @override
  void dispose() {
    _asyncValidator.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _onUsernameChanged() async {
    final value = _usernameController.text;

    if (value.isEmpty) {
      setState(() {
        _asyncError = null;
        _isChecking = false;
      });
      return;
    }

    setState(() {
      _isChecking = true;
      _asyncError = null;
    });

    try {
      final result = await _asyncValidator.validate(value);
      setState(() {
        _asyncError = result.errorMessage;
        _isChecking = false;
      });
    } catch (e) {
      setState(() {
        _asyncError = 'Error checking username';
        _isChecking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Async Validation',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Demonstrates async validation with debouncing (username availability check).',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: 'Username',
              prefixIcon: const Icon(Icons.person),
              suffixIcon: _isChecking
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : _asyncError == null && _usernameController.text.isNotEmpty
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
              helperText: 'Try: admin, test, user, john (unavailable)',
            ),
          ),
          ValidationErrorText(errorMessage: _asyncError),
          const SizedBox(height: 24),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'How it works',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• Validates synchronously first (required, minLength)\n'
                    '• Debounces async validation (500ms delay)\n'
                    '• Shows loading indicator during check\n'
                    '• Simulates API call with 1 second delay',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 5. Controller-Based Example (No Widgets)
// ============================================================================
class ControllerBasedExample extends StatefulWidget {
  const ControllerBasedExample({super.key});

  @override
  State<ControllerBasedExample> createState() => _ControllerBasedExampleState();
}

class _ControllerBasedExampleState extends State<ControllerBasedExample> {
  final _emailController = TextEditingController();
  String? _validationResult;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _validateManually() {
    final validator = SmartValidator()
        .required(message: 'Email is required')
        .email()
        .minLength(5);

    final error = validator.build()(_emailController.text);

    setState(() {
      _validationResult = error ?? 'Valid!';
    });
  }

  void _validateAll() {
    final validator = SmartValidator().required().email().minLength(
          10,
          message: 'Must be at least 10 characters',
        );

    final errors = validator.validateAll(_emailController.text);

    setState(() {
      if (errors.isEmpty) {
        _validationResult = 'All validations passed!';
      } else {
        _validationResult = 'Errors:\n${errors.map((e) => '• $e').join('\n')}';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Controller-Based Validation',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Demonstrates programmatic validation without form widgets.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _validateManually,
                  icon: const Icon(Icons.check),
                  label: const Text('Validate (First Error)'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _validateAll,
                  icon: const Icon(Icons.checklist),
                  label: const Text('Validate (All Errors)'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (_validationResult != null)
            Card(
              color: _validationResult!.contains('Valid')
                  ? Colors.green[50]
                  : Colors.red[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _validationResult!.contains('Valid')
                              ? Icons.check_circle
                              : Icons.error,
                          color: _validationResult!.contains('Valid')
                              ? Colors.green[700]
                              : Colors.red[700],
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Result:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(_validationResult!),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 24),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb_outline, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Use Cases',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• Validate on button click instead of on change\n'
                    '• Get all errors at once for complex validation\n'
                    '• Integrate with state management (Bloc, Riverpod)\n'
                    '• Use with TextField instead of TextFormField',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
