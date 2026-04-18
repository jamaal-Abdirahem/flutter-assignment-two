import 'package:flutter/material.dart';
import '../widgets/custom_input.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController num1 = TextEditingController();
  final TextEditingController num2 = TextEditingController();
  String result = "";

  void calculate(String op) {
    double a = double.tryParse(num1.text) ?? 0;
    double b = double.tryParse(num2.text) ?? 0;
    double res = 0;

    if (op == '+') res = a + b;
    if (op == '-') res = a - b;
    if (op == '*') res = a * b;
    if (op == '/') res = b != 0 ? a / b : 0;

    setState(() {
      result = "Result: $res";
    });
  }

  @override
  void dispose() {
    num1.dispose();
    num2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calculator")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CustomInput(controller: num1, label: "Number 1"),
            CustomInput(controller: num2, label: "Number 2"),

            const SizedBox(height: 20),

            Wrap(
              spacing: 10,
              children: ["+", "-", "*", "/"].map((op) {
                return ElevatedButton(
                  onPressed: () => calculate(op),
                  child: Text(op),
                );
              }).toList(),
            ),

            const SizedBox(height: 30),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: Text(
                result,
                key: ValueKey(result),
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
