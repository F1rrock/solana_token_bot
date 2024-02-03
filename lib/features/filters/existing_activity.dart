import 'package:solana/core/filter.dart';
import 'package:solana/core/json.dart';

final class ExistingActivity extends Filter {
  const ExistingActivity();

  @override
  Stream<Json> bind(final Stream<Json> stream) async* {
    yield* stream.where((pair) {
      final txns = pair['txns'];
      final fiveMinutesActivity = txns['m5'];
      final buys = fiveMinutesActivity['buys'];
      final sells = fiveMinutesActivity['sells'];
      return (buys > 10) && (sells > 10);
    });
  }
}