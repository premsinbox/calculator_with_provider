import 'package:calculator_with_provider/Model/calculator_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expressions/expressions.dart'; // Use expressions package for evaluation

// // Calculator Model using Provider
// class CalculatorModel with ChangeNotifier {
//   String _input = '';
//   String _output = '';
//   List<String> _history = [];

//   String get input => _input;
//   String get output => _output;
//   List<String> get history => _history;

//   void appendValue(String value) {
//     // Prevent continuous operators
//     if (_isOperator(value) && _isOperator(_input.isNotEmpty ? _input[_input.length - 1] : '')) {
//       return; // Ignore if the last character is also an operator
//     }
//     _input += value;
//     notifyListeners();
//   }

//   void calculateResult() {
//     if (_input.isEmpty) return; // Do not calculate if input is empty

//     try {
//       // Validate the expression
//       final expression = Expression.parse(_input);
//       final evaluator = const ExpressionEvaluator();

//       // Evaluate the expression with an empty context (empty Map)
//       var result = evaluator.eval(expression, Map<String, dynamic>());
//       _output = result.toString();

//       // Save to history
//       _history.add('$_input = $_output');
//       _input = ''; // Clear input after calculation
//       notifyListeners();
//     } catch (e) {
//       _output = 'Error'; // Handle any parsing or evaluation errors
//       notifyListeners();
//     }
// }


//   void clearAll() {
//     _input = '';
//     _output = '';
//     notifyListeners();
//   }

//   void clearLast() {
//     if (_input.isNotEmpty) {
//       _input = _input.substring(0, _input.length - 1);
//       notifyListeners();
//     }
//   }

//   void clearHistoryEntry(int index) {
//     _history.removeAt(index);
//     notifyListeners();
//   }

//   bool _isOperator(String char) {
//     return ['+', '-', '*', '/'].contains(char);
//   }
// }

// Calculator Screen
class CalculatorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                            builder: (context, model, child) => Text(
                              model.input,
                              style: TextStyle(
                                fontSize: 40,
                                color: const Color.fromARGB(255, 55, 114, 57),
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Consumer<CalculatorModel>(
                            builder: (context, model, child) => Text(
                              model.output, // Continuously updated result
                              style: TextStyle(
                                fontSize: 32,
                                color: const Color.fromARGB(217, 45, 91, 46),
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
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Consumer<CalculatorModel>(
                              builder: (context, model, child) {
                                return ListView.builder(
                                  itemCount: model.history.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(model.history[index]),
                                      trailing: IconButton(
                                        icon: Icon(Icons.clear),
                                        onPressed: () =>
                                            model.clearHistoryEntry(index),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        Provider.of<CalculatorModel>(context, listen: false)
                            .clearAll();
                      },
                      child: Text(
                        'Clear',
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.backspace),
                      onPressed: () {
                        Provider.of<CalculatorModel>(context, listen: false)
                            .clearLast();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildButtonRow(context, ['7', '8', '9', '/']),
                buildButtonRow(context, ['4', '5', '6', '*']),
                buildButtonRow(context, ['1', '2', '3', '-']),
                buildButtonRow(context, ['.', '0', '+', '='], isLastRow: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


  Padding buildButtonRow(BuildContext context, List<String> labels, {bool isLastRow = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: labels.map((label) {
          return Expanded(
            child: CalculatorButton(
              label: label,
              onTap: () {
                final model = Provider.of<CalculatorModel>(context, listen: false);
                if (label == '=') {
                  model.calculateResult();
                } else {
                  model.appendValue(label);
                }
              },
              color: label == '=' ? Colors.green : null, // Special color for '=' button
            ),
          );
        }).toList(),
      ),
    );
  }

// Calculator Button
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
        margin: EdgeInsets.all(4),
        height: 70, // Set a fixed height for buttons
        decoration: BoxDecoration(
          color: color ?? Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
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

// Main Function
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CalculatorModel(),
      child: MaterialApp(
        home: CalculatorScreen(),
      ),
    ),
  );
}
