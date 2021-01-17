import 'package:bytebank_v2/components/centered_message.dart';
import 'package:bytebank_v2/components/container.dart';
import 'package:bytebank_v2/components/progress.dart';
import 'package:bytebank_v2/http/webclients/transaction_webclient.dart';
import 'package:bytebank_v2/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _titleApp = 'Transactions';

@immutable
abstract class TransactionsListState {
  const TransactionsListState();
}

@immutable
class LoadingTransactionsListState extends TransactionsListState {
  const LoadingTransactionsListState();
}

@immutable
class LoadedTransactionsListState extends TransactionsListState {
  final List<Transaction> _transactions;

  const LoadedTransactionsListState(this._transactions);
}

@immutable
class FatalErrorTransactionsListState extends TransactionsListState {
  const FatalErrorTransactionsListState();
}

@immutable
class InitTransactionsListState extends TransactionsListState {
  const InitTransactionsListState();
}

class TransactionsListCubit extends Cubit<TransactionsListState> {
  TransactionsListCubit() : super(InitTransactionsListState());

  void reload(TransactionWebClient transactionWebClient) {
    emit(LoadingTransactionsListState());
    transactionWebClient
        .findAll()
        .then((transactions) =>
        emit(LoadedTransactionsListState(transactions)));
  }
}

class TransactionListContainer extends BlocContainer {
  final TransactionWebClient _webClient = TransactionWebClient();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransactionsListCubit>(
      create: (BuildContext context) {
        final cubit = TransactionsListCubit();
        cubit.reload(_webClient);
        return cubit;
      },
      child: TransactionsList(),
    );
  }

}

class TransactionsList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_titleApp),
        ),
        body: BlocBuilder<TransactionsListCubit, TransactionsListState>(
            builder: (context, state) {
              if (state is InitTransactionsListState ||
                  state is LoadingTransactionsListState) {
                return Progress();
              }
              if (state is LoadedTransactionsListState) {
                final List<Transaction> transactions = state._transactions;
                if (transactions.isNotEmpty) {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      final Transaction transaction = transactions[index];
                      return Card(child: ListTile(
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
                } return CenteredMessage(
                  'No transaction found',
                  icon: Icons.warning,
                );
              }
              return Text('Unkown error');
            },
    ),
  );
}}
