import 'package:bookario_manager/app.locator.dart';
import 'package:bookario_manager/app.router.dart';
import 'package:bookario_manager/services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SignInViewModel extends BaseViewModel {
  final formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool obscureText = true, loading = false;
  final List<String> errors = [];

  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  void addError({required String error}) {
    if (!errors.contains(error)) errors.add(error);
    notifyListeners();
  }

  void removeError({required String error}) {
    if (errors.contains(error)) errors.remove(error);
    notifyListeners();
  }

  void toggle() {
    obscureText = !obscureText;
    notifyListeners();
  }

  void validateAndSave() {
    final FormState? form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      login();
    }
  }

  Future login() async {
    setBusy(true);
    final User? result = await _authenticationService.loginWithEmail(
      email: email,
      password: password,
    );
    if (result is User) {
      _navigationService.clearStackAndShow(Routes.clubHomeScreen);
    }
    setBusy(false);
  }
}
