import 'dart:io';

import 'package:pub_updater/pub_updater.dart';
import 'package:session_mate_cli/src/constants/command_constants.dart';
import 'package:session_mate_cli/src/locator.dart';

import 'process_service.dart';

/// Provides functionality to interact with pacakges
class PubService {
  static const String _notAvailable = 'Sorry, package not available!';

  final _processService = locator<ProcessService>();

  final _pubUpdater = PubUpdater();

  /// Returns current `session_mate_cli` version installed on the system.
  Future<String> getCurrentVersion() async {
    String version = _notAvailable;

    final packages = await _processService.runPubGlobalList();
    for (var package in packages) {
      if (!package.contains(ksSessionMateCli)) continue;

      version = package.split(' ').last;
      break;
    }

    return version;
  }

  /// Returns the latest published version of `session_mate_cli` package.
  Future<String> getLatestVersion() async {
    return await _pubUpdater.getLatestVersion(ksSessionMateCli);
  }

  /// Checks whether or not has the latest version for `session_mate_cli`
  /// package installed on the system.
  Future<bool> hasLatestVersion() async {
    final currentVersion = await getCurrentVersion();
    if (currentVersion == _notAvailable) {
      await update();
      return true;
    }

    return await _pubUpdater.isUpToDate(
      packageName: ksSessionMateCli,
      currentVersion: currentVersion,
    );
  }

  /// Updates `session_mate_cli` package on the system.
  Future<ProcessResult> update() async {
    return await _pubUpdater.update(packageName: ksSessionMateCli);
  }
}
