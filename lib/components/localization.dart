import 'package:bytebank_v2/components/container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocalizationContainer extends BlocContainer {
  final Widget child;

  LocalizationContainer({@required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CurrentLocaleCubit>(
      create: (context) => CurrentLocaleCubit(),
      child: this.child,
    );
  }
}

class CurrentLocaleCubit extends Cubit<String> {
  CurrentLocaleCubit() : super("en");
}

class ViewI18n
{
  String _language;

  ViewI18n(BuildContext context){
    this._language = BlocProvider.of<CurrentLocaleCubit>(context).state;
  }

  String localize(Map<String, String> values) {
    assert(values !=  null);
    assert(values.containsKey(_language) != null);
    
    return values[_language];
  }
}

