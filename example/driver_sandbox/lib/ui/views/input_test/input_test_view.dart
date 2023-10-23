import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'input_test_viewmodel.dart';

class InputTestView extends StackedView<InputTestViewModel> {
  const InputTestView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    InputTestViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: TextFormField(
            controller: TextEditingController(),
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => viewModel.showOnEnterDialog(),
          ),
        ),
      ),
    );
  }

  @override
  InputTestViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      InputTestViewModel();
}
