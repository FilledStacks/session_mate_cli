import 'dart:io';

import 'package:args/command_runner.dart';
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
    argParser.addOption(
      'email',
      abbr: 'e',
      help: kCommandRegisterUserHelpEmail,
      mandatory: true,
      valueHelp: 'dane@sessionmate.dev',
    );
  }

  @override
  Future<void> run() async {
    try {
      await _httpService.registerUser(email: argResults!['email']);
    } catch (e, s) {
      _logger.error(message: 'Error:${e.toString()} StackTrace:\n$s');
      exit(1);
    }
  }
}
