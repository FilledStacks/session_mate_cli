import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:session_mate_cli/src/constants/message_constants.dart';
import 'package:session_mate_cli/src/locator.dart';
import 'package:session_mate_cli/src/services/logger_service.dart';
import 'package:session_mate_cli/src/services/process_service.dart';
import 'package:session_mate_cli/src/services/pub_service.dart';

class UpdateCommand extends Command {
  // final _analyticsService = locator<AnalyticsService>();
  final _logger = locator<LoggerService>();
  final _processService = locator<ProcessService>();
  final _pubService = locator<PubService>();

  @override
  String get description => kCommandUpdateDescription;

  @override
  String get name => kCommandUpdateName;

  @override
  Future<void> run() async {
    try {
      if (await _pubService.hasLatestVersion()) return;

      await _processService.runPubGlobalActivate();
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