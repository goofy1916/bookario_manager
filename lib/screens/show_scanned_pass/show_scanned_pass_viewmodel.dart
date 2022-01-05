import 'dart:developer';

import 'package:bookario_manager/app.locator.dart';
import 'package:bookario_manager/models/event_pass_model.dart';
import 'package:bookario_manager/services/firebase_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ShowScannedPassViewModel extends BaseViewModel {
  EventPass? eventPass;

  final FirebaseService _firebaseService = locator<FirebaseService>();
  final DialogService _dialogService = locator<DialogService>();

  Future getBookingData(String passId, String eventId) async {
    setBusy(true);
    eventPass = await _firebaseService.getPass(passId);
    log(eventPass.toString());
    if (eventPass != null && eventPass!.eventId != eventId) {
      setError(true);
    }
    setBusy(false);
  }

  Future<void> markPassChecked(String passId) async {
    final response = await _dialogService.showConfirmationDialog(
        title: "Confirm", description: "Do you want confirm the pass?");

    if (response!.confirmed) {
      await _firebaseService.approvePass(passId);
    }
    locator<NavigationService>().back();
  }
}
