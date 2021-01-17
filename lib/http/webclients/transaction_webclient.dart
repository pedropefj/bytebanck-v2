import 'dart:convert';
import 'package:bytebank_v2/http/webclient.dart';
import 'package:bytebank_v2/models/transaction.dart';
import 'package:http/http.dart';

final String _baseUrl = 'http://192.168.2.10:8080/transactions';

class TransactionWebClient {
  Future<List<Transaction>> findAll() async {
    final response = await client.get(_baseUrl);

    final List<dynamic> transactionJson = jsonDecode(response.body);

    return transactionJson
        .map((dynamic json) => Transaction.fromJson(json))
        .toList();
  }

  Future<Transaction> save(Transaction transaction, String password) async {
    final transactionJson = jsonEncode(transaction.toJson());
    await Future.delayed(Duration(seconds: 3));

    final Response response = await client.post(_baseUrl,
        headers: {
          'password': password,
          'Content-type': 'application/json',
        },
        body: transactionJson);
    if(response.statusCode == 200){
      return Transaction.fromJson(jsonDecode(response.body));
    }
    throw HttpException(_getMessage(response.statusCode));
  }

  String _getMessage(int statusCode) {
    if(_statusCodeResponse.containsKey(statusCode)){
      return _statusCodeResponse[statusCode];
    }else{
      return 'Unknown error';
    }
  }
  static final Map<int, String> _statusCodeResponse = {
    400: 'there was an error submitting transaction',
    401: 'authentication failed',
    409 : 'transaction already exists'
  };
}
class HttpException implements Exception{
  final String message;

  HttpException(this.message);

}
