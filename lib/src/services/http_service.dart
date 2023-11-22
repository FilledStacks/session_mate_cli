import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:session_mate_cli/src/exceptions/forbidden_exception.dart';
import 'package:session_mate_cli/src/exceptions/unauthorized_user_exception.dart';
import 'package:session_mate_cli/src/exceptions/user_seats_unavailable_exception.dart';
import 'package:session_mate_cli/src/locator.dart';
import 'package:session_mate_cli/src/services/firebase_service.dart';

import 'logger_service.dart';

const _useEmulator = bool.fromEnvironment('USE_FIREBASE_EMULATOR');

class HttpService {
  static const String _registerAppPath = '/licenses-api/registerApp';
  static const String _registerUserPath = '/licenses-api/registerUser';

  final _logger = locator<LoggerService>();
  final _firebaseService = locator<FirebaseService>();

  final _baseUri = Uri.parse(
    _useEmulator
        ? 'http://10.0.2.2:5001/sessionmate-93c0e/us-central1'
        : 'https://us-central1-sessionmate-93c0e.cloudfunctions.net',
  );

  Future<void> registerApp({
    required String apiKey,
    required String name,
    String? androidId,
    String? iosId,
  }) async {
    try {
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
        _baseUri.replace(path: _registerAppPath),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${_firebaseService.idToken}',
        },
        body: jsonEncode({
          "apiKey": apiKey,
          "app": {
            'name': name,
            'ids': {"android": androidId, "ios": iosId},
          }
        }),
      );

      _logger.info(
        message:
            'Response code ${response.statusCode}, body: ${response.body} \nHeaders:${response.headers}',
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 401) {
        throw UnauthorizedUserException(data['message']);
      }

      if (response.statusCode == 403) {
        throw ForbiddenException(data['message']);
      }

      if (response.statusCode != 201) throw Exception(data);

      _logger.info(message: 'Register complete');
    } catch (e) {
      _logger.error(message: e.toString());
    }
  }

  Future<void> registerUser({
    required String apiKey,
    required List<String> emails,
  }) async {
    try {
      if (!_firebaseService.isSignedIn) {
        throw UnauthorizedUserException(
          'To use this command you must be authenticated. Please use the login command to authenticate yourself.',
        );
      }

      final response = await http.post(
        _baseUri.replace(path: _registerUserPath),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${_firebaseService.idToken}',
        },
        body: jsonEncode({'apiKey': apiKey, 'emails': emails}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 401) {
        throw UnauthorizedUserException(data['message']);
      }

      if (response.statusCode == 403) {
        throw UserSeatsUnavailableException(data['message']);
      }

      if (response.statusCode != 201) throw Exception(data);
    } on UnauthorizedUserException catch (e) {
      _logger.error(message: e.toString());
    } on UserSeatsUnavailableException catch (e) {
      _logger.error(message: e.toString());
    } catch (e) {
      _logger.error(message: e.toString());
    }
  }
}
