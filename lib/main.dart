import 'package:bytebank_v2/components/localization.dart';
import 'package:bytebank_v2/components/theme.dart';
import 'package:bytebank_v2/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(BytebankApp());
}

class LogObserver extends BlocObserver {
  @override
  void onChange(Cubit cubit, Change change) {
    print("${cubit.runtimeType} > $change");

    super.onChange(cubit, change);
  }
}

class BytebankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //na prativa evitar log do genero , pois pode vazar informações sensivéis para o log
    Bloc.observer = LogObserver();

    return MaterialApp(
      home: LocalizationContainer(
        child: DashboardContainer(),
      ),
      theme: byteBankTheme,
    );
  }
}

