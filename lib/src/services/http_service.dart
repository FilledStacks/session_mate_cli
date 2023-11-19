import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:session_mate_cli/src/exceptions/forbidden_exception.dart';
import 'package:session_mate_cli/src/exceptions/unauthorized_user_exception.dart';
import 'package:session_mate_cli/src/exceptions/user_seats_unavailable_exception.dart';
import 'package:session_mate_cli/src/locator.dart';
import 'package:session_mate_cli/src/services/firebase_service.dart';

import 'logger_service.dart';

class HttpService {
  static const String baseUrl =
      'us-central1-sessionmate-93c0e.cloudfunctions.net';
  static const String registerAppPath = '/licenses-api/registerApp';
  static const String registerUserPath = '/licenses-api/registerUser';

  final _logger = locator<LoggerService>();
  final _firebaseService = locator<FirebaseService>();

  Future<void> registerApp({
    required String apiKey,
    required String name,
    String? androidId,
    String? iosId,
  }) async {
    try {
      _logger.info(
        message: '''
Register App Details ------
 - Name: $name
 - AndroidId: $androidId,
 - iOSId: $iosId,

On license $apiKey
        ''',
      );
      final token = _firebaseService.hasToken ? _firebaseService.idToken! : '';
      final url = Uri.https(baseUrl, registerAppPath);
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
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
      final token = _firebaseService.hasToken ? _firebaseService.idToken! : '';
      final url = Uri.https(baseUrl, registerUserPath);
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
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
