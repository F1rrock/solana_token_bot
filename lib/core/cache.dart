abstract class Cache<Type> {
  void store(final Type value);
  bool hasElement(final Type comparable);
}