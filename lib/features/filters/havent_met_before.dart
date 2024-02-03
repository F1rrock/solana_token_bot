import 'package:solana/core/cache.dart';
import 'package:solana/core/filter.dart';
import 'package:solana/core/json.dart';
import 'package:solana/features/internal/anonymous_transformer.dart';

final class HaventMetBefore {
  const HaventMetBefore();

  Filter accept(final Cache<String> cache) => AnonymousTransformer<Json, Json>(
        origin: (final Stream<Json> stream) async* {
          yield* stream.where(
            (element) => !cache.hasElement(
              element['baseToken']['address'],
            ),
          );
        },
      );
}
