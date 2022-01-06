import 'package:bookario_manager/app.locator.dart';
import 'package:bookario_manager/app.router.dart';
import 'package:bookario_manager/models/club_details.dart';
import 'package:bookario_manager/services/authentication_service.dart';
import 'package:bookario_manager/services/firebase_service.dart';
import 'package:bookario_manager/services/local_storage_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeScreenViewModel extends BaseViewModel {
  final FirebaseService _firebaseService = locator<FirebaseService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  // User user;
  // File coverPhoto;
  bool hasClubs = false,
      homeLoading = true,
      loadMore = false,
      loadingMore = false;
  // int offset, limit;
  List<ClubDetails>? myClubs;

  final LocalStorageService _localStorageService =
      locator<LocalStorageService>();

  checkAuthentification() async {
    _authenticationService.checkUserLoggedIn();
  }

  getMyClubs() async {
    setBusy(true);
    myClubs = await _firebaseService
        .getMyClubs(_authenticationService.currentUser!.id!);
    if (myClubs?.length == 1) {
      _navigationService.navigateTo(Routes.clubDetailsView,
          arguments: ClubDetailsViewArguments(club: myClubs!.first));
    }
    hasClubs = true;
    setBusy(false);
  }

  void logout() {
    _authenticationService.userLogout();
    _localStorageService.clearLocalStorage();
    _navigationService.clearStackAndShow(Routes.signInScreen);
  }
}
