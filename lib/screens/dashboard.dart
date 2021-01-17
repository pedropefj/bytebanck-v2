import 'package:bytebank_v2/components/container.dart';
import 'package:bytebank_v2/components/localization.dart';
import 'package:bytebank_v2/models/name.dart';
import 'package:bytebank_v2/screens/contacts/list.dart';
import 'package:bytebank_v2/screens/name.dart';
import 'package:bytebank_v2/screens/transaction/list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardContainer extends BlocContainer {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NameCubit("Pedro"),
      child: I18NLoadingContainer(
          viewKey: "dashboard",
          language: BlocProvider.of<CurrentLocaleCubit>(context).state,
          creator: (messages) => DashboardView(
                DashboardViewLazyI18n(messages),
              )),
    );
  }
}

class DashboardView extends StatelessWidget {
  final DashboardViewLazyI18n _i18n;

  DashboardView(this._i18n);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          //Misturando um blocbuilder (que é observer de eventos) com UI
          title: BlocBuilder<NameCubit, String>(
              builder: (context, state) => Text('Welcome $state')),),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'images/bytebank_logo.png',
                ),
              ),
              Container(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _FeatureItem(
                      _i18n.transfer,
                      Icons.monetization_on,
                      onClick: () {
                        _showContactsList(context);
                      },
                    ),
                    _FeatureItem(
                      _i18n.transaction_feed,
                      Icons.description,
                      onClick: () => _showTransactionList(context),
                    ),
                    _FeatureItem(
                      _i18n.change_name,
                      Icons.person_outline,
                      onClick: () => _showChangeName(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showContactsList(BuildContext blocContext) {
    push(blocContext, ContactsListContainer());
  }

  void _showTransactionList(BuildContext blocContext) {
    push(blocContext, TransactionListContainer());
  }

  void _showChangeName(BuildContext blocContext) {
    Navigator.of(blocContext).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: BlocProvider.of<NameCubit>(blocContext),
          child: NameContainer(),
        ),
      ),
    );
  }
}

class DashboardViewLazyI18n {
  final I18NMessages _messages;

  DashboardViewLazyI18n(this._messages);

  String get transfer => _messages.get("transfer");

  String get transaction_feed => _messages.get("transaction_feed");

  String get change_name => _messages.get("change_name");
}

class _FeatureItem extends StatelessWidget {
  final String name;
  final IconData icon;
  final Function onClick;

  _FeatureItem(
    this.name,
    this.icon, {
    @required this.onClick,
  })  : assert(icon != null),
        assert(onClick != null);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).primaryColor,
        child: InkWell(
          onTap: () => onClick(),
          child: Container(
            padding: EdgeInsets.all(8.0),
            width: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 24.0,
                ),
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
