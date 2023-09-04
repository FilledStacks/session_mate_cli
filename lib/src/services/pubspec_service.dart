import 'dart:io';

import 'package:pubspec_yaml/pubspec_yaml.dart';

/// Provides functionality to interact with the pubspec in the current project
class PubspecService {
  late PubspecYaml pubspecYaml;

  /// Reads the pubpec and caches the value locally
  Future<void> initialise({String? workingDirectory}) async {
    final bool hasWorkingDirectory = workingDirectory != null;
    final pubspecYamlContent = await File(
      '${hasWorkingDirectory ? '$workingDirectory/' : ''}pubspec.yaml',
    ).readAsString();
    pubspecYaml = pubspecYamlContent.toPubspecYaml();
  }

  String get getPackageName => pubspecYaml.name;
}
