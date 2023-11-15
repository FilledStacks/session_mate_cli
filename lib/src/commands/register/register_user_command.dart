import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:meta/meta.dart';
import 'package:session_mate_cli/src/constants/message_constants.dart';
import 'package:session_mate_cli/src/locator.dart';
import 'package:session_mate_cli/src/services/http_service.dart';
import 'package:session_mate_cli/src/services/logger_service.dart';

class RegisterUserCommand extends Command {
  final _logger = locator<LoggerService>();
  final _httpService = locator<HttpService>();

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
    } on ArgumentError catch (e) {
      _logger.error(message: e.message);
      exit(1);
    } catch (e, s) {
      _logger.error(message: 'Error:${e.toString()} StackTrace:\n$s');
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
