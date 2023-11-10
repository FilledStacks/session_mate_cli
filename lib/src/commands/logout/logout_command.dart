import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:session_mate_cli/src/constants/message_constants.dart';
import 'package:session_mate_cli/src/locator.dart';
import 'package:session_mate_cli/src/services/firebase_service.dart';
import 'package:session_mate_cli/src/services/logger_service.dart';

class LogoutCommand extends Command {
  final _logger = locator<LoggerService>();
  final _firebaseService = locator<FirebaseService>();

  @override
  String get description => kCommandLogoutDescription;

  @override
  String get name => kCommandLogoutName;

  @override
  Future<void> run() async {
    try {
      _firebaseService.signOut();
    } catch (e, s) {
      _logger.error(message: 'Error:${e.toString()} StackTrace:\n$s');
      exit(1);
    }
  }
}
