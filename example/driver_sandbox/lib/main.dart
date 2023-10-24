import 'package:driver_sandbox/app/app.bottomsheets.dart';
import 'package:driver_sandbox/app/app.dialogs.dart';
import 'package:driver_sandbox/app/app.locator.dart';
import 'package:driver_sandbox/app/app.router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:stacked_services/stacked_services.dart';

Future<void> main() async {
  enableFlutterDriverExtension();

  // await setupSessionMate();

  await setupLocator();
  setupDialogUi();
  setupBottomSheetUi();
  // runApp(const SessionMate(child: MainApp()));
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: Routes.startupView,
      onGenerateRoute: StackedRouter().onGenerateRoute,
      navigatorKey: StackedService.navigatorKey,
      // builder: (_, child) => SessionMateBuilder(
      //   child: child!,
      // ),
      navigatorObservers: [
        StackedService.routeObserver,
      ],
    );
  }
}
