import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'drag_test_viewmodel.dart';

class DragTestView extends StackedView<DragTestViewModel> {
  const DragTestView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    DragTestViewModel viewModel,
    Widget? child,
  ) {
    const double dragIndicatorSize = 20;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanStart: viewModel.onPanStart,
        onPanUpdate: viewModel.dragDetected,
        child: Stack(
          children: [
            Positioned(
              left: viewModel.dragStartPosition.dx - (dragIndicatorSize / 2),
              top: viewModel.dragStartPosition.dy - (dragIndicatorSize / 2),
              child: Container(
                width: dragIndicatorSize,
                height: dragIndicatorSize,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              left: viewModel.dragEndPosition.dx - (dragIndicatorSize / 2),
              top: viewModel.dragEndPosition.dy - (dragIndicatorSize / 2),
              child: Container(
                width: dragIndicatorSize,
                height: dragIndicatorSize,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Center(
                child: Text(
              viewModel.dragState,
              style: const TextStyle(fontSize: 40),
            )),
          ],
        ),
      ),
    );
  }

  @override
  DragTestViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      DragTestViewModel();
}
