import 'package:bookario_manager/app.locator.dart';
import 'package:bookario_manager/app.router.dart';
import 'package:bookario_manager/services/authentication_service.dart';
import 'package:bookario_manager/services/local_storage_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class StartUpViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();

  Future checkAuthentification() async {
    setBusy(true);
    await locator<LocalStorageService>().init();
    final bool isLoggedIn =
        await locator<AuthenticationService>().checkUserLoggedIn();

    if (isLoggedIn) {
      _navigationService.clearStackAndShow(Routes.clubHomeScreen);
    } else {
      _navigationService.replaceWith(Routes.signInScreen);
    }

    setBusy(false);
  }
}
