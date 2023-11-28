import 'dart:io';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:session_mate_cli/src/locator.dart';
import 'package:session_mate_cli/src/services/brew_service.dart';
import 'package:session_mate_cli/src/services/http_service.dart';
import 'package:session_mate_cli/src/services/logger_service.dart';
import 'package:session_mate_cli/src/services/posthog_service.dart';
import 'package:session_mate_cli/src/services/process_service.dart';
// @stacked-import

import 'test_helpers.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<BrewService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<HttpService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<LoggerService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<ProcessService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<PosthogService>(onMissingStub: OnMissingStub.returnDefault),
// @stacked-service-mock
])
MockBrewService getAndRegisterBrewService() {
  _removeRegistrationIfExists<BrewService>();
  final service = MockBrewService();
  locator.registerSingleton<BrewService>(service);
  return service;
}

MockHttpService getAndRegisterHttpService() {
  _removeRegistrationIfExists<HttpService>();
  final service = MockHttpService();
  locator.registerSingleton<HttpService>(service);
  return service;
}

MockLoggerService getAndRegisterLoggerService() {
  _removeRegistrationIfExists<LoggerService>();
  final service = MockLoggerService();
  locator.registerSingleton<LoggerService>(service);
  return service;
}

MockProcessService getAndRegisterProcessService({
  List<String> brewPackageInformation = const [],
}) {
  _removeRegistrationIfExists<ProcessService>();
  final service = MockProcessService();

  when(service.runBrewInfo()).thenAnswer(
    (invocation) async => brewPackageInformation,
  );

  locator.registerSingleton<ProcessService>(service);
  return service;
}

MockPosthogService getAndRegisterPosthogService({
  List<String> brewPackageInformation = const [],
}) {
  _removeRegistrationIfExists<PosthogService>();
  final service = MockPosthogService();

  locator.registerSingleton<PosthogService>(service);
  return service;
}

// Call this before any service registration helper. This is to ensure that if there
// is a service registered we remove it first. We register all services to remove boiler plate from tests
void _removeRegistrationIfExists<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}

// @stacked-mock-helper

void registerServices() {
  getAndRegisterBrewService();
  getAndRegisterHttpService();
  getAndRegisterLoggerService();
  getAndRegisterProcessService();
  getAndRegisterPosthogService();
  // @stacked-mock-helper-register
}

void createTestFile(String template) {
  File('mock_file.dart.test').writeAsStringSync(template);
}

Future<void> deleteTestFile() async {
  File file = File('mock_file.dart.test');
  if (await file.exists()) {
    await file.delete();
  }
}
