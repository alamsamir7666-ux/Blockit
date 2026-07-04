import 'package:flutter/services.dart';

class SessionChannel {
  static const _channel = MethodChannel('com.blockit.app/session');

  Future<Map<String, dynamic>> startSession({
    required int durationMinutes,
    required int difficulty,
  }) async {
    final result = await _channel.invokeMethod('startSession', {
      'duration': durationMinutes,
      'difficulty': difficulty,
    });
    return Map<String, dynamic>.from(result);
  }

  Future<Map<String, dynamic>> endSession() async {
    final result = await _channel.invokeMethod('endSession');
    return Map<String, dynamic>.from(result);
  }

  Future<Map<String, dynamic>> useParachute() async {
    final result = await _channel.invokeMethod('useParachute');
    return Map<String, dynamic>.from(result);
  }

  Future<Map<String, dynamic>> getSessionState() async {
    final result = await _channel.invokeMethod('getSessionState');
    return Map<String, dynamic>.from(result);
  }

  Future<int> getRemainingTime() async {
    final result = await _channel.invokeMethod('getRemainingTime');
    return result as int;
  }

  Future<int> getParachutes() async {
    final result = await _channel.invokeMethod('getParachutes');
    return result as int;
  }
}
