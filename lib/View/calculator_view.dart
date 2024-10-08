import 'package:calculator_with_provider/Model/calculator_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


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
                              model.output, 
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
              color: label == '=' ? Colors.green : null,
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
        height: 70, 
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