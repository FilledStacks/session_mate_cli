import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:session_mate_cli/src/constants/command_constants.dart';
import 'package:session_mate_cli/src/constants/message_constants.dart';
import 'package:session_mate_cli/src/locator.dart';
import 'package:session_mate_cli/src/services/logger_service.dart';
import 'package:session_mate_cli/src/services/posthog_service.dart';
import 'package:session_mate_core/session_mate_core.dart';
import 'package:sweetcore/sweetcore.dart';

class SandboxCommand extends Command {
  final _logger = locator<LoggerService>();
  final _posthogService = locator<PosthogService>();

  @override
  String get description => kCommandSandboxDescription;

  @override
  String get name => kCommandSandboxName;

  Map<String, List<UIEvent>> sandboxReplays = {
    'onEnterPressed': [
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
    ],
    'drag': [
      DragEvent(
        position: EventPosition(x: 51, y: 419.3, devicePixelRatio: 3),
        scrollEnd: EventPosition(x: 305.1, y: 412.3, devicePixelRatio: 3),
      ),
    ]
  };

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
        ksSandboxSession,
        abbr: 's',
        defaultsTo: 'onEnterPressed',
        help: kCommandSandboxHelpSandboxSession,
        allowed: sandboxReplays.keys,
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

      await sweetCore.replayEvents(
        events: sandboxReplays[argResults![ksSandboxSession]]!,
      );

      await _posthogService.captureSandboxEvent(
        arguments: argResults!.arguments,
      );
    } catch (e, s) {
      _logger.error(message: e.toString());
      await _posthogService.captureExceptionEvent(
        runtimeType: e.runtimeType.toString(),
        message: e.toString(),
        stackTrace: s.toString(),
      );
      exit(1);
    }
  }
}
