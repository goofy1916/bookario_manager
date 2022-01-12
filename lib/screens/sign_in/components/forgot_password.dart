import 'package:bookario_manager/components/constants.dart';
import 'package:bookario_manager/screens/sign_in/sign_in_viewmodel.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  final SignInViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () => viewModel.forgotPassword(),
          child: const Text(
            "Forgot Password?",
            style: TextStyle(color: kSecondaryColor),
          ),
        )
      ],
    );
  }
}
