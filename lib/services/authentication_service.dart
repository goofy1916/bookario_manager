import 'dart:developer';

import 'package:bookario_manager/app.locator.dart';
import 'package:bookario_manager/app.router.dart';
import 'package:bookario_manager/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';

import 'firebase_service.dart';
import 'local_storage_service.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseService _firebaseService = locator<FirebaseService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final LocalStorageService _localStorageService =
      locator<LocalStorageService>();

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  Future<User?> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential authResult =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _populateCurrentUser(authResult.user);
      return authResult.user;
    } on FirebaseAuthException catch (e) {
      log(e.message.toString());
      return null;
    }
  }

  Stream<User?> get userState => _firebaseAuth.authStateChanges();

  Future<bool> checkUserLoggedIn() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      _navigationService.clearStackAndShow(Routes.signInScreen);
    }
    await _populateCurrentUser(user);
    return user != null;
  }

  Future userLogout() async {
    await _firebaseAuth.signOut();
  }

  Future _populateCurrentUser(User? user) async {
    if (user != null) {
      _currentUser = await _firebaseService.getUserProfile(user.uid);
      if (_currentUser == null) {
        _navigationService.replaceWith(Routes.userInputDetailsView,
            arguments: UserInputDetailsViewArguments(user: user));
      } else {
        _localStorageService.setter("uid", _currentUser!.id!);
      }
    }
  }

  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
