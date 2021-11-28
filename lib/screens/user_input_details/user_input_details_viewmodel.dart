import 'package:bookario_manager/app.locator.dart';
import 'package:bookario_manager/app.router.dart';
import 'package:bookario_manager/models/user_model.dart';
import 'package:bookario_manager/services/authentication_service.dart';
import 'package:bookario_manager/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class UserInputDetailsViewModel extends BaseViewModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final FirebaseService _firebaseService = locator<FirebaseService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> errors = [];

  String emailId = "";

  User? user;

  FocusNode nameFocusNode = FocusNode();
  FocusNode phoneNumberFocusNode = FocusNode();
  FocusNode ageFocusNode = FocusNode();
  FocusNode genderFocusNode = FocusNode();

  final nameEditingController = TextEditingController();
  final ageEditingController = TextEditingController();
  final phoneNumberEditingController = TextEditingController();

  String? gender;

  void populateFields(User user) {
    this.user = user;
  }

  Future<void> updateUserProfile() async {
    try {
      final UserModel newUser = UserModel(
        id: user!.uid,
        name: nameEditingController.text,
        phone: phoneNumberEditingController.text,
        email: user!.email!,
        age: ageEditingController.text,
        gender: gender!,
      );
      await _firebaseService.updateUser(newUser);
      await _authenticationService.checkUserLoggedIn();
      await _dialogService.showDialog(
          title: "Success", description: "Profile Updated!");
      _navigationService.clearStackAndShow(Routes.clubHomeScreen);
    } catch (e) {
      print('Error updating user profile: ');
      print(e);
    }
  }

  void addError({required String error}) {
    if (!errors.contains(error)) {
      errors.add(error);
    }
  }

  void removeError({required String error}) {
    if (errors.contains(error)) {
      errors.remove(error);
    }
  }

  void logout() {
    _authenticationService.userLogout();
    _navigationService.clearStackAndShow(Routes.signInScreen);
  }
}
