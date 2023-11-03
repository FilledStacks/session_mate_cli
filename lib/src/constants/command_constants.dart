/// Stores all the commands used throughout the app that

const String ksActivate = 'activate';
const String ksDart = 'dart';
const String ksDelay = 'delay';
const String ksDisableAnalytics = 'disable-analytics';
const String ksEnableAnalytics = 'enable-analytics';
const String ksGlobal = 'global';
const String ksList = 'list';
const String ksLogSweetCoreEvents = 'log-sweet-core-events';
const String ksPath = 'path';
const String ksSandboxSession = 'sandbox-session';
const String ksApiKey = 'api-key';
const String ksAdditionalCommands = 'additional-commands';
const String ksPub = 'pub';
const String ksSessionMateCli = 'sessionmate';
const String ksVerbose = 'verbose';
const String ksVersion = 'version';

/// A list of strings that are used to run the pub global list command.
const List<String> pubGlobalListArguments = [
  ksPub,
  ksGlobal,
  ksList,
];

/// A list of strings that are used to run the pub global activate command.
const List<String> pubGlobalActivateArguments = [
  ksPub,
  ksGlobal,
  ksActivate,
  ksSessionMateCli
];
