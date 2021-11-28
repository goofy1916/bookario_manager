import 'package:bookario_manager/screens/club_details/club_details_view.dart';
import 'package:bookario_manager/screens/eventDetails/event_details.dart';
import 'package:bookario_manager/screens/home/club_home_screen.dart';
import 'package:bookario_manager/screens/sign_in/sign_in_screen.dart';
import 'package:bookario_manager/screens/startup/startup_view.dart';
import 'package:bookario_manager/screens/user_input_details/user_input_details_view.dart';
import 'package:bookario_manager/services/authentication_service.dart';
import 'package:bookario_manager/services/firebase_service.dart';
import 'package:bookario_manager/services/local_storage_service.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

@StackedApp(routes: [
  MaterialRoute(page: StartUpView, initial: true),
  // MaterialRoute(page: SplashScreen, path: "/splash_screen"),
  //*Login flow
  MaterialRoute(page: SignInScreen, path: "/sign_in"),
  MaterialRoute(page: UserInputDetailsView, path: "/user_details"),
  // MaterialRoute(page: SignUpScreen, path: "/sign_up"),

  //*Home Page
  MaterialRoute(page: ClubHomeScreen, path: "/home_screen"),
  MaterialRoute(page: ClubDetailsView, path: "/club_details"),

  //* Event flow
  // MaterialRoute(page: EventDetailsScreen, path: "/event_details"),
], dependencies: [
  LazySingleton(classType: NavigationService),
  LazySingleton(classType: DialogService),
  LazySingleton(classType: LocalStorageService),
  LazySingleton(classType: FirebaseService),
  LazySingleton(classType: AuthenticationService),
])
class App {}
