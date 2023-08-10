import 'package:sweetcore/datamodels/session_runner_configuration.dart';
import 'package:sweetcore/datamodels/testmodels/test_tree.dart';
import 'package:sweetcore/sweetcore.dart';

Future<void> main(List<String> arguments) async {
  final sweetCore = await SweetCore.setup();
  await sweetCore.initialise();

  print('SweetCore initialised');

  sweetCore.logsStream.listen((event) {
    print(event.toJson());
  });

  sweetCore.stepTraceStream.listen((event) {
    print(event.toJson());
  });

  await sweetCore.startFlutterAppForDriving();

  final testSuite = TestTree([]);

  await sweetCore.runSelectedTests(
    testTree: testSuite,
    testRunnerConfiguration: SessionRunnerConfiguration(),
  );
}
