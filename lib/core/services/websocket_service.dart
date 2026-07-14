import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketMessage {
  final String type;
  final Map<String, dynamic> data;
  final DateTime timestamp;

  WebSocketMessage({
    required this.type,
    required this.data,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'type': type,
        'data': data,
        'timestamp': timestamp.toIso8601String(),
      };

  factory WebSocketMessage.fromJson(Map<String, dynamic> json) =>
      WebSocketMessage(
        type: json['type'] as String,
        data: json['data'] as Map<String, dynamic>,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
}

class WebSocketService {
  WebSocketChannel? _channel;
  final StreamController<WebSocketMessage> _messageController =
      StreamController<WebSocketMessage>.broadcast();
  StreamSubscription? _subscription;
  Timer? _reconnectTimer;
  String? _url;
  bool _shouldReconnect = true;

  Stream<WebSocketMessage> get messages => _messageController.stream;

  Future<void> connect(String url) async {
    _url = url;
    _shouldReconnect = true;
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      _subscription = _channel!.stream.listen(
        (data) {
          try {
            final decoded = jsonDecode(data as String) as Map<String, dynamic>;
            _messageController.add(WebSocketMessage.fromJson(decoded));
          } catch (_) {}
        },
        onError: (_) => _scheduleReconnect(),
        onDone: () => _scheduleReconnect(),
      );
    } catch (_) {
      _scheduleReconnect();
    }
  }

  void send(WebSocketMessage message) {
    if (_channel == null) return;
    try {
      _channel!.sink.add(jsonEncode(message.toJson()));
    } catch (_) {}
  }

  void _scheduleReconnect() {
    if (!_shouldReconnect || _url == null) return;
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 10), () {
      connect(_url!);
    });
  }

  void disconnect() {
    _shouldReconnect = false;
    _reconnectTimer?.cancel();
    _subscription?.cancel();
    _channel?.sink.close();
    _channel = null;
  }

  bool get isConnected => _channel != null;

  void dispose() {
    disconnect();
    _messageController.close();
  }
}
