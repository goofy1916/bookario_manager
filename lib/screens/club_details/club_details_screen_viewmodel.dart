import 'dart:developer';

import 'package:bookario_manager/app.locator.dart';
import 'package:bookario_manager/models/club_details.dart';
import 'package:bookario_manager/models/event_model.dart';
import 'package:bookario_manager/services/firebase_service.dart';
import 'package:stacked/stacked.dart';

class ClubDetailsViewModel extends BaseViewModel {
  bool hasEvents = false;

  final FirebaseService _firebaseService = locator<FirebaseService>();

  List<EventModel> myEvents = [];

  getMyEvents(ClubDetails club) async {
    try {
      myEvents = await _firebaseService.getMyEvents(club.id);
      if (myEvents.isNotEmpty) {
        hasEvents = true;
      }
      notifyListeners();
    } catch (e) {
      log("Club Details ViewModel" + e.toString());
    }
  }
}
