import 'package:flutter/material.dart';
import 'package:flutter_smart_validator/flutter_smart_validator.dart';

void main() {
  const rule = PhoneRule();
  debugPrint('Testing abc: ${rule.validate("abc")}');

  final regex = RegExp(r'^\+?[1-9]\d{1,14}$');
  debugPrint('Regex match abc: ${regex.hasMatch("abc")}');
}
