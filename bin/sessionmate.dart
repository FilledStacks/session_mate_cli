import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:session_mate_cli/src/commands/drive/drive_command.dart';
import 'package:session_mate_cli/src/commands/update/update_command.dart';
import 'package:session_mate_cli/src/constants/command_constants.dart';
import 'package:session_mate_cli/src/constants/message_constants.dart';
import 'package:session_mate_cli/src/locator.dart';
import 'package:session_mate_cli/src/services/pub_service.dart';

Future<void> main(List<String> arguments) async {
  await setupLocator();

  final runner = CommandRunner(
    kCommandRunnerName,
    kCommandRunnerDescription,
  )
    ..argParser.addFlag(
      ksVersion,
      abbr: 'v',
      negatable: false,
      help: kCommandRunnerVersionHelp,
    )
    ..argParser.addFlag(
      ksEnableAnalytics,
      negatable: false,
      help: kCommandRunnerEnableAnalyticsHelp,
    )
    ..argParser.addFlag(
      ksDisableAnalytics,
      negatable: false,
      help: kCommandRunnerDisableAnalyticsHelp,
    )
    ..addCommand(DriveCommand())
    ..addCommand(UpdateCommand());

  try {
    final argResults = runner.parse(arguments);
    // await _handleFirstRun();

    if (argResults[ksVersion]) {
      await _handleVersion();
      exit(0);
    }

    // if (_handleAnalytics(argResults)) exit(0);

    await _notifyNewVersionAvailable(arguments: arguments);

    runner.run(arguments);
  } catch (e, _) {
    stdout.writeln(e.toString());
    // locator<AnalyticsService>().logExceptionEvent(
    //   runtimeType: e.runtimeType.toString(),
    //   message: e.toString(),
    //   stackTrace: s.toString(),
    // );
    exit(2);
  }
}

/// Prints version of the application.
Future<void> _handleVersion() async {
  stdout.writeln(await locator<PubService>().getCurrentVersion());
}

/// Enables or disables sending of analytics data.
// bool _handleAnalytics(ArgResults argResults) {
//   if (argResults[ksEnableAnalytics]) {
//     locator<AnalyticsService>().enable(true);
//     return true;
//   }

//   if (argResults[ksDisableAnalytics]) {
//     locator<AnalyticsService>().enable(false);
//     return true;
//   }

//   return false;
// }

/// Allows user decide to enable or not analytics on first run.
// Future<void> _handleFirstRun() async {
//   // final analyticsService = locator<AnalyticsService>();
//   // if (!analyticsService.isFirstRun) return;

//   stdout.writeln('''
//   ┌──────────────────────────────────────────────────────────────────┐
//   │                 Welcome to the Session Mate CLI!                 │
//   ├──────────────────────────────────────────────────────────────────┤
//   │ We would like to collect anonymous                               │
//   │ usage statistics in order to improve the tool.                   │
//   │                                                                  │
//   │ Would you like to opt-into help us improve?                      │
//   └──────────────────────────────────────────────────────────────────┘
//   ''');
//   stdout.write('[y/n]: ');

//   final opt = stdin.readLineSync()?.toLowerCase().trim();
//   analyticsService.enable(opt == 'y' || opt == 'yes');

//   stdout.writeln();
// }

/// Notifies new version of Session Mate CLI is available
Future<void> _notifyNewVersionAvailable({
  List<String> arguments = const [],
  List<String> ignored = const [kCommandUpdateName],
}) async {
  if (arguments.isEmpty) return;

  for (var arg in ignored) {
    if (arguments.first == arg) return;
  }

  if (await locator<PubService>().hasLatestVersion()) return;

  stdout.writeln('''
  ┌──────────────────────────────────────────────────────────────────┐
  │ A new version of Session Mate CLI is available!                  │
  │                                                                  │
  │ To update to the latest version, run "session_mate update"       │
  └──────────────────────────────────────────────────────────────────┘
  ''');
}
