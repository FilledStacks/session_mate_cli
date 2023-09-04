import 'package:args/command_runner.dart';
import 'package:session_mate_cli/src/constants/command_constants.dart';
import 'package:session_mate_cli/src/constants/message_constants.dart';
import 'package:session_mate_cli/src/locator.dart';
import 'package:session_mate_cli/src/services/logger_service.dart';
import 'package:session_mate_cli/src/services/process_service.dart';
import 'package:session_mate_cli/src/services/pub_service.dart';
import 'package:sweetcore/sweetcore.dart';

class DriveCommand extends Command {
  // final _analyticsService = locator<AnalyticsService>();
  final _logger = locator<LoggerService>();
  final _processService = locator<ProcessService>();
  final _pubService = locator<PubService>();

  @override
  String get description => kCommandDriveDescription;

  @override
  String get name => kCommandDriveName;

  DriveCommand() {
    argParser
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
      );
  }

  @override
  Future<void> run() async {
    try {
      _logger.sessionMateOutput(message: 'Starting sweet core');
      final sweetCore = await SweetCore.setup();
      _logger.sessionMateOutput(message: 'Sweet core constructed');
      await sweetCore.initialise();

      _logger.sessionMateOutput(message: 'SweetCore initialised');

      sweetCore.logsStream.listen((event) {
        print(event.toJson());
      });

      sweetCore.stepTraceStream.listen((event) {
        print(event.toJson());
      });

      await sweetCore.startFlutterAppForDriving(
        appPath: argResults![ksPath],
        delay: int.parse(argResults![ksDelay]),
      );

      // unawaited(_analyticsService.createServiceEvent(name: serviceName));
    } catch (e, s) {
      _logger.error(message: e.toString());
      // unawaited(_analyticsService.logExceptionEvent(
      //   runtimeType: e.runtimeType.toString(),
      //   message: e.toString(),
      //   stackTrace: s.toString(),
      // ));
    }
  }
}
