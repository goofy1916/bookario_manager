import 'package:bookario_manager/components/make_payment.dart';
import 'package:bookario_manager/screens/add_promoter/add_promoter.dart';
import 'package:bookario_manager/screens/club_details/club_details_view.dart';
import 'package:bookario_manager/screens/create_event/add_event.dart';
import 'package:bookario_manager/screens/create_pass/create_pass_view.dart';
import 'package:bookario_manager/screens/event_details/event_details_screen.dart';
import 'package:bookario_manager/screens/history/booking_history.dart';
import 'package:bookario_manager/screens/home/club_home_screen.dart';
import 'package:bookario_manager/screens/show_scanned_pass/show_scanned_pass.dart';
import 'package:bookario_manager/screens/sign_in/components/forgot_password.dart';
import 'package:bookario_manager/screens/sign_in/sign_in_screen.dart';
import 'package:bookario_manager/screens/startup/startup_view.dart';
import 'package:bookario_manager/screens/user_input_details/user_input_details_view.dart';
import 'package:bookario_manager/services/authentication_service.dart';
import 'package:bookario_manager/services/firebase_service.dart';
import 'package:bookario_manager/services/local_storage_service.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import 'screens/forgot_password/forgot_password_view.dart';

@StackedApp(routes: [
  MaterialRoute(page: StartUpView, initial: true),
  // MaterialRoute(page: SplashScreen, path: "/splash_screen"),
  //*Login flow
  MaterialRoute(page: SignInScreen, path: "/sign_in"),
  MaterialRoute(page: UserInputDetailsView, path: "/user_details"),
  MaterialRoute(page: ForgotPasswordView, path: "/forgot_password"),
  // MaterialRoute(page: SignUpScreen, path: "/sign_up"),

  //*Home Page
  MaterialRoute(page: ClubHomeScreen, path: "/home_screen"),
  MaterialRoute(page: ClubDetailsView, path: "/club_details"),
  MaterialRoute(page: AddEvent, path: "/add_event"),
  MaterialRoute(page: MakePayment, path: "/make-payment"),

  //* Event flow
  MaterialRoute(page: EventDetailsView, path: "/event_details"),
  MaterialRoute(page: CreatePassView, path: "/create_passes"),
  MaterialRoute(page: ShowScannedPass, path: "/check_pass"),
  MaterialRoute(page: BookingHistory, path: "/booking_history"),
  MaterialRoute(page: AddPromoters, path: "/add_promoters"),
], dependencies: [
  LazySingleton(classType: NavigationService),
  LazySingleton(classType: DialogService),
  LazySingleton(classType: LocalStorageService),
  LazySingleton(classType: FirebaseService),
  LazySingleton(classType: AuthenticationService),
])
class App {}
