import 'package:session_mate_cli/src/commands/register/register_user_command.dart';
import 'package:session_mate_cli/src/locator.dart';
import 'package:test/test.dart';

import '../helpers/test_helpers.dart';

RegisterUserCommand _getCommand() => RegisterUserCommand();

void main() {
  group('RegisterUserCommandTest -', () {
    setUp(() {
      registerServices();
    });

    tearDown(() async {
      await deleteTestFile();
      locator.reset();
    });

    group('getSanitizedEmails -', () {
      test('when input is empty should return an empty list', () async {
        final command = _getCommand();
        final input = command.getSanitizedEmails('');

        expect(input, []);
      });

      test('when called should return a valid list of emails', () async {
        final command = _getCommand();
        final input = command.getSanitizedEmails('test1@me.dev');

        expect(input, ['test1@me.dev']);
      });

      test('when called should return a valid list of emails', () async {
        final command = _getCommand();
        final input = command.getSanitizedEmails('test1@me.dev,');

        expect(input, ['test1@me.dev']);
      });

      test('when called should return a valid list of emails', () async {
        final command = _getCommand();
        final input = command.getSanitizedEmails('test1@me.dev,test2@me.dev');

        expect(input, ['test1@me.dev', 'test2@me.dev']);
      });

      test('when called should return a valid list of emails', () async {
        final command = _getCommand();
        final input = command.getSanitizedEmails('test1@me.dev ,test2@me.dev');

        expect(input, ['test1@me.dev', 'test2@me.dev']);
      });

      test('when called should return a valid list of emails', () async {
        final command = _getCommand();
        final input = command.getSanitizedEmails('test1@me.dev, test2@me.dev');

        expect(input, ['test1@me.dev', 'test2@me.dev']);
      });

      test('when called should return a valid list of emails', () async {
        final command = _getCommand();
        final input = command.getSanitizedEmails('test1@me.dev , test2@me.dev');

        expect(input, ['test1@me.dev', 'test2@me.dev']);
      });
    });
  });
}
