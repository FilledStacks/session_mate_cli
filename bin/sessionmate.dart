import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:session_mate_cli/src/commands/drive/drive_command.dart';
import 'package:session_mate_cli/src/commands/login/login_command.dart';
import 'package:session_mate_cli/src/commands/logout/logout_command.dart';
import 'package:session_mate_cli/src/commands/register/register_command.dart';
import 'package:session_mate_cli/src/commands/sandbox/sandbox_command.dart';
import 'package:session_mate_cli/src/commands/upgrade/upgrade_command.dart';
import 'package:session_mate_cli/src/constants/command_constants.dart';
import 'package:session_mate_cli/src/constants/message_constants.dart';
import 'package:session_mate_cli/src/locator.dart';
import 'package:session_mate_cli/src/services/brew_service.dart';
import 'package:session_mate_cli/src/services/posthog_service.dart';

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
    ..addCommand(LoginCommand())
    ..addCommand(LogoutCommand())
    ..addCommand(RegisterCommand())
    ..addCommand(SandboxCommand())
    ..addCommand(UpgradeCommand());

  try {
    final argResults = runner.parse(arguments);
    await _handleFirstRun();

    if (argResults[ksVersion]) {
      await _handleVersion();
      exit(0);
    }

    if (await _handleAnalytics(argResults)) exit(0);

    await runner.run(arguments);
  } catch (e, _) {
    stdout.writeln(e.toString());

    exit(2);
  }
}

/// Prints version of the application.
Future<void> _handleVersion() async {
  stdout.writeln(await locator<BrewService>().getCurrentVersion());
}

/// Enables or disables sending of analytics data.
Future<bool> _handleAnalytics(ArgResults argResults) async {
  if (argResults[ksEnableAnalytics]) {
    await locator<PosthogService>().enable(true);
    return true;
  }

  if (argResults[ksDisableAnalytics]) {
    await locator<PosthogService>().enable(false);
    return true;
  }

  return false;
}

/// Allows user decide to enable or not analytics on first run.
Future<void> _handleFirstRun() async {
  final analyticsService = locator<PosthogService>();
  if (!analyticsService.isFirstRun) return;

  stdout.writeln('''
  ┌──────────────────────────────────────────────────────────────────┐
  │                 Welcome to the Session Mate CLI!                 │
  ├──────────────────────────────────────────────────────────────────┤
  │ We would like to collect anonymous                               │
  │ usage statistics in order to improve the tool.                   │
  │                                                                  │
  │ Would you like to opt-into help us improve?                      │
  └──────────────────────────────────────────────────────────────────┘
  ''');
  stdout.write('[y/n]: ');

  final opt = stdin.readLineSync()?.toLowerCase().trim();
  analyticsService.enable(opt == 'y' || opt == 'yes');
}
