import 'package:flutter_test/flutter_test.dart';
import 'package:driver_sandbox/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('InputTestViewModel Tests -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}
