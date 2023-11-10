import 'package:get_it/get_it.dart';
import 'package:session_mate_cli/src/services/brew_service.dart';
import 'package:session_mate_cli/src/services/firebase_service.dart';
import 'package:session_mate_cli/src/services/logger_service.dart';
import 'package:session_mate_cli/src/services/path_service.dart';
import 'package:session_mate_cli/src/services/process_service.dart';
import 'package:session_mate_cli/src/services/pub_service.dart';

final locator = GetIt.I;

Future setupLocator() async {
  // locator.registerLazySingleton(() => AnalyticsService());
  locator.registerLazySingleton(() => LoggerService());
  locator.registerLazySingleton(() => ProcessService());
  locator.registerLazySingleton(() => PathService());
  locator.registerLazySingleton(() => PubService());
  locator.registerLazySingleton(() => BrewService());

  final firebaseService = FirebaseService();
  await firebaseService.init();
  locator.registerSingleton(firebaseService);
}
