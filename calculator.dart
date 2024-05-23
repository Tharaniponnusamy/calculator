import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      home: CalculatorHome(),
    );
  }
}

class CalculatorHome extends StatefulWidget {
  @override
  _CalculatorHomeState createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  String expression = '';

  void onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        expression = '';
      } else if (value == '=') {
        try {
          final evalResult = _evaluateExpression(expression);
          expression = evalResult.toString();
        } catch (e) {
          expression = 'Error';
        }
      } else if (value == 'X') {
        if (expression.isNotEmpty) {
          expression = expression.substring(0, expression.length - 1);
        }
      } else {
        expression += value;
      }
    });
  }

  double _evaluateExpression(String expr) {
    final parser = Parser();
    final context = ContextModel();
    final expression = parser.parse(expr);
    return expression.evaluate(EvaluationType.REAL, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20.0),
              color: Color.fromARGB(255, 248, 251, 252),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    expression,
                    style: TextStyle(fontSize: 40.0, color: Colors.black),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Color.fromARGB(255, 0, 0, 0),
            padding: EdgeInsets.all(15.0),
            child: Column(
              children: [
                buildRow(['7', '8', '9', '/']),
                SizedBox(height: 10),
                buildRow(['4', '5', '6', '*']),
                SizedBox(height: 10),
                buildRow(['1', '2', '3', '-']),
                SizedBox(height: 10),
                buildRow(['.', '0', '=', '+']),
                SizedBox(height: 20),
                Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    Expanded(
      flex: 2, // Expanded width for 'C'
      child: buildButton('C', Colors.red, Colors.white),
    ),
    SizedBox(width: 10), // Optional: Add space between buttons
    Expanded(
      flex: 2, // Expanded width for 'X'
      child: buildButton('X', Color.fromARGB(255, 156, 156, 38), Colors.white),
    ),
  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRow(List<String> labels) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10), // Horizontal padding around the row
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: labels.map((label) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5), // Padding between buttons
              child: buildButton(label, _getButtonColor(label), _getButtonTextColor(label)),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget buildButton(String label, Color buttonColor, Color textColor) {
    return ElevatedButton(
      onPressed: () => onButtonPressed(label),
      child: Text(label, style: TextStyle(fontSize: 24, color: textColor)),
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        padding: EdgeInsets.all(15), // Padding around the button
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Rounded corners
        ),
      ),
    );
  }

  Color _getButtonColor(String label) {
    switch (label) {
      case 'C':
        return Colors.red;
      case '=':
        return Colors.green;
      case 'X':
        return Color.fromARGB(255, 142, 150, 0);
      case '+':
      case '-':
      case '*':
      case '/':
        return Colors.indigo;
      case '.':
        return Colors.blueAccent;
      default:
        return Colors.grey; // Default color for other buttons
    }
  }

  Color _getButtonTextColor(String label) {
    return Colors.white; // All buttons have white text color
  }
}