import 'dart:async';

import 'package:solana/core/json.dart';

final class Response extends StreamTransformerBase<Json, Map<String, String>> {
  static const _linkBase = 'https://dexscreener.com/solana/';

  const Response();

  @override
  Stream<Map<String, String>> bind(final Stream<Json> stream) async* {
    yield* stream.asyncMap((pair) async {
      final baseToken = pair['baseToken'];
      final liquidity = pair['liquidity'];
      final createdAt = DateTime.fromMillisecondsSinceEpoch(
        pair['pairCreatedAt'],
      );
      return {
        'name': baseToken['name'],
        'link': _linkBase + baseToken['address'],
        'liquidityUsd': liquidity['usd'].toString(),
        'liquidityBase': liquidity['base'].toString(),
        'liquidityQuote': liquidity['quote'].toString(),
        'createdAt': createdAt.toString(),
      };
    });
  }
}
