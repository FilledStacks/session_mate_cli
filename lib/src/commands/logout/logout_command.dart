import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:session_mate_cli/src/constants/message_constants.dart';
import 'package:session_mate_cli/src/locator.dart';
import 'package:session_mate_cli/src/services/firebase_service.dart';
import 'package:session_mate_cli/src/services/logger_service.dart';
import 'package:session_mate_cli/src/services/posthog_service.dart';

class LogoutCommand extends Command {
  final _logger = locator<LoggerService>();
  final _firebaseService = locator<FirebaseService>();
  final _posthogService = locator<PosthogService>();

  @override
  String get description => kCommandLogoutDescription;

  @override
  String get name => kCommandLogoutName;

  @override
  Future<void> run() async {
    try {
      await _posthogService.captureLogoutEvent();
      _firebaseService.signOut();
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
}
