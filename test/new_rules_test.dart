import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_smart_validator/flutter_smart_validator.dart';

void main() {
  group('New Validation Rules Tests', () {
    test('RegexRule', () {
      final validator = SmartValidator()
          .regex(RegExp(r'^[A-Z]{3,5}$'), message: 'Must be 3-5 uppercase letters')
          .build();
      
      expect(validator('ABC'), null);
      expect(validator('ABCDE'), null);
      expect(validator('AB'), 'Must be 3-5 uppercase letters');
      expect(validator('abc'), 'Must be 3-5 uppercase letters');
    });

    test('UrlRule', () {
      final validator = SmartValidator().url().build();
      
      expect(validator('https://google.com'), null);
      expect(validator('http://example.co.uk/path'), null);
      expect(validator('ftp://server.io'), null);
      expect(validator('not-a-url'), 'Must be a valid URL');
      expect(validator('http://'), 'Must be a valid URL');
    });

    test('CreditCardRule', () {
      final validator = SmartValidator().creditCard().build();
      
      // Some valid card numbers for testing (mock)
      expect(validator('4242 4242 4242 4242'), null); // Visa
      expect(validator('5555 5555 5555 4444'), null); // Mastercard
      expect(validator('1234 5678 1234 5678'), 'Invalid credit card number');
      expect(validator(''), null); // Let required() handle it
    });

    test('PhoneRule', () {
      final validator = SmartValidator().phone().build();
      
      expect(validator('+1234567890'), null);
      expect(validator('1234567890'), null);
      expect(validator('+1 (234) 567-890'), null); // Normalized internally
      expect(validator('123'), 'Invalid phone number');
      expect(validator('abc'), 'Invalid phone number');
    });
  });
}
