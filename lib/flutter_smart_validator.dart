library;

// Core
export 'src/smart_validator.dart';

// Models
export 'src/models/validation_result.dart';
export 'src/models/validation_rule.dart';

// Rules - All built-in validation rules
export 'src/rules/required_rule.dart';
export 'src/rules/min_length_rule.dart';
export 'src/rules/max_length_rule.dart';
export 'src/rules/email_rule.dart';
export 'src/rules/number_rule.dart';
export 'src/rules/uppercase_rule.dart';
export 'src/rules/lowercase_rule.dart';
export 'src/rules/match_field_rule.dart';
export 'src/rules/custom_rule.dart';

// Async validation
export 'src/async/async_validator.dart';

// Utils
export 'src/utils/password_strength.dart';

// Widgets (optional UI helpers)
export 'src/widgets/validation_error_text.dart';
export 'src/widgets/validation_hints_list.dart';
export 'src/widgets/password_strength_indicator.dart';
export 'src/widgets/smart_form_field.dart';
