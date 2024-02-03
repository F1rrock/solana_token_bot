import 'package:solana/core/filter.dart';
import 'package:solana/core/json.dart';

final class SuitableMarketCap extends Filter {
  const SuitableMarketCap();

  @override
  Stream<Json> bind(final Stream<Json> stream) async* {
    yield* stream.where(
      (pair) => pair['marketCap'] > 2000,
    );
  }
}
