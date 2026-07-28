import 'package:supermarket/core/exceptions/concurrency_exception.dart';

Future<T> retryOnConcurrency<T>(
  Future<T> Function() operation, {
  int maxRetries = 3,
}) async {
  var attempts = 0;
  while (true) {
    try {
      return await operation();
    } on ConcurrencyException catch (_) {
      attempts++;
      if (attempts >= maxRetries) rethrow;
    }
  }
}
