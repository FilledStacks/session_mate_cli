import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:session_mate_cli/src/constants/message_constants.dart';
import 'package:session_mate_cli/src/locator.dart';
import 'package:session_mate_cli/src/services/brew_service.dart';
import 'package:session_mate_cli/src/services/logger_service.dart';
import 'package:session_mate_cli/src/services/posthog_service.dart';

class UpgradeCommand extends Command {
  final _brewService = locator<BrewService>();
  final _logger = locator<LoggerService>();
  final _posthogService = locator<PosthogService>();

  @override
  String get description => kCommandUpgradeDescription;

  @override
  String get name => kCommandUpgradeName;

  @override
  Future<void> run() async {
    try {
      if (await _brewService.hasLatestVersion()) return;

      await _brewService.update();
      await _posthogService.captureUpgradeEvent();
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
