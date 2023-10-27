import 'dart:io';

import 'package:yaml/yaml.dart';

/// Provides functionality to interact with the pubspec in the current project
class PubspecService {
  late Map _yaml;

  /// Reads the pubpec and caches the value locally
  Future<void> initialise({String? workingDirectory}) async {
    final bool hasWorkingDirectory = workingDirectory != null;
    final pubspecYamlContent = await File(
      '${hasWorkingDirectory ? '$workingDirectory/' : ''}pubspec.yaml',
    ).readAsString();

    _yaml = loadYaml(pubspecYamlContent);
  }

  String get packageName => _yaml['name'];

  String get packageVersion => _yaml['version'];
}
