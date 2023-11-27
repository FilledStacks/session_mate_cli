import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:meta/meta.dart';
import 'package:session_mate_cli/src/constants/message_constants.dart';
import 'package:session_mate_cli/src/locator.dart';
import 'package:session_mate_cli/src/services/http_service.dart';
import 'package:session_mate_cli/src/services/logger_service.dart';
import 'package:session_mate_cli/src/services/posthog_service.dart';

class RegisterAppCommand extends Command {
  final _logger = locator<LoggerService>();
  final _httpService = locator<HttpService>();
  final _posthogService = locator<PosthogService>();

  @override
  String get description => kCommandRegisterAppDescription;

  @override
  String get name => kCommandRegisterAppName;

  RegisterAppCommand() {
    argParser
      ..addOption(
        'api-key',
        abbr: 'k',
        help: kMultiCommandHelpApiKey,
        mandatory: true,
      )
      ..addOption(
        'name',
        abbr: 'n',
        help: kCommandRegisterAppHelpName,
        mandatory: true,
        valueHelp: 'sessionmate',
      )
      ..addOption(
        'android',
        abbr: 'a',
        defaultsTo: null,
        help: kCommandRegisterAppHelpAndroid,
        valueHelp: 'com.filledstacks.sessionmate',
      )
      ..addOption(
        'ios',
        abbr: 'i',
        defaultsTo: null,
        help: kCommandRegisterAppHelpIos,
        valueHelp: 'com.filledstacks.sessionmate',
      );
  }

  @override
  Future<void> run() async {
    final androidId = argResults!['android'];
    final iosId = argResults!['ios'];

    try {
      if (!hasAnyAppId(androidId, iosId)) {
        throw ArgumentError('No app id provided, neither Android or iOS.');
      }

      await _httpService.registerApp(
        apiKey: argResults!['api-key'],
        name: argResults!['name'],
        androidId: androidId,
        iosId: iosId,
      );

      await _posthogService.captureRegisterAppEvent(
        arguments: argResults!.arguments,
      );

      _logger.info(message: 'Application successfully registered!');
    } on ArgumentError catch (e) {
      _logger.error(message: e.message);
      await _posthogService.captureExceptionEvent(
        runtimeType: e.runtimeType.toString(),
        message: e.message,
      );
      exit(1);
    } catch (e, s) {
      _logger.error(message: 'Error:${e.toString()}');
      await _posthogService.captureExceptionEvent(
        runtimeType: e.runtimeType.toString(),
        message: e.toString(),
        stackTrace: s.toString(),
      );
      exit(1);
    }
  }

  @visibleForTesting
  bool hasAnyAppId(String? android, String? ios) {
    if ((android?.isEmpty ?? true) && (ios?.isEmpty ?? true)) return false;

    return true;
  }
}
