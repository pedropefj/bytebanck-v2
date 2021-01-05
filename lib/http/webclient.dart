import 'package:bytebank_v2/http/logging_interceptor.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_client_with_interceptor.dart';

Future<void> findAll() async {
  Client client = HttpClientWithInterceptor.build(
    interceptors: [LoggingInterceptor()],
  );

  final response = await client.get('http://192.168.2.3:8080/transactions');
}
