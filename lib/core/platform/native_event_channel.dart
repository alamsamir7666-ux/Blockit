import 'package:flutter/services.dart';

class NativeEventChannel {
  static const _channel = EventChannel('com.blockit.app/session_events');

  Stream<Map<String, dynamic>> get sessionStream {
    return _channel.receiveBroadcastStream().map((event) {
      return Map<String, dynamic>.from(event);
    });
  }
}
