import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:session_mate_cli/src/exceptions/posthog_api_key_not_provided_exception.dart';
import 'package:session_mate_cli/src/helpers/telemetry_store.dart';
import 'package:session_mate_cli/src/locator.dart';

import 'brew_service.dart';
import 'firebase_service.dart';
import 'logger_service.dart';
import 'path_service.dart';

const _webApiKey = String.fromEnvironment(
  'WEB_API_KEY',
  defaultValue: 'USE-FIREBASE-EMULATOR',
);

const String _apiKey = String.fromEnvironment('POSTHOG_API_KEY');

class PosthogService {
  static const String _capturePath = '/capture';

  final _brewService = locator<BrewService>();
  final _firebaseService = locator<FirebaseService>();
  final _logger = locator<LoggerService>();
  final _pathService = locator<PathService>();

  final _baseUri = Uri.parse('https://app.posthog.com');

  /// Is this the first time the tool has run?
  bool get isFirstRun => _store.read()?.isFirstRun ?? true;

  /// Will analytics data be sent?
  bool get enabled => _store.read()?.isEnabled ?? false;

  /// Enables or disables sending of analytics data.
  Future<void> enable(bool value) async {
    await _store.write(Telemetry(isEnabled: value, isFirstRun: false));
  }

  late TelemetryStore _store;

  Future<void> init() async {
    _store = await TelemetryStore.create(
      path: '${_pathService.configHome.path}/sessionmate',
    );
  }

  Future<void> captureDriveEvent({
    required List<String> arguments,
  }) async {
    final version = await _brewService.getCurrentVersion();
    await _capture(
      event: "drive",
      properties: {
        "arguments": arguments,
        "version": version,
      },
    );
  }

  Future<void> captureLoginEvent({
    required List<String> arguments,
  }) async {
    final version = await _brewService.getCurrentVersion();
    await _capture(
      event: "login",
      properties: {
        "arguments": arguments,
        "version": version,
      },
    );
  }

  Future<void> captureLogoutEvent() async {
    final version = await _brewService.getCurrentVersion();
    await _capture(
      event: "logout",
      properties: {"version": version},
    );
  }

  Future<void> captureRegisterAppEvent({
    required List<String> arguments,
  }) async {
    final version = await _brewService.getCurrentVersion();
    await _capture(
      event: "register app",
      properties: {
        "arguments": arguments,
        "version": version,
      },
    );
  }

  Future<void> captureRegisterUserEvent({
    required List<String> arguments,
  }) async {
    final version = await _brewService.getCurrentVersion();
    await _capture(
      event: "register user",
      properties: {
        "arguments": arguments,
        "version": version,
      },
    );
  }

  Future<void> captureSandboxEvent({
    required List<String> arguments,
  }) async {
    final version = await _brewService.getCurrentVersion();
    await _capture(
      event: "sandbox",
      properties: {
        "arguments": arguments,
        "version": version,
      },
    );
  }

  Future<void> captureUpgradeEvent() async {
    final version = await _brewService.getCurrentVersion();
    await _capture(
      event: "upgrade",
      properties: {"version": version},
    );
  }

  Future<void> captureExceptionEvent({
    Level level = Level.error,
    required String runtimeType,
    required String message,
    String stackTrace = 'Not Available',
  }) async {
    final version = await _brewService.getCurrentVersion();
    await _capture(
      event: level.toString(),
      properties: {
        "message": "[$runtimeType] $message",
        "stackTrace": "StackTrace:\n$stackTrace",
        "version": version,
      },
    );
  }

  Future<void> _capture({
    required String event,
    Map<String, dynamic> properties = const {},
  }) async {
    try {
      if (!enabled || _webApiKey == 'USE-FIREBASE-EMULATOR') return;

      if (_apiKey.isEmpty) {
        throw PostHogApiKeyNotFoundException();
      }

      final response = await http.post(
        _baseUri.replace(path: _capturePath),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "api_key": _apiKey,
          "event": event,
          "properties": {
            "distinct_id": _firebaseService.userId ?? "anonymous",
            ...properties,
          }
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode != 200) throw Exception(data);
    } on PostHogApiKeyNotFoundException catch (e) {
      _logger.error(message: e.toString());
    } catch (e, s) {
      _logger.error(
        message: 'Error:${e.toString()}, StackTrace:\n${s.toString()}',
      );
    }
  }
}

enum Level {
  debug,
  info,
  warning,
  error;

  @override
  String toString() {
    return 'LOG::${name.toUpperCase()}';
  }
}
