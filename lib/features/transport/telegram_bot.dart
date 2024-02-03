import 'dart:convert';
import 'dart:io';

import 'package:solana/core/transport.dart';

final class TelegramBot implements Transport {
  final String _token;

  static const _chat = '-4171113993';

  final HttpClient _client;

  TelegramBot({required final String token})
      : _token = token,
        _client = HttpClient();

  String get _url => 'https://api.telegram.org/bot$_token/sendMessage';

  @override
  Future<void> send(final Map<String, String> message) async {
    final text = '''
название: ${message['name']}
ссылка: ${message['link']}
токен создан: ${message['createdAt']}
ликвидность (usd): ${message['liquidityUsd']}
ликвидность (base): ${message['liquidityBase']}
ликвидность (quote): ${message['liquidityQuote']}
    ''';
    try {
      final request = await _client.postUrl(Uri.parse(_url));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(json.encode({
        'chat_id': _chat,
        'text': text,
      })));
      final response = await request.close();
      if (response.statusCode != HttpStatus.ok) {
        var responseBody = await response.transform(utf8.decoder).join();
        print('Request failed with status: ${response.statusCode}.');
        print('Response body: $responseBody');
      }
    } catch (exception) {
      print('Failed invoking the function. Exception: $exception.');
    }
  }
}
