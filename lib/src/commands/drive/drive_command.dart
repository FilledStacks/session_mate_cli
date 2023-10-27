import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:session_mate_cli/src/constants/command_constants.dart';
import 'package:session_mate_cli/src/constants/message_constants.dart';
import 'package:session_mate_cli/src/exceptions/invalid_user_environment_exception.dart';
import 'package:session_mate_cli/src/locator.dart';
import 'package:session_mate_cli/src/services/logger_service.dart';
import 'package:session_mate_cli/src/services/pubspec_service.dart';
import 'package:sweetcore/sweetcore.dart';

class DriveCommand extends Command {
  // final _analyticsService = locator<AnalyticsService>();
  final _logger = locator<LoggerService>();
  final _pubspecService = locator<PubspecService>();

  @override
  String get description => kCommandDriveDescription;

  @override
  String get name => kCommandDriveName;

  DriveCommand() {
    argParser
      // ..addFlag(
      //   ksLogSweetCoreEvents,
      //   defaultsTo: false,
      //   help: kCommandDriveHelpLogSweetCoreEvents,
      //   negatable: false,
      // )
      ..addFlag(
        ksVerbose,
        abbr: 'v',
        defaultsTo: false,
        help: kCommandDriveHelpVerbose,
        negatable: false,
      )
      ..addOption(
        ksDelay,
        abbr: 'd',
        defaultsTo: '1000',
        help: kCommandDriveHelpDelay,
        valueHelp: '1000',
      )
      ..addOption(
        ksPath,
        abbr: 'p',
        defaultsTo: '.',
        help: kCommandDriveHelpPath,
        valueHelp: '.',
      )
      ..addOption(
        ksApiKey,
        abbr: 'a',
        help: kCommandDriveHelpApiKey,
        valueHelp: 'XXXXX-XXX-XXXXXXX-XX',
      )
      ..addOption(
        ksAdditionalCommands,
        help: kCommandDriveHelpAdditionalCommands,
      );
  }

  @override
  Future<void> run() async {
    try {
      _logger.sessionMateOutput(
        message:
            'Starting SweetCore using SessionMate CLI (${_pubspecService.packageVersion})...',
      );

      final sweetCore = await SweetCore.setup();
      await sweetCore.initialise();

      _logger.sessionMateOutput(message: kCommandDriveSweetCoreInitialised);

      _logger.sessionMateOutput(
        message: kCommandDriveSweetCoreValidateUserEnvironment,
      );

      final result = await sweetCore.validateUserEnvironment(
        verbose: argResults![ksVerbose],
      );

      if (!result.output['status']) {
        throw InvalidUserEnvironmentException(issues: result.output['issues']);
      }

      _logger.sessionMateOutput(
        message: kCommandDriveSweetCoreValidUserEnvironment,
      );

      if (argResults![ksApiKey] == null) {
        _logger.sessionMateOutput(message: kCommandDriveLocalModeOnly);
      }

      if (argResults![ksVerbose]) {
        sweetCore.logsStream.listen((event) {
          print('');
          print('SessionMate driver --------------------------');
          print(event.toString());
          print('--------------------------------------------');
          print('');
        });

        sweetCore.stepTraceStream.listen((event) {
          print('🤖 ${event.toString()}');
        });
      }

      await sweetCore.startFlutterAppForDriving(
        appPath: argResults![ksPath],
        apiKey: argResults![ksApiKey],
        additionalCommands: argResults![ksAdditionalCommands],
        verbose: argResults![ksVerbose],
      );

      await sweetCore.setupCommunicationWithPackage(
        delay: int.parse(argResults![ksDelay]),
      );
    } on InvalidUserEnvironmentException catch (e, _) {
      stdout.writeln(e.toString());
      exit(1);
    } catch (e, s) {
      _logger.error(message: 'Error:${e.toString()} StackTrace:\n$s');
      exit(1);
    }
  }
}
