import 'package:bookario_manager/app.locator.dart';
import 'package:bookario_manager/components/change_onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../components/size_config.dart';

class SigninScreenBottomText extends StatelessWidget {
  const SigninScreenBottomText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: getProportionateScreenHeight(20)),
        ChangeOnboardingScreenText(
          textFirst: "Don't have an account? ",
          clickableText: "Sign Up",
          onPressed: () {
            // locator<NavigationService>().navigateTo(Routes.signUpScreen);
          },
        ),
      ],
    );
  }
}
