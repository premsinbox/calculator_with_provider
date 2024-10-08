// import 'package:calculator_with_provider/calculator_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class CalculatorScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => CalculatorProvider(),
//       child: Scaffold(
//         body: Column(
//           children: [
//             Expanded(
//               flex: 3,
//               child: Column(
//                 children: [
//                   Expanded(
//                     child: SingleChildScrollView(
//                       reverse: true,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Consumer<CalculatorProvider>(
//                               builder: (context, provider, child) => Text(
//                                 provider.input, // Correctly binding to input state
//                                 style: TextStyle(
//                                   fontSize: 40,
//                                   color: const Color.fromARGB(255, 55, 114, 57),
//                                 ),
//                                 textAlign: TextAlign.right,
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Consumer<CalculatorProvider>(
//                               builder: (context, provider, child) => Text(
//                                 provider.output, // Correctly binding to output state
//                                 style: TextStyle(
//                                   fontSize: 32,
//                                   color: const Color.fromARGB(217, 45, 91, 46),
//                                 ),
//                                 textAlign: TextAlign.right,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Divider(),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       IconButton(
//                         icon: Icon(Icons.history),
//                         onPressed: () {
//                           showModalBottomSheet(
//                             context: context,
//                             builder: (context) {
//                               return Container(
//                                 child: Consumer<CalculatorProvider>(
//                                   builder: (context, provider, child) =>
//                                       ListView.builder(
//                                     itemCount: provider.history.length,
//                                     itemBuilder: (context, index) {
//                                       return ListTile(
//                                         title: Text(provider.history[index]),
//                                         trailing: IconButton(
//                                           icon: Icon(Icons.clear),
//                                           onPressed: () =>
//                                               provider.clearHistoryEntry(index),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                               );
//                             },
//                           );
//                         },
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           Provider.of<CalculatorProvider>(context, listen: false)
//                               .clearAll(); // Clear all input/output
//                         },
//                         child: Text(
//                           'Clear',
//                           style: TextStyle(
//                               fontSize: 25, fontWeight: FontWeight.w500),
//                         ),
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.backspace),
//                         onPressed: () {
//                           Provider.of<CalculatorProvider>(context, listen: false)
//                               .clearLast(); // Clear last character
//                         },
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               flex: 2,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   buildButtonRow(context, ['7', '8', '9', '/']),
//                   buildButtonRow(context, ['4', '5', '6', '*']),
//                   buildButtonRow(context, ['1', '2', '3', '-']),
//                   buildButtonRow(context, ['.', '0', '+', '=']),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Row buildButtonRow(BuildContext context, List<String> labels) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: labels.map((label) {
//         return Expanded(
//           child: CalculatorButton(
//             label: label,
//             onTap: () {
//               final provider = Provider.of<CalculatorProvider>(context, listen: false);

//               if (label == '=') {
//                 provider.calculateResult(); // Calculate the result when `=` is tapped
//               } else {
//                 provider.appendValue(label); // Append number/operator to the input
//               }
//             },
//             color: label == '=' ? Colors.green : null,
//           ),
//         );
//       }).toList(),
//     );
//   }
// }

// class CalculatorButton extends StatelessWidget {
//   final String label;
//   final VoidCallback onTap;
//   final Color? color;

//   CalculatorButton({required this.label, required this.onTap, this.color});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: EdgeInsets.all(4.0),
//         height: 70,
//         decoration: BoxDecoration(
//           color: color ?? Colors.grey[200],
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Center(
//           child: Text(
//             label,
//             style: TextStyle(fontSize: 36),
//           ),
//         ),
//       ),
//     );
//   }
// }
