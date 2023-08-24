import 'package:args/args.dart';
import 'package:sweetcore/sweetcore.dart';

Future<void> main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption(
      'delay',
      abbr: 'd',
      defaultsTo: '1000',
      help: 'Sets the delay in milliseconds between each step.',
    );

  ArgResults argResults = parser.parse(arguments);

  if (argResults.rest.isEmpty) {
    print('Please, pass the path of the app for driving.');
    print('\nOptions:\n');
    print(parser.usage);
    return;
  }

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

  await sweetCore.startFlutterAppForDriving(
    appPath: argResults.rest.first,
    delay: int.parse(argResults['delay']),
  );

  // final testSuite = TestTree([]);

  // await sweetCore.runSelectedTests(
  //   testTree: testSuite,
  //   testRunnerConfiguration: SessionRunnerConfiguration(),
  // );
}
