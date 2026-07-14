import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supermarket/core/services/app_config_service.dart';

class WebhookEvent {
  final String type;
  final Map<String, dynamic> data;
  final DateTime timestamp;

  WebhookEvent({
    required this.type,
    required this.data,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'type': type,
        'data': data,
        'timestamp': timestamp.toIso8601String(),
      };
}

class WebhookService {
  final AppConfigService _configService;
  final http.Client _client;
  List<Map<String, dynamic>> _subscribers = [];
  StreamController<WebhookEvent>? _eventController;

  WebhookService(this._configService, {http.Client? client})
      : _client = client ?? http.Client();

  static const String _subscribersKey = 'webhook_subscribers';

  Future<void> init() async {
    final raw = await _configService.getString(_subscribersKey);
    if (raw != null && raw.isNotEmpty) {
      _subscribers = (jsonDecode(raw) as List<dynamic>)
          .cast<Map<String, dynamic>>();
    }
    _eventController = StreamController<WebhookEvent>.broadcast();
  }

  Stream<WebhookEvent> get eventStream => _eventController!.stream;

  Future<void> addSubscriber({
    required String url,
    required String eventType,
    String? secret,
  }) async {
    _subscribers.add({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'url': url,
      'eventType': eventType,
      'secret': secret,
      'isActive': true,
      'createdAt': DateTime.now().toIso8601String(),
    });
    await _saveSubscribers();
  }

  Future<void> removeSubscriber(String id) async {
    _subscribers.removeWhere((s) => s['id'] == id);
    await _saveSubscribers();
  }

  List<Map<String, dynamic>> getSubscribers() =>
      List.unmodifiable(_subscribers);

  Future<void> fire(WebhookEvent event) async {
    _eventController?.add(event);

    final matching = _subscribers.where((s) =>
        s['isActive'] == true &&
        (s['eventType'] == event.type || s['eventType'] == '*'));

    for (final subscriber in matching) {
      try {
        final body = jsonEncode(event.toJson());
        final headers = <String, String>{
          'Content-Type': 'application/json',
        };
        if (subscriber['secret'] != null) {
          headers['X-Webhook-Secret'] = subscriber['secret'] as String;
        }
        await _client
            .post(
              Uri.parse(subscriber['url'] as String),
              headers: headers,
              body: body,
            )
            .timeout(const Duration(seconds: 10));
      } catch (_) {}
    }
  }

  Future<void> _saveSubscribers() async {
    await _configService.setString(
        _subscribersKey, jsonEncode(_subscribers));
  }

  void dispose() {
    _eventController?.close();
    _client.close();
  }
}
