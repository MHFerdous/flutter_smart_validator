import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_smart_validator/flutter_smart_validator.dart';

void main() {
  group('SmartValidator tests', () {
    test('Required rule', () {
      final validate = SmartValidator().required().build();
      expect(validate(''), 'This field is required');
      expect(validate('Hello'), null);
    });

    test('Min length', () {
      final validate = SmartValidator().minLength(5).build();
      expect(validate('abc'), 'Must be at least 5 characters');
      expect(validate('abcdef'), null);
    });

    test('Email', () {
      final validate = SmartValidator().email().build();
      expect(validate('abc'), 'Must be a valid email address');
      expect(validate('test@example.com'), null);
    });

    test('Chain multiple rules', () {
      final validate =
          SmartValidator().required().email().minLength(10).build();

      expect(validate(''), 'This field is required');
      expect(validate('abc'), 'Must be a valid email address');
      expect(validate('a@b.co'), 'Must be at least 10 characters');
      expect(validate('test@example.com'), null);
    });
  });
}
