class ConcurrencyException implements Exception {
  final String message;
  ConcurrencyException(this.message);

  @override
  String toString() => 'ConcurrencyException: $message';
}
