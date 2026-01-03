import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

import '../../../domain/entities/tick.dart';

class OandaWebSocketClient {
  final FlutterSecureStorage secureStorage;
  final Logger logger;
  final bool isLive;

  WebSocketChannel? _channel;
  StreamController<Tick>? _tickController;
  StreamSubscription<dynamic>? _subscription;

  OandaWebSocketClient({
    required this.secureStorage,
    required this.logger,
    required this.isLive,
  });

  Stream<Tick> connect(List<String> instruments) {
    _tickController = StreamController<Tick>.broadcast();

    _connectToWebSocket(instruments);

    return _tickController!.stream;
  }

  Future<void> _connectToWebSocket(List<String> instruments) async {
    try {
      final token = await secureStorage.read(key: 'oanda_token') ?? '';
      final accountId = await secureStorage.read(key: 'oanda_account_id') ?? '';

      final baseUrl = isLive
          ? 'wss://stream-fxtrade.oanda.com'
          : 'wss://stream-fxpractice.oanda.com';

      final instrumentsStr = instruments.join(',');
      final url = '$baseUrl/v3/accounts/$accountId/pricing/stream?instruments=$instrumentsStr';

      _channel = WebSocketChannel.connect(Uri.parse(url));

      _subscription = _channel!.stream.listen(
        (data) {
          try {
            final json = jsonDecode(data as String) as Map<String, dynamic>;
            
            if (json['type'] == 'PRICE') {
              final tick = _parseTick(json);
              _tickController?.add(tick);
            }
          } catch (e) {
            logger.e('Error parsing WebSocket data', error: e);
          }
        },
        onError: (error) {
          logger.e('WebSocket error', error: error);
          _tickController?.addError(error);
        },
        onDone: () {
          logger.i('WebSocket connection closed');
          _tickController?.close();
        },
      );

      logger.i('WebSocket connected for instruments: $instrumentsStr');
    } catch (e) {
      logger.e('Error connecting to WebSocket', error: e);
      _tickController?.addError(e);
    }
  }

  Tick _parseTick(Map<String, dynamic> json) {
    final bids = json['bids'] as List<dynamic>? ?? [];
    final asks = json['asks'] as List<dynamic>? ?? [];

    final bid = bids.isNotEmpty 
        ? double.parse(bids[0]['price'].toString()) 
        : 0.0;
    final ask = asks.isNotEmpty 
        ? double.parse(asks[0]['price'].toString()) 
        : 0.0;

    return Tick(
      instrument: json['instrument'] as String,
      time: DateTime.parse(json['time'] as String),
      bid: bid,
      ask: ask,
    );
  }

  void disconnect() {
    _subscription?.cancel();
    _channel?.sink.close();
    _tickController?.close();
    logger.i('WebSocket disconnected');
  }
}
