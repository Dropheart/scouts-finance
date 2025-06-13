import 'dart:convert';

import 'package:dotenv/dotenv.dart';
import 'package:http/http.dart' as http;

String toAuthCredentials(String accountSid, String authToken) {
  return 'Basic ${base64Encode(utf8.encode('$accountSid:$authToken'))}';
}

class TwilioClient {
  static final TwilioClient _instance = TwilioClient._internal();
  static final env = DotEnv()..load();

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
    try {
      await httpClient.post(Uri.parse(messageUrl), headers: {
        'Authorization': authCredentials,
        'Content-Type': 'application/x-www-form-urlencoded',
      }, body: {
        'From': fromNumber,
        'To': toNumber,
        'Body': body,
      });
    } catch (e) {
      print('Failed to send message: $e');
    } finally {
      httpClient.close();
    }
  }
}
