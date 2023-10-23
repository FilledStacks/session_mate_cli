import 'package:driver_sandbox/app/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class InputTestViewModel extends BaseViewModel {
  final _dialogService = locator<DialogService>();

  void showOnEnterDialog() {
    _dialogService.showConfirmationDialog(
        title: 'On enter pressed!',
        description:
            'This dialog confirms that the app has registered an onEnter press',
        confirmationTitle: 'Awesome');
  }
}
