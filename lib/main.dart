import 'package:bytebank_v2/components/theme.dart';
import 'package:bytebank_v2/screens/counter.dart';
import 'package:bytebank_v2/screens/dashboard.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(BytebankApp());
}

class BytebankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CounterContainer(),
      theme: byteBankTheme,
    );
  }
}
