import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:meta/meta.dart';
import 'package:session_mate_cli/src/constants/message_constants.dart';
import 'package:session_mate_cli/src/exceptions/unauthorized_user_exception.dart';
import 'package:session_mate_cli/src/exceptions/user_seats_unavailable_exception.dart';
import 'package:session_mate_cli/src/locator.dart';
import 'package:session_mate_cli/src/services/http_service.dart';
import 'package:session_mate_cli/src/services/logger_service.dart';
import 'package:session_mate_cli/src/services/posthog_service.dart';

class RegisterUserCommand extends Command {
  final _logger = locator<LoggerService>();
  final _httpService = locator<HttpService>();
  final _posthogService = locator<PosthogService>();

  @override
  String get description => kCommandRegisterUserDescription;

  @override
  String get name => kCommandRegisterUserName;

  RegisterUserCommand() {
    argParser
      ..addOption(
        'api-key',
        abbr: 'k',
        help: kMultiCommandHelpApiKey,
        mandatory: true,
      )
      ..addOption(
        'emails',
        abbr: 'e',
        help: kCommandRegisterUserHelpEmails,
        mandatory: true,
        valueHelp: 'dane@sessionmate.dev,fernando@sessionmate.dev',
      );
  }

  @override
  Future<void> run() async {
    try {
      await _httpService.registerUser(
        apiKey: argResults!['api-key'],
        emails: getSanitizedEmails(argResults!['emails']),
      );

      await _posthogService.captureRegisterUserEvent(
        arguments: argResults!.arguments,
      );

      _logger.info(message: 'User successfully registered!');
    } on ArgumentError catch (e) {
      _logger.error(message: e.message);
      await _posthogService.captureExceptionEvent(
        runtimeType: e.runtimeType.toString(),
        message: e.message,
      );
      exit(1);
    } on UnauthorizedUserException catch (e) {
      _logger.error(message: e.toString());
      await _posthogService.captureExceptionEvent(
        runtimeType: e.runtimeType.toString(),
        message: e.toString(),
      );
      exit(1);
    } on UserSeatsUnavailableException catch (e) {
      _logger.error(message: e.toString());
      await _posthogService.captureExceptionEvent(
        runtimeType: e.runtimeType.toString(),
        message: e.toString(),
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
  List<String> getSanitizedEmails(String emails) {
    if (emails.isEmpty) return [];

    final input = emails.split(',');
    List<String> output = [];
    for (var i = 0; i < input.length; i++) {
      if (input[i].isEmpty) continue;

      output.add(input[i].trim());
    }

    return output;
  }
}
