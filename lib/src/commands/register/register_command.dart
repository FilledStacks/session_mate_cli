import 'package:args/command_runner.dart';

import 'register_app_command.dart';
import 'register_user_command.dart';

/// A command with subcommands that allows you to register resources for the
/// corresponding license.
class RegisterCommand extends Command {
  @override
  String get description =>
      'Allows to register available resources on the license.';

  @override
  String get name => 'register';

  RegisterCommand() {
    addSubcommand(RegisterAppCommand());
    addSubcommand(RegisterUserCommand());
  }
}
