import 'dart:async';

import 'package:solana/core/cache.dart';

final class CachePerHour<Type> extends Cache<Type> {
  final List<Type> _origin;

  CachePerHour() : _origin = List.empty(growable: true) {
    Timer.periodic(Duration(hours: 1), (_) => _origin.clear());
  }

  @override
  void store(final Type value) => _origin.add(value);

  @override
  bool hasElement(final Type comparable) => _origin.contains(comparable);
}