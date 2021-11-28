import 'package:bookario_manager/components/loading.dart';
import 'package:bookario_manager/components/size_config.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'startup_viewmodel.dart';

class StartUpView extends StatelessWidget {
  const StartUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartUpViewModel>.reactive(
      onModelReady: (viewModel) => viewModel.checkAuthentification(),
      builder: (context, viewModel, child) {
        SizeConfig().init(context);

        return const Scaffold(
          body: Loading(),
        );
      },
      viewModelBuilder: () => StartUpViewModel(),
    );
  }
}
