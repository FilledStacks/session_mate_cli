import 'package:args/command_runner.dart';
import 'package:session_mate_cli/src/constants/command_constants.dart';
import 'package:session_mate_cli/src/constants/message_constants.dart';
import 'package:session_mate_cli/src/locator.dart';
import 'package:session_mate_cli/src/services/logger_service.dart';
import 'package:session_mate_core/session_mate_core.dart';
import 'package:sweetcore/sweetcore.dart';

class SandboxCommand extends Command {
  final _logger = locator<LoggerService>();

  @override
  String get description => kCommandSandboxDescription;

  @override
  String get name => kCommandSandboxName;

  SandboxCommand() {
    argParser
      ..addFlag(
        ksLogSweetCoreEvents,
        defaultsTo: false,
        help: kCommandDriveHelpLogSweetCoreEvents,
        negatable: false,
      )
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

      if (argResults![ksVerbose]) {
        sweetCore.logsStream.listen((event) {
          print('');
          print('SANDBOX: Driver --------------------------');
          print(event.toString());
          print('--------------------------------------------');
          print('');
        });
      }

      if (argResults![ksLogSweetCoreEvents]) {
        sweetCore.stepTraceStream.listen((event) {
          print('🤖 ${event.toString()}');
        });
      }

      await sweetCore.startFlutterAppForDriving(
        appPath: argResults![ksPath],
        additionalCommands: argResults![ksAdditionalCommands],
        delay: int.parse(argResults![ksDelay]),
        verbose: argResults![ksVerbose],
      );

      List<UIEvent> events = [
        InputEvent(
          overrideAutomationKey: 'input_field',
          position: EventPosition(
            x: 184.4,
            y: 402.2,
            capturedDeviceHeight: 802.9,
            capturedDeviceWidth: 392.7,
          ),
          inputData: 'This is entered',
        ),
        RawKeyEvent(type: InteractionType.onKeyboardEnterEvent),
        RawKeyEvent(type: InteractionType.backPressEvent),
      ];

      await sweetCore.replayEvents(events: events);
    } catch (e, s) {
      _logger.error(message: '${e.toString()} STACKTRACE: \n$s');
    }
  }
}
