import 'dart:async';
import 'dart:convert';

import 'package:solana/core/json.dart';

final class Pairs extends StreamTransformerBase<dynamic, Json> {
  const Pairs();

  @override
  Stream<Json> bind(final Stream stream) => stream
      .asyncMap((message) async => json.decode(message))
      .asyncExpand((message) async* {
        try {
          yield message as Json;
        } catch (_) {}
      })
      .where((message) => message.containsKey('type'))
      .where((message) => message['type'] == 'pairs')
      .asyncExpand<Json>(
          (message) async* {
            for (final Json pair in message['pairs']) {
              yield pair;
            }
          });
}
