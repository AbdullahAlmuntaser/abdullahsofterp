import 'dart:collection';

class RateLimitEntry {
  final int maxAttempts;
  final Duration window;
  final Queue<DateTime> timestamps;

  RateLimitEntry({required this.maxAttempts, required this.window})
      : timestamps = Queue<DateTime>();
}

class RateLimiterService {
  final Map<String, RateLimitEntry> _limits = {};
  final Map<String, int> _lockouts = {};
  static const Duration _lockoutDuration = Duration(minutes: 15);

  void configure(String key, int maxAttempts, Duration window) {
    _limits[key] = RateLimitEntry(maxAttempts: maxAttempts, window: window);
  }

  bool isLocked(String key) {
    final lockedUntil = _lockouts[key];
    if (lockedUntil == null) return false;
    if (DateTime.now().millisecondsSinceEpoch < lockedUntil) return true;
    _lockouts.remove(key);
    return false;
  }

  bool allow(String key) {
    if (isLocked(key)) return false;

    final limit = _limits[key];
    if (limit == null) return true;

    final now = DateTime.now();
    while (limit.timestamps.isNotEmpty &&
        now.difference(limit.timestamps.first) > limit.window) {
      limit.timestamps.removeFirst();
    }

    if (limit.timestamps.length >= limit.maxAttempts) {
      _lockouts[key] = now.add(_lockoutDuration).millisecondsSinceEpoch;
      return false;
    }

    limit.timestamps.add(now);
    return true;
  }

  void reset(String key) {
    _limits[key]?.timestamps.clear();
    _lockouts.remove(key);
  }

  void resetAll() {
    for (final entry in _limits.values) {
      entry.timestamps.clear();
    }
    _lockouts.clear();
  }
}
