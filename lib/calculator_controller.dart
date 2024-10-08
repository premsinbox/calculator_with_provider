import 'package:flutter/material.dart';

class CalculatorModel with ChangeNotifier {
  String _input = '';
  String _output = '';

  String get input => _input;
  String get output => _output;

  void appendValue(String value) {
    // Avoid appending duplicate or continuous operators
    if (isOperator(value) && isOperator(_input[_input.length - 1])) {
      return; // Prevent adding continuous operators
    }
    _input += value;
    notifyListeners();
    calculateResult();
  }

  void calculateResult() {
    try {
      // Here you can use a library to evaluate the expression or implement your own
      // For example, use the `expressions` package or similar
      _output = _evaluateExpression(_input).toString();
    } catch (e) {
      _output = 'Error';
    }
    notifyListeners();
  }

  void clearAll() {
    _input = '';
    _output = '';
    notifyListeners();
  }

  void clearLast() {
    if (_input.isNotEmpty) {
      _input = _input.substring(0, _input.length - 1);
      calculateResult(); // Update output after clearing
      notifyListeners();
    }
  }

  bool isOperator(String value) {
    return ['+', '-', '*', '/'].contains(value);
  }

  double _evaluateExpression(String expression) {
    // Implement your expression evaluation logic here
    // For simplicity, returning 0.0
    return 0.0;
  }
}
