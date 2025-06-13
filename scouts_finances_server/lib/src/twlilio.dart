import 'dart:convert';

import 'package:dotenv/dotenv.dart';
import 'package:http/http.dart' as http;

String toAuthCredentials(String accountSid, String authToken) {
  return 'Basic ${base64Encode(utf8.encode('$accountSid:$authToken'))}';
}

class TwilioClient {
  static final TwilioClient _instance = TwilioClient._internal();
  static final env = DotEnv(includePlatformEnvironment: true)..load();

  final String accountSid = env['TWILIO_ACCOUNT_SID'] ?? '';
  final String authToken = env['TWILIO_AUTH_TOKEN'] ?? '';
  final String fromNumber = env['TWILIO_FROM'] ?? '';
  final String toNumber = env['TWILIO_TO'] ?? '';

  final String authCredentials = toAuthCredentials(
    env['TWILIO_ACCOUNT_SID'] ?? '',
    env['TWILIO_AUTH_TOKEN'] ?? '',
  );

  final String baseUrl = 'https://api.twilio.com/2010-04-01/Accounts';

  factory TwilioClient() {
    return _instance;
  }

  TwilioClient._internal();

  String get messageUrl => '$baseUrl/$accountSid/Messages.json';

  Future<void> sendMessage({
    required String body,
  }) async {
    final httpClient = http.Client();

    // if greater than two segments, split into multiple messages
    final messages = <String>[];
    if (body.length > 160 * 2) {
      final segments = (body.length / (160 * 2)).ceil();
      for (int i = 0; i < segments; i++) {
        final start = i * (160 * 2);
        final end = start + (160 * 2);
        messages
            .add(body.substring(start, end > body.length ? body.length : end));
      }
    } else {
      messages.add(body);
    }

    try {
      for (final message in messages) {
        await httpClient.post(Uri.parse(messageUrl), headers: {
          'Authorization': authCredentials,
          'Content-Type': 'application/x-www-form-urlencoded',
        }, body: {
          'From': fromNumber,
          'To': toNumber,
          'Body': message,
        });
      }
    } catch (e) {
      print('Failed to send message: $e');
    } finally {
      httpClient.close();
    }
  }
}
