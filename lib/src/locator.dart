import 'package:get_it/get_it.dart';
import 'package:session_mate_cli/src/services/logger_service.dart';
import 'package:session_mate_cli/src/services/process_service.dart';
import 'package:session_mate_cli/src/services/pub_service.dart';
import 'package:session_mate_cli/src/services/pubspec_service.dart';

final locator = GetIt.I;

Future setupLocator() async {
  // locator.registerLazySingleton(() => AnalyticsService());
  locator.registerLazySingleton(() => LoggerService());
  locator.registerLazySingleton(() => ProcessService());
  locator.registerLazySingleton(() => PubService());
  locator.registerLazySingleton(() => PubspecService());
}
