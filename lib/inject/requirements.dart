import 'dart:async';

import 'package:solana/core/cache.dart';
import 'package:solana/core/json.dart';
import 'package:solana/features/beatify/pairs.dart';
import 'package:solana/features/filters/existing_activity.dart';
import 'package:solana/features/filters/havent_met_before.dart';
import 'package:solana/features/filters/last_five_minutes.dart';
import 'package:solana/features/filters/suitable_marketcap.dart';

final class Requirements extends StreamTransformerBase<dynamic, Json> {
  final Cache<String> _cache;

  const Requirements({
    required final Cache<String> cache,
  }) : _cache = cache;

  @override
  Stream<Json> bind(final Stream stream) async* {
    final haventMet = const HaventMetBefore();
    yield* stream
        .transform(const Pairs())
        .transform(const LastFiveMinutes())
        .transform(const SuitableMarketCap())
        .transform(const ExistingActivity())
        .transform(haventMet.accept(_cache))
        .asyncMap((response) async {
      final base = response['baseToken'];
      _cache.store(base['address']);
      return response;
    });
  }
}
