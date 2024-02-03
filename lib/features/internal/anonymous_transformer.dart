import 'dart:async';

final class AnonymousTransformer<From, To> extends StreamTransformerBase<From, To> {
  final Stream<To> Function(Stream<From>) _origin;

  const AnonymousTransformer({
    required final Stream<To> Function(Stream<From>) origin,
  }) : _origin = origin;

  @override
  Stream<To> bind(final Stream<From> stream) => _origin(stream);
}