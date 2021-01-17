import 'dart:convert';
import 'package:bytebank_v2/http/webclient.dart';

const MESSAGES_URI = 'https://gist.githubusercontent.com/pedropefj/9a2f6592aa0e9fc27e3fcba917b32c9f/raw/458c0ec1c828eeb1d350a2b032f210c431d8e268';

class I18nWebClient {
  final String _viewKey;
  final String _language;

  I18nWebClient(this._viewKey, this._language);

  Future<Map<String, dynamic>> findAll() async {
    final response = await client.get("$MESSAGES_URI/$_viewKey.$_language.json");

    final Map<String,dynamic> decodeJson = jsonDecode(response.body);

    return decodeJson;
  }
}