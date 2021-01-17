import 'dart:convert';
import 'package:bytebank_v2/http/webclient.dart';

final MESSAGES_URI = 'https://gist.githubusercontent.com/pedropefj/9a2f6592aa0e9fc27e3fcba917b32c9f/raw/6af0194084bd4c34a6b254ab566291730e8f7b37/I18N.txt';

class I18nWebClient {
  Future<Map<String, dynamic>> findAll() async {
    final response = await client.get(MESSAGES_URI);

    final Map<String,dynamic> decodeJson = jsonDecode(response.body);

    return decodeJson;
  }
}