
import 'package:http/http.dart';
import 'package:http_interceptor/http_client_with_interceptor.dart';

import 'file:///C:/Alura/flutter/bytebank_v2/lib/http/interceptoes/logging_interceptor.dart';

Client client = HttpClientWithInterceptor.build(
  interceptors: [LoggingInterceptor()],
);


