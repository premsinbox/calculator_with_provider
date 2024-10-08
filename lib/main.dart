import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:provider/provider.dart';

class CalculatorModel with ChangeNotifier {
  String _expression = '';
  String _result = '0';
  List<String> _history = [];

  String get expression => _expression;
  String get result => _result;
  List<String> get history => _history;

  void appendValue(String value) {
    if (isOperator(value) && _expression.isNotEmpty && isOperator(_expression[_expression.length - 1])) {
      return;
    }

    if (value == 'C') {
      clearAll();
    } else if (value == '=') {
      _calculateResult();
      if (_result != 'Error') {
        _history.add('$_expression = $_result');
      }
    } else {
      _expression += value;
      _calculateResult();
    }
    notifyListeners();
  }

  bool isOperator(String value) {
    return value == '+' || value == '-' || value == '*' || value == '/';
  }

  void _calculateResult() {
    if (_expression.isEmpty) {
      _result = '0';
      return;
    }

    try {
      Parser p = Parser();
      Expression exp = p.parse(_expression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      
      _result = eval == eval.toInt() ? eval.toInt().toString() : eval.toStringAsFixed(2);
    } catch (e) {
      _result = 'Error';
    }
  }

  void clearLast() {
    if (_expression.isNotEmpty) {
      _expression = _expression.substring(0, _expression.length - 1);
      _calculateResult();
      notifyListeners();
    }
  }

  void clearHistoryEntry(int index) {
    if (index >= 0 && index < _history.length) {
      _history.removeAt(index);
      notifyListeners();
    }
  }

  void clearAll() {
    _expression = '';
    _result = '0';
    notifyListeners();
  }

  void clearHistory() {
    _history.clear();
    notifyListeners();
  }
}

class CalculatorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      reverse: true,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Consumer<CalculatorModel>(
                              builder: (context, calculator, child) => Text(
                                calculator.expression,
                                style: TextStyle(
                                  fontSize: 40,
                                  color: Color.fromARGB(255, 55, 114, 57),
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Consumer<CalculatorModel>(
                              builder: (context, calculator, child) => Text(
                                calculator.result,
                                style: TextStyle(
                                  fontSize: 32,
                                  color: Color.fromARGB(217, 45, 91, 46),
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(Icons.history),
                        onPressed: () => _showHistory(context),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.read<CalculatorModel>().clearAll();
                        },
                        child: Text(
                          'Clear',
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.backspace),
                        onPressed: context.read<CalculatorModel>().clearLast,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildButtonRow(['7', '8', '9', '/'], context),
                  _buildButtonRow(['4', '5', '6', '*'], context),
                  _buildButtonRow(['1', '2', '3', '-'], context),
                  _buildButtonRow(['0', '.', '+', '='], context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonRow(List<String> labels, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: labels.map((label) {
        return CalculatorButton(
          label: label,
          onTap: () => context.read<CalculatorModel>().appendValue(label),
        );
      }).toList(),
    );
  }

  void _showHistory(BuildContext context) {
    final calculatorModel = context.read<CalculatorModel>();
    if (calculatorModel.history.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('History is empty!')),
      );
    } else {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'History',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Consumer<CalculatorModel>(
                    builder: (context, calculator, child) => ListView.builder(
                      itemCount: calculator.history.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(calculator.history[index]),
                          trailing: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () => calculator.clearHistoryEntry(index),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                ElevatedButton(
                  child: Text('Clear All History'),
                  onPressed: () {
                    calculatorModel.clearHistory();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }
}

class CalculatorButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color? color;

  CalculatorButton({required this.label, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.fromLTRB(4, 0, 4, 0),
        height: 70,
        decoration: BoxDecoration(
          color: color ?? Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(fontSize: 36),
          ),
        ),
      ),
    );
  }
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ChangeNotifierProvider(
        create: (_) => CalculatorModel(),
        child: CalculatorScreen(),
      ),
    );
  }
}

void main() {
  runApp(CalculatorApp());
}