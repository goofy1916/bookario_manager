import 'dart:developer';

import 'package:bookario_manager/app.locator.dart';
import 'package:bookario_manager/app.router.dart';
import 'package:bookario_manager/components/enum.dart';
import 'package:bookario_manager/models/club_details.dart';
import 'package:bookario_manager/models/event_model.dart';
import 'package:bookario_manager/services/firebase_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ClubDetailsViewModel extends BaseViewModel {
  bool hasEvents = false;

  final FirebaseService _firebaseService = locator<FirebaseService>();
  final NavigationService _navigationService = locator<NavigationService>();

  late ClubDetails myClub;

  List<EventModel> myEvents = [];
  List<EventModel> upcomingEvents = [];
  List<EventModel> pastEvents = [];
  List<EventModel> get getEvents =>
      selectedEventType == EventType.upcoming ? upcomingEvents : pastEvents;

  EventType selectedEventType = EventType.upcoming;

  getMyEvents(
    ClubDetails club,
  ) async {
    // try {
    myClub = club;
    setBusy(true);
    upcomingEvents = [];
    pastEvents = [];
    myEvents = await _firebaseService.getMyEvents(club.id);
    if (myEvents.isNotEmpty) {
      hasEvents = true;
    }
    for (final event in myEvents) {
      if (event.dateTime.toDate().isAfter(DateTime.now())) {
        upcomingEvents.add(event);
      } else {
        pastEvents.add(event);
      }
    }
    setBusy(false);
    notifyListeners();
    // } catch (e) {
    //   log("Club Details ViewModel" + e.toString());
    //   setBusy(false);
    // }
  }

  toggleEventType(EventType type) {
    selectedEventType = type;
    notifyListeners();
  }

  editEvent(EventModel event) async {
    await _navigationService.navigateTo(Routes.addEvent,
        arguments: AddEventArguments(
            club: myClub, event: event, createOrEdit: CreateOrEdit.edit));

    getMyEvents(myClub);
  }
}
