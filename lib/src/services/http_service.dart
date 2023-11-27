import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:session_mate_cli/src/exceptions/forbidden_exception.dart';
import 'package:session_mate_cli/src/exceptions/unauthorized_user_exception.dart';
import 'package:session_mate_cli/src/exceptions/user_seats_unavailable_exception.dart';
import 'package:session_mate_cli/src/locator.dart';
import 'package:session_mate_cli/src/services/firebase_service.dart';

import 'logger_service.dart';

const _webApiKey = String.fromEnvironment(
  'WEB_API_KEY',
  defaultValue: 'USE-FIREBASE-EMULATOR',
);

class HttpService {
  static const String _registerAppPath = '/licenses-api/registerApp';
  static const String _registerUserPath = '/licenses-api/registerUser';

  final _logger = locator<LoggerService>();
  final _firebaseService = locator<FirebaseService>();

  final _baseUrl = _webApiKey == 'USE-FIREBASE-EMULATOR'
      ? 'http://127.0.0.1:5001/sessionmate-93c0e/us-central1'
      : 'https://us-central1-sessionmate-93c0e.cloudfunctions.net';

  Future<void> registerApp({
    required String apiKey,
    required String name,
    String? androidId,
    String? iosId,
  }) async {
    if (!_firebaseService.isSignedIn) {
      throw UnauthorizedUserException(
        'To use this command you must be authenticated. Please use the login command to authenticate yourself.',
      );
    }

    _logger.info(
      message: '''
Register App Details ------
 - Name: $name
 - AndroidId: $androidId,
 - iOSId: $iosId,

On license $apiKey
        ''',
    );

    final response = await http.post(
      Uri.parse('$_baseUrl$_registerAppPath'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${_firebaseService.idToken}",
      },
      body: jsonEncode({
        "apiKey": apiKey,
        "app": {
          "name": name,
          "ids": {"android": androidId, "ios": iosId},
        }
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 401) {
      throw UnauthorizedUserException(data['message']);
    }

    if (response.statusCode == 403) {
      throw ForbiddenException(data['message']);
    }

    if (response.statusCode != 201) throw Exception(data);
  }

  Future<void> registerUser({
    required String apiKey,
    required List<String> emails,
  }) async {
    if (!_firebaseService.isSignedIn) {
      throw UnauthorizedUserException(
        'To use this command you must be authenticated. Please use the login command to authenticate yourself.',
      );
    }

    final response = await http.post(
      Uri.parse('$_baseUrl$_registerUserPath'),
      headers: {
        'Content-Type': "application/json",
        "Authorization": "Bearer ${_firebaseService.idToken}",
      },
      body: jsonEncode({"apiKey": apiKey, "emails": emails}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 401) {
      throw UnauthorizedUserException(data['message']);
    }

    if (response.statusCode == 403) {
      throw UserSeatsUnavailableException(data['message']);
    }

    if (response.statusCode != 201) throw Exception(data);
  }
}
