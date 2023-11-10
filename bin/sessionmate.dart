import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:session_mate_cli/src/commands/drive/drive_command.dart';
import 'package:session_mate_cli/src/commands/login/login_command.dart';
import 'package:session_mate_cli/src/commands/sandbox/sandbox_command.dart';
import 'package:session_mate_cli/src/commands/update/upgrade_command.dart';
import 'package:session_mate_cli/src/constants/command_constants.dart';
import 'package:session_mate_cli/src/constants/message_constants.dart';
import 'package:session_mate_cli/src/locator.dart';
import 'package:session_mate_cli/src/services/brew_service.dart';

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
    // ..argParser.addFlag(
    //   ksEnableAnalytics,
    //   negatable: false,
    //   help: kCommandRunnerEnableAnalyticsHelp,
    // )
    // ..argParser.addFlag(
    //   ksDisableAnalytics,
    //   negatable: false,
    //   help: kCommandRunnerDisableAnalyticsHelp,
    // )
    ..addCommand(DriveCommand())
    ..addCommand(LoginCommand())
    ..addCommand(SandboxCommand())
    ..addCommand(UpgradeCommand());

  try {
    final argResults = runner.parse(arguments);

    if (argResults[ksVersion]) {
      await _handleVersion();
      exit(0);
    }

    runner.run(arguments);
  } catch (e, _) {
    stdout.writeln(e.toString());

    exit(2);
  }
}

/// Prints version of the application.
Future<void> _handleVersion() async {
  stdout.writeln(await locator<BrewService>().getCurrentVersion());
}
