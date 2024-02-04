import 'package:solana/core/filter.dart';
import 'package:solana/core/json.dart';

final class LastFiveMinutes extends Filter {
  const LastFiveMinutes();

  @override
  Stream<Json> bind(final Stream<Json> stream) async* {
    yield* stream.where((pair) {
      final createdAt = pair['pairCreatedAt'];
      final converted = DateTime.fromMillisecondsSinceEpoch(createdAt);
      final timeDelta = DateTime.now().difference(converted);
      return timeDelta.inMinutes <= 5;
    });
  }
}
