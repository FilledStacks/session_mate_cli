import 'package:session_mate_cli/src/locator.dart';
import 'package:session_mate_cli/src/services/brew_service.dart';
import 'package:test/test.dart';

import '../helpers/test_helpers.dart';

BrewService _getService() => BrewService();

void main() {
  group('BrewServiceTest -', () {
    setUp(() {
      registerServices();
    });

    tearDown(() async {
      await deleteTestFile();
      locator.reset();
    });

    const List<String> testPackageInstalled = [
      '==> filledstacks/tap/sessionmate: stable 0.6.2',
      'Session replay for Flutter to help find and fix bugs in production faster',
      'https://sessionmate.dev/',
      '/usr/local/Cellar/sessionmate/0.6.0 (3 files, 7.2MB) *',
      'Built from source on 2023-11-01 at 20:44:27',
      'From: https://github.com/filledstacks/homebrew-tap/blob/HEAD/sessionmate.rb',
      'License: MIT',
    ];

    const List<String> testPackageInstalledWithLatestVersion = [
      '==> filledstacks/tap/sessionmate: stable 0.6.2',
      'Session replay for Flutter to help find and fix bugs in production faster',
      'https://sessionmate.dev/',
      '/usr/local/Cellar/sessionmate/0.6.2 (3 files, 7.2MB) *',
      'Built from source on 2023-11-01 at 20:44:27',
      'From: https://github.com/filledstacks/homebrew-tap/blob/HEAD/sessionmate.rb',
      'License: MIT',
    ];

    const List<String> testPackageNotInstalled = [
      '==> filledstacks/tap/sessionmate: stable 0.6.2',
      'Session replay for Flutter to help find and fix bugs in production faster',
      'https://sessionmate.dev/',
      'Not installed',
      'From: https://github.com/filledstacks/homebrew-tap/blob/HEAD/sessionmate.rb',
      'License: MIT',
    ];

    group('getCurrentVersion -', () {
      test(
          'when called and sessionmate is installed should returns the version of the package installed on the system',
          () async {
        getAndRegisterProcessService(
          brewPackageInformation: testPackageInstalled,
        );
        final service = _getService();
        final version = await service.getCurrentVersion();

        expect(version, '0.6.0');
      });

      test(
          'when called and sessionmate is NOT installed should returns "Not installed"',
          () async {
        getAndRegisterProcessService(
          brewPackageInformation: testPackageNotInstalled,
        );
        final service = _getService();
        final version = await service.getCurrentVersion();

        expect(version, 'Package sessionmate not installed!');
      });
    });

    group('getLatestVersion -', () {
      test(
          'when called and sessionmate is installed should returns the latest version of the package',
          () async {
        getAndRegisterProcessService(
          brewPackageInformation: testPackageInstalled,
        );
        final service = _getService();
        final version = await service.getLatestVersion();

        expect(version, '0.6.2');
      });

      test(
          'when called and sessionmate is NOT installed should returns the latest version of the package',
          () async {
        getAndRegisterProcessService(
          brewPackageInformation: testPackageNotInstalled,
        );
        final service = _getService();
        final version = await service.getLatestVersion();

        expect(version, '0.6.2');
      });
    });

    group('hasLatestVersion -', () {
      test(
          'when sessionmate is installed and version is the latest should returns true',
          () async {
        getAndRegisterProcessService(
          brewPackageInformation: testPackageInstalledWithLatestVersion,
        );
        final service = _getService();
        final hasLatestVersion = await service.hasLatestVersion();

        expect(hasLatestVersion, isTrue);
      });

      test(
          'when sessionmate is installed and version is NOT the latest should returns false',
          () async {
        getAndRegisterProcessService(
          brewPackageInformation: testPackageInstalled,
        );
        final service = _getService();
        final hasLatestVersion = await service.hasLatestVersion();

        expect(hasLatestVersion, isFalse);
      });

      test(
          'when sessionmate is NOT installed should installs package and returns true',
          () async {
        getAndRegisterProcessService(
          brewPackageInformation: testPackageNotInstalled,
        );
        final service = _getService();
        final hasLatestVersion = await service.hasLatestVersion();

        expect(hasLatestVersion, isTrue);
      });
    });
  });
}
