// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

import 'components/enum.dart';
import 'components/make_payment.dart';
import 'models/club_details.dart';
import 'models/event_model.dart';
import 'screens/add_promoter/add_promoter.dart';
import 'screens/club_details/club_details_view.dart';
import 'screens/create_event/add_event.dart';
import 'screens/create_pass/create_pass_view.dart';
import 'screens/event_details/event_details_screen.dart';
import 'screens/forgot_password/forgot_password_view.dart';
import 'screens/history/booking_history.dart';
import 'screens/home/club_home_screen.dart';
import 'screens/show_scanned_pass/show_scanned_pass.dart';
import 'screens/sign_in/sign_in_screen.dart';
import 'screens/startup/startup_view.dart';
import 'screens/user_input_details/user_input_details_view.dart';

class Routes {
  static const String startUpView = '/';
  static const String signInScreen = '/sign_in';
  static const String userInputDetailsView = '/user_details';
  static const String forgotPasswordView = '/forgot_password';
  static const String clubHomeScreen = '/home_screen';
  static const String clubDetailsView = '/club_details';
  static const String addEvent = '/add_event';
  static const String makePayment = '/make-payment';
  static const String eventDetailsView = '/event_details';
  static const String createPassView = '/create_passes';
  static const String showScannedPass = '/check_pass';
  static const String bookingHistory = '/booking_history';
  static const String addPromoters = '/add_promoters';
  static const all = <String>{
    startUpView,
    signInScreen,
    userInputDetailsView,
    forgotPasswordView,
    clubHomeScreen,
    clubDetailsView,
    addEvent,
    makePayment,
    eventDetailsView,
    createPassView,
    showScannedPass,
    bookingHistory,
    addPromoters,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.startUpView, page: StartUpView),
    RouteDef(Routes.signInScreen, page: SignInScreen),
    RouteDef(Routes.userInputDetailsView, page: UserInputDetailsView),
    RouteDef(Routes.forgotPasswordView, page: ForgotPasswordView),
    RouteDef(Routes.clubHomeScreen, page: ClubHomeScreen),
    RouteDef(Routes.clubDetailsView, page: ClubDetailsView),
    RouteDef(Routes.addEvent, page: AddEvent),
    RouteDef(Routes.makePayment, page: MakePayment),
    RouteDef(Routes.eventDetailsView, page: EventDetailsView),
    RouteDef(Routes.createPassView, page: CreatePassView),
    RouteDef(Routes.showScannedPass, page: ShowScannedPass),
    RouteDef(Routes.bookingHistory, page: BookingHistory),
    RouteDef(Routes.addPromoters, page: AddPromoters),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    StartUpView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const StartUpView(),
        settings: data,
      );
    },
    SignInScreen: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const SignInScreen(),
        settings: data,
      );
    },
    UserInputDetailsView: (data) {
      var args = data.getArgs<UserInputDetailsViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => UserInputDetailsView(
          key: args.key,
          user: args.user,
        ),
        settings: data,
      );
    },
    ForgotPasswordView: (data) {
      var args = data.getArgs<ForgotPasswordViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => ForgotPasswordView(
          key: args.key,
          email: args.email,
        ),
        settings: data,
      );
    },
    ClubHomeScreen: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const ClubHomeScreen(),
        settings: data,
      );
    },
    ClubDetailsView: (data) {
      var args = data.getArgs<ClubDetailsViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => ClubDetailsView(
          key: args.key,
          club: args.club,
        ),
        settings: data,
      );
    },
    AddEvent: (data) {
      var args = data.getArgs<AddEventArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => AddEvent(
          key: args.key,
          club: args.club,
          createOrEdit: args.createOrEdit,
          event: args.event,
        ),
        settings: data,
      );
    },
    MakePayment: (data) {
      var args = data.getArgs<MakePaymentArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => MakePayment(
          key: args.key,
          type: args.type,
          amount: args.amount,
        ),
        settings: data,
      );
    },
    EventDetailsView: (data) {
      var args = data.getArgs<EventDetailsViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => EventDetailsView(
          key: args.key,
          event: args.event,
          eventDisplayType: args.eventDisplayType,
        ),
        settings: data,
      );
    },
    CreatePassView: (data) {
      var args = data.getArgs<CreatePassViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => CreatePassView(
          key: args.key,
          event: args.event,
        ),
        settings: data,
      );
    },
    ShowScannedPass: (data) {
      var args = data.getArgs<ShowScannedPassArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => ShowScannedPass(
          key: args.key,
          passId: args.passId,
          eventId: args.eventId,
        ),
        settings: data,
      );
    },
    BookingHistory: (data) {
      var args = data.getArgs<BookingHistoryArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => BookingHistory(
          key: args.key,
          eventId: args.eventId,
        ),
        settings: data,
      );
    },
    AddPromoters: (data) {
      var args = data.getArgs<AddPromotersArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => AddPromoters(
          key: args.key,
          eventId: args.eventId,
          promoters: args.promoters,
        ),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// UserInputDetailsView arguments holder class
class UserInputDetailsViewArguments {
  final Key? key;
  final User user;
  UserInputDetailsViewArguments({this.key, required this.user});
}

/// ForgotPasswordView arguments holder class
class ForgotPasswordViewArguments {
  final Key? key;
  final String email;
  ForgotPasswordViewArguments({this.key, required this.email});
}

/// ClubDetailsView arguments holder class
class ClubDetailsViewArguments {
  final Key? key;
  final ClubDetails club;
  ClubDetailsViewArguments({this.key, required this.club});
}

/// AddEvent arguments holder class
class AddEventArguments {
  final Key? key;
  final ClubDetails club;
  final CreateOrEdit? createOrEdit;
  final EventModel? event;
  AddEventArguments(
      {this.key, required this.club, this.createOrEdit, this.event});
}

/// MakePayment arguments holder class
class MakePaymentArguments {
  final Key? key;
  final String type;
  final double amount;
  MakePaymentArguments({this.key, required this.type, required this.amount});
}

/// EventDetailsView arguments holder class
class EventDetailsViewArguments {
  final Key? key;
  final EventModel event;
  final EventDisplayType eventDisplayType;
  EventDetailsViewArguments(
      {this.key, required this.event, required this.eventDisplayType});
}

/// CreatePassView arguments holder class
class CreatePassViewArguments {
  final Key? key;
  final EventModel event;
  CreatePassViewArguments({this.key, required this.event});
}

/// ShowScannedPass arguments holder class
class ShowScannedPassArguments {
  final Key? key;
  final String passId;
  final String eventId;
  ShowScannedPassArguments(
      {this.key, required this.passId, required this.eventId});
}

/// BookingHistory arguments holder class
class BookingHistoryArguments {
  final Key? key;
  final String eventId;
  BookingHistoryArguments({this.key, required this.eventId});
}

/// AddPromoters arguments holder class
class AddPromotersArguments {
  final Key? key;
  final String eventId;
  final List<String> promoters;
  AddPromotersArguments(
      {this.key, required this.eventId, required this.promoters});
}
