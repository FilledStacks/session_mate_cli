import 'package:sweetcore/sweetcore.dart';

Future<void> main(List<String> arguments) async {
  print('Starting sweet core');
  final sweetCore = await SweetCore.setup();
  print('Sweet core constructed');
  await sweetCore.initialise();

  print('SweetCore initialised');

  sweetCore.logsStream.listen((event) {
    print(event.toJson());
  });

  sweetCore.stepTraceStream.listen((event) {
    print(event.toJson());
  });

  await sweetCore.startFlutterAppForDriving();

  // final testSuite = TestTree([]);

  // await sweetCore.runSelectedTests(
  //   testTree: testSuite,
  //   testRunnerConfiguration: SessionRunnerConfiguration(),
  // );
}
