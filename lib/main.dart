import 'dart:async';
import 'dart:io';

import 'package:solana/features/beatify/response.dart';
import 'package:solana/features/data/cache_per_hour.dart';
import 'package:solana/features/transport/telegram_bot.dart';
import 'package:solana/inject/requirements.dart';

const url =
    'wss://io.dexscreener.com/dex/screener/pairs/h24/1?rankBy[key]=volume&rankBy[order]=desc&filters[pairAge][max]=1&filters[chainIds][0]=solana';
const port = 443;
const headers = {
  'Connection': 'Upgrade',
  'Upgrade': 'websocket',
  'Sec-WebSocket-Key': '<calculated at runtime>',
  'Sec-WebSocket-Version': '13',
  'Sec-WebSocket-Extensions': 'permessage-deflate; client_max_window_bits',
  'Origin': 'https://dexscreener.com',
};

Future<void> main(final List<String> arguments) async {
  await runZonedGuarded(
    () async {
      final token = Platform.environment['TELEGRAM_BOT_TOKEN'] ?? '';
      final transport = TelegramBot(token: token);
      final socket = await WebSocket.connect(url, headers: headers);
      final subscription = socket
          .transform(Requirements(cache: CachePerHour()))
          .transform(const Response())
          .asyncMap((message) async => await transport.send(message))
          .listen(null, cancelOnError: false)
        ..onDone(() => print('connection closed'));
      await subscription.asFuture();
    },
    (error, trace) => print('$error\n$trace'),
  );
  exit(0);
}
