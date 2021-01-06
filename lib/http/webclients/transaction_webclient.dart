import 'dart:convert';
import 'package:bytebank_v2/http/webclient.dart';
import 'package:bytebank_v2/models/transaction.dart';
import 'package:http/http.dart';

final String _baseUrl = 'http://192.168.2.3:8080/transactions';

class TransactionWebClient {
  Future<List<Transaction>> findAll() async {
    final response = await client.get(_baseUrl).timeout(
          Duration(seconds: 10),
        );
    final List<dynamic> transactionJson = jsonDecode(response.body);

    return transactionJson
        .map((dynamic json) => Transaction.fromJson(json))
        .toList();
  }

  Future<Transaction> save(Transaction transaction) async {
    final transactionJson = jsonEncode(transaction.toJson());

    final Response response = await client.post(_baseUrl,
        headers: {
          'password': '1000',
          'Content-type': 'application/json',
        },
        body: transactionJson);

    return Transaction.fromJson(jsonDecode(response.body));
  }
}
