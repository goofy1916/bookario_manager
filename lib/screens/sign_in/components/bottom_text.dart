import 'package:bookario_manager/components/change_onboarding_screen.dart';
import 'package:bookario_manager/components/size_config.dart';
import 'package:flutter/material.dart';

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
          clickableText: "Contact us!",
          onPressed: () {
            // locator<NavigationService>().navigateTo(Routes.signUpScreen);
          },
        ),
      ],
    );
  }
}
