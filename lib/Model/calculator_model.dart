import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart'; // Use expressions package for evaluation

// Calculator Model using Provider
class CalculatorModel with ChangeNotifier {
  String _input = '';
  String _output = '';
  List<String> _history = [];

  String get input => _input;
  String get output => _output;
  List<String> get history => _history;

  void appendValue(String value) {
    // Prevent continuous operators
    if (_isOperator(value) && _isOperator(_input.isNotEmpty ? _input[_input.length - 1] : '')) {
      return; // Ignore if the last character is also an operator
    }
    _input += value;
    _evaluateExpression(); // Evaluate the expression continuously
    notifyListeners();
  }

  void _evaluateExpression() {
    if (_input.isEmpty) {
      _output = ''; // Clear output if input is empty
      return;
    }

    try {
      // Parse and evaluate the expression
      final expression = Expression.parse(_input);
      final evaluator = const ExpressionEvaluator();

      // Evaluate the expression with an empty context (empty Map)
      var result = evaluator.eval(expression, Map<String, dynamic>());
      _output = result.toString();
    } catch (e) {
      _output = ''; // Clear the output if there's an error
    }
  }

  void calculateResult() {
    if (_input.isEmpty) return; // Do not calculate if input is empty

    try {
      // Parse and evaluate the expression
      final expression = Expression.parse(_input);
      final evaluator = const ExpressionEvaluator();

      // Evaluate the expression with an empty context (empty Map)
      var result = evaluator.eval(expression, Map<String, dynamic>());
      _output = result.toString();

      // Save to history
      _history.add('$_input = $_output');
      _input = ''; // Clear input after calculation
      notifyListeners();
    } catch (e) {
      _output = 'Error'; // Handle any parsing or evaluation errors
      notifyListeners();
    }
  }

  void clearAll() {
    _input = '';
    _output = '';
    notifyListeners();
  }

  void clearLast() {
    if (_input.isNotEmpty) {
      _input = _input.substring(0, _input.length - 1);
      _evaluateExpression(); // Update the result after removing a character
      notifyListeners();
    }
  }

  void clearHistoryEntry(int index) {
    _history.removeAt(index);
    notifyListeners();
  }

  bool _isOperator(String char) {
    return ['+', '-', '*', '/'].contains(char);
  }
}
