import 'package:args/command_runner.dart';
import 'package:session_mate_cli/src/constants/command_constants.dart';
import 'package:session_mate_cli/src/constants/message_constants.dart';
import 'package:session_mate_cli/src/locator.dart';
import 'package:session_mate_cli/src/services/logger_service.dart';
import 'package:sweetcore/sweetcore.dart';

class DriveCommand extends Command {
  // final _analyticsService = locator<AnalyticsService>();
  final _logger = locator<LoggerService>();

  @override
  String get description => kCommandDriveDescription;

  @override
  String get name => kCommandDriveName;

  DriveCommand() {
    argParser
      ..addFlag(
        ksLogSweetCoreEvents,
        defaultsTo: false,
        help: kCommandDriveHelpLogSweetCoreEvents,
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
      _logger.sessionMateOutput(message: kCommandDriveSweetCoreStarts);

      final sweetCore = await SweetCore.setup();
      await sweetCore.initialise();

      _logger.sessionMateOutput(message: kCommandDriveSweetCoreInitialised);

      if (argResults![ksApiKey] == null) {
        _logger.sessionMateOutput(message: kCommandDriveLocalModeOnly);
      }

      if (argResults![ksLogSweetCoreEvents]) {
        sweetCore.logsStream.listen((event) {
          print(event.toString());
        });

        sweetCore.stepTraceStream.listen((event) {
          print('🤖 ${event.toString()}');
        });
      }

      await sweetCore.startFlutterAppForDriving(
        appPath: argResults![ksPath],
        apiKey: argResults![ksApiKey],
        additionalCommands: argResults![ksAdditionalCommands],
        delay: int.parse(argResults![ksDelay]),
      );

      // unawaited(_analyticsService.createServiceEvent(name: serviceName));
    } catch (e, _) {
      _logger.error(message: e.toString());
      // unawaited(_analyticsService.logExceptionEvent(
      //   runtimeType: e.runtimeType.toString(),
      //   message: e.toString(),
      //   stackTrace: s.toString(),
      // ));
    }
  }
}
