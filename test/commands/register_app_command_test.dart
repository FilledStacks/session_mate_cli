import 'package:session_mate_cli/src/commands/register/register_app_command.dart';
import 'package:session_mate_cli/src/locator.dart';
import 'package:test/test.dart';

import '../helpers/test_helpers.dart';

RegisterAppCommand _getCommand() => RegisterAppCommand();

void main() {
  group('RegisterAppCommandTest -', () {
    setUp(() {
      registerServices();
    });

    tearDown(() async {
      await deleteTestFile();
      locator.reset();
    });

    group('hasAnyAppId -', () {
      test('when android and ios are null should return false', () async {
        final command = _getCommand();
        final hasAny = command.hasAnyAppId(null, null);

        expect(hasAny, false);
      });

      test('when android and ios are empty should return false', () async {
        final command = _getCommand();
        final hasAny = command.hasAnyAppId('', '');

        expect(hasAny, false);
      });
    });
  });
}
