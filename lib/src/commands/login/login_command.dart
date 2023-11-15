import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:firedart/auth/exceptions.dart';
import 'package:http/http.dart';
import 'package:session_mate_cli/src/constants/message_constants.dart';
import 'package:session_mate_cli/src/locator.dart';
import 'package:session_mate_cli/src/services/firebase_service.dart';
import 'package:session_mate_cli/src/services/logger_service.dart';

class LoginCommand extends Command {
  final _logger = locator<LoggerService>();
  final _firebaseService = locator<FirebaseService>();

  @override
  String get description => kCommandLoginDescription;

  @override
  String get name => kCommandLoginName;

  LoginCommand() {
    argParser
      ..addOption(
        'email',
        abbr: 'e',
        help: kCommandLoginHelpEmail,
        mandatory: true,
        valueHelp: 'dane@sessionmate.dev',
      )
      ..addOption(
        'password',
        abbr: 'p',
        help: kCommandLoginHelpPassword,
        mandatory: true,
        valueHelp: 'N*hgPBN&H4mT',
      );
  }

  @override
  Future<void> run() async {
    try {
      if (_firebaseService.isSignedIn) _firebaseService.signOut();

      await _firebaseService.signIn(
        email: argResults!['email'],
        password: argResults!['password'],
      );
    } on AuthException catch (e, _) {
      _logger.error(message: 'Error:${e.message}');
      exit(1);
    } on SignedOutException catch (e, _) {
      _logger.error(message: 'Error:${e.toString()}');
      exit(1);
    } on ClientException catch (e, _) {
      _logger.error(message: 'Connection to ${e.uri?.host} refused.');
      exit(1);
    } catch (e, _) {
      exit(1);
    }
  }
}
