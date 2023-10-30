import 'package:driver_sandbox/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:driver_sandbox/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:driver_sandbox/ui/views/home/home_view.dart';
import 'package:driver_sandbox/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:driver_sandbox/ui/views/input_test/input_test_view.dart';
import 'package:driver_sandbox/ui/views/drag_test/drag_test_view.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: StartupView),
    MaterialRoute(page: InputTestView),
    MaterialRoute(page: DragTestView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    // @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
)
class App {}
