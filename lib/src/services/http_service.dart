import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:session_mate_cli/src/locator.dart';
import 'package:session_mate_cli/src/services/firebase_service.dart';

import 'logger_service.dart';

class HttpService {
  static const String baseUrl = '127.0.0.1:5001';
  static const String registerAppPath =
      '/sessionmate-93c0e/us-central1/licenses-api/registerApp';
  static const String registerUserPath =
      '/sessionmate-93c0e/us-central1/licenses-api/registerUser';

  final _logger = locator<LoggerService>();
  final _firebaseService = locator<FirebaseService>();

  Future<void> registerApp({String? androidAppId, String? iosAppId}) async {
    try {
      final token = _firebaseService.hasToken ? _firebaseService.idToken! : '';
      final url = Uri.http(baseUrl, registerAppPath);
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "apiKey": "fb2e384c-97aa-446a-ac22-c15612be1cb0",
          "apps": {"androidAppId": androidAppId, "iosAppId": iosAppId}
        }),
      );

      if (response.statusCode == 429) {
        throw Exception(jsonDecode(response.body)['error']['message']);
      }
    } catch (e) {
      _logger.error(message: e.toString());
      rethrow;
    }
  }

  Future<void> registerUser({required String email}) async {
    try {
      final token = _firebaseService.hasToken ? _firebaseService.idToken! : '';
      final url = Uri.http(baseUrl, registerUserPath);
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "apiKey": "fb2e384c-97aa-446a-ac22-c15612be1cb0",
          "email": email,
        }),
      );

      if (response.statusCode == 429) {
        throw Exception(jsonDecode(response.body)['error']['message']);
      }
    } catch (e) {
      _logger.error(message: e.toString());
      rethrow;
    }
  }
}
