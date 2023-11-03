import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:session_mate_cli/src/constants/message_constants.dart';
import 'package:session_mate_cli/src/locator.dart';
import 'package:session_mate_cli/src/services/brew_service.dart';
import 'package:session_mate_cli/src/services/logger_service.dart';

class UpgradeCommand extends Command {
  // final _analyticsService = locator<AnalyticsService>();
  final _logger = locator<LoggerService>();
  final _brewService = locator<BrewService>();

  @override
  String get description => kCommandUpgradeDescription;

  @override
  String get name => kCommandUpgradeName;

  @override
  Future<void> run() async {
    try {
      if (await _brewService.hasLatestVersion()) return;

      await _brewService.update();
      // unawaited(_analyticsService.updateCliEvent());
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
