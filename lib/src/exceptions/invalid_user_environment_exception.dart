class InvalidUserEnvironmentException implements Exception {
  final List<String> issues;

  InvalidUserEnvironmentException({this.issues = const []});

  @override
  String toString() {
    final output = '''

┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                                                                                                                                  │
│  We found issues in your development environment 👇. Please, run "flutter doctor -v" to see the detail of the issues, solve them and try again.  │
│                                                                                                                                                  │
└──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
''';

    if (issues.isEmpty) return output;

    return '$output\n${issues.join('\n')}';
  }
}
