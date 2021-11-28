// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

import 'models/club_details.dart';
import 'screens/club_details/club_details_view.dart';
import 'screens/home/club_home_screen.dart';
import 'screens/sign_in/sign_in_screen.dart';
import 'screens/startup/startup_view.dart';
import 'screens/user_input_details/user_input_details_view.dart';

class Routes {
  static const String startUpView = '/';
  static const String signInScreen = '/sign_in';
  static const String userInputDetailsView = '/user_details';
  static const String clubHomeScreen = '/home_screen';
  static const String clubDetailsView = '/club_details';
  static const all = <String>{
    startUpView,
    signInScreen,
    userInputDetailsView,
    clubHomeScreen,
    clubDetailsView,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.startUpView, page: StartUpView),
    RouteDef(Routes.signInScreen, page: SignInScreen),
    RouteDef(Routes.userInputDetailsView, page: UserInputDetailsView),
    RouteDef(Routes.clubHomeScreen, page: ClubHomeScreen),
    RouteDef(Routes.clubDetailsView, page: ClubDetailsView),
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
        builder: (context) => SignInScreen(),
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

/// ClubDetailsView arguments holder class
class ClubDetailsViewArguments {
  final Key? key;
  final ClubDetails club;
  ClubDetailsViewArguments({this.key, required this.club});
}
