abstract class Transport {
  Future<void> send(final Map<String, String> message);
}