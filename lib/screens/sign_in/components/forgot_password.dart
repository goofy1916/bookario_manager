import 'package:bookario_manager/components/constants.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {},
          // Navigator.pushNamed(context, ForgotPasswordScreen.routeName),
          child: const Text(
            "Forgot Password?",
            style: TextStyle(color: kSecondaryColor),
          ),
        )
      ],
    );
  }
}
