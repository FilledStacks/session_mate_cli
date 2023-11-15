import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:session_mate_cli/src/constants/message_constants.dart';
import 'package:session_mate_cli/src/locator.dart';
import 'package:session_mate_cli/src/services/http_service.dart';
import 'package:session_mate_cli/src/services/logger_service.dart';

class RegisterAppCommand extends Command {
  final _logger = locator<LoggerService>();
  final _httpService = locator<HttpService>();

  @override
  String get description => kCommandRegisterAppDescription;

  @override
  String get name => kCommandRegisterAppName;

  RegisterAppCommand() {
    argParser
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
    try {
      await _httpService.registerApp(
        androidAppId: argResults!['android'],
        iosAppId: argResults!['ios'],
      );
    } catch (e, s) {
      _logger.error(message: 'Error:${e.toString()} StackTrace:\n$s');
      exit(1);
    }
  }
}
