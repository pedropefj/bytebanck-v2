import 'dart:async';

import 'package:bytebank_v2/components/container.dart';
import 'package:bytebank_v2/components/error.dart';
import 'package:bytebank_v2/components/progress.dart';
import 'package:bytebank_v2/http/webclients/i18n_webclient.dart';
import 'package:bytebank_v2/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localstorage/localstorage.dart';

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

class ViewI18n {
  String _language;

  ViewI18n(BuildContext context) {
    this._language = BlocProvider.of<CurrentLocaleCubit>(context).state;
  }

  String localize(Map<String, String> values) {
    assert(values != null);
    assert(values.containsKey(_language) != null);

    return values[_language];
  }
}

@immutable
abstract class I18NMessagesState {
  const I18NMessagesState();
}

@immutable
class InitI18NMessageState extends I18NMessagesState {
  const InitI18NMessageState();
}

@immutable
class LoadingI18NMessageState extends I18NMessagesState {
  const LoadingI18NMessageState();
}

@immutable
class LoadedI18NMessageState extends I18NMessagesState {
  final I18NMessages _messages;

  const LoadedI18NMessageState(this._messages);
}

class I18NMessages {
  final Map<String, dynamic> _messages;

  I18NMessages(this._messages);

  String get(String key) {
    assert(key != null);
    assert(_messages.containsKey(key));

    return _messages[key];
  }
}

class I18NLoadingView extends StatelessWidget {
  final I18NWidgetCreator _creator;

  I18NLoadingView(this._creator);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<I18NMessagesCubit, I18NMessagesState>(
        builder: (cotext, state) {
      if (state is InitI18NMessageState || state is LoadingI18NMessageState) {
        return ProgressView(message: 'Loading...');
      }
      if (state is LoadedI18NMessageState) {
        final messages = state._messages;
        return _creator(messages);
      }
      return ErrorView("Error search message the screen");
    });
  }
}

class I18NMessagesCubit extends Cubit<I18NMessagesState> {
  final String viewkey;
  final String language;

  final LocalStorage storage = new LocalStorage('location_storage.json');

  I18NMessagesCubit(this.viewkey, this.language) : super(InitI18NMessageState());

  Future<void> reload(I18nWebClient client) async {

    String keyStorage = '${viewkey}_$language';
    emit(LoadingI18NMessageState());
    var ready = await storage.ready;
    print('searching ${keyStorage} is $ready');
    final items = storage.getItem(keyStorage);
    print('LocalStorage items ${items}');
    if(items!= null){
      emit(LoadedI18NMessageState(I18NMessages(items)));
      return;
    }
    client.findAll().then((messages){refreshAndSave(messages, keyStorage);});
  }

  refreshAndSave(Map<String, dynamic> messages, String keyStorage) {
    storage.setItem(keyStorage, messages);
    print('saving $keyStorage');
    final state = LoadedI18NMessageState(I18NMessages(messages));
    emit(state);
  }
}

typedef Widget I18NWidgetCreator(I18NMessages messages);

class I18NLoadingContainer extends BlocContainer {
  I18NWidgetCreator creator;
  String viewKey;
  String language;

  I18NLoadingContainer({
    @required String viewKey,
    @required String language,
    @required I18NWidgetCreator creator,
  }) {
    this.creator = creator;
    this.viewKey = viewKey;
    this.language = language;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<I18NMessagesCubit>(
      create: (BuildContext context) {
        final cubit = I18NMessagesCubit(this.viewKey, this.language);
        cubit.reload(I18nWebClient(this.viewKey, this.language));
        return cubit;
      },
      child: I18NLoadingView(this.creator),
    );
  }
}
