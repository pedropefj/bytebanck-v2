import 'dart:convert';
import 'package:bytebank_v2/models/contact.dart';
import 'package:bytebank_v2/models/transaction.dart';
import 'package:bytebank_v2/http/webclient.dart';
import 'package:http/http.dart';

final String _baseUrl = 'http://192.168.2.3:8080/transactions';

class TransactionWebClient{
  Future<List<Transaction>> findAll() async {
    final response = await client.get(_baseUrl).timeout(
      Duration(seconds: 10),
    );
    List<Transaction> transactions = _toTransaction(response);
    return transactions;
  }

  Future<Transaction> save(Transaction transaction) async {

    final transactionJson = jsonEncode(transaction.toJson());

    final Response response = await client.post(_baseUrl,
        headers: {
          'password': '1000',
          'Content-type': 'application/json',
        },
        body: transactionJson);

    return toTransaction(response);
  }

  List<Transaction> _toTransaction(Response response) {
    final List<dynamic> transactionJson = jsonDecode(response.body);
    final List<Transaction> transactions = [];
    for (Map<String, dynamic> element in transactionJson) {
      transactions.add(Transaction.fromJson(element)
      );
    }
    return transactions;
  }

  Transaction toTransaction(Response response) {
     Map<String, dynamic> json = jsonDecode(response.body);
     return Transaction.fromJson(json);
  }
}