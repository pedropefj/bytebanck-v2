import 'package:flutter_bloc/flutter_bloc.dart';
//o estado é uma unica string
//poderia ser um perfil ou um objeto complexo

class NameCubit extends Cubit<String> {
  NameCubit(String name) : super(name);

  void change(String name) => emit(name);
}
