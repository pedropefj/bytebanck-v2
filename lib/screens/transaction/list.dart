import 'package:bytebank_v2/components/centered_message.dart';
import 'package:bytebank_v2/components/progress.dart';
import 'package:bytebank_v2/http/webclients/transaction_webclient.dart';
import 'package:bytebank_v2/models/transaction.dart';
import 'package:flutter/material.dart';

final _titleApp = 'Transactions';

class TransactionsList extends StatelessWidget {

  final TransactionWebClient _webClient = TransactionWebClient();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titleApp),
      ),
      body: FutureBuilder<List<Transaction>>(
        future: _webClient.findAll(),
        builder: (context, snapshot) {
          final List<Transaction> transactions = snapshot.data;
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Progress();
              break;
            case ConnectionState.done:
              if(snapshot.hasData){
                if (transactions.isNotEmpty) {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      final Transaction transaction = transactions[index];
                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.monetization_on),
                          title: Text(
                            transaction.value.toString(),
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            transaction.contact.accountNumber.toString(),
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: transactions.length,
                  );
                }
              }
                return CenteredMessage(
                  'No transaction found',
                  icon: Icons.warning,
                );
              break;
          }
          return Text('Unkown error');
        },
      ),
    );
  }
}
