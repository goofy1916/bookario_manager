// ignore_for_file: file_names

import 'package:bookario_manager/app.locator.dart';
import 'package:bookario_manager/models/promoter_model.dart';
import 'package:bookario_manager/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AddPromoterViewModel extends BaseViewModel {
  final FirebaseService _firebaseService = locator<FirebaseService>();
  final NavigationService _navigationService = locator<NavigationService>();
  List<PromoterModel> promoters = [];
  List<PromoterModel> selectedPromoters = [];
  late String eventid;

  TextEditingController searchPromoterController = TextEditingController();

  List<PromoterModel> promoterSearchList = [];

  getPromoters(String eventId, List<String> promoterList) async {
    setBusy(true);
    promoters = await _firebaseService.getPromoters()
      ..sort((PromoterModel a, PromoterModel b) => a.name.compareTo(b.name));
    promoterSearchList = promoters;
    selectedPromoters.addAll(promoters
        .where((element) => promoterList.contains(element.promoterId)));
    eventid = eventId;
    setBusy(false);
  }

  removePromoter(String title) {
    selectedPromoters.removeWhere((element) => element.name == title);
    notifyListeners();
  }

  updateSelectedPromoters(
      {required PromoterModel promoter, required bool add}) {
    add ? selectedPromoters.add(promoter) : selectedPromoters.remove(promoter);
    notifyListeners();
  }

  addPromoters() async {
    List<String> promoterList = [];
    for (var element in selectedPromoters) {
      promoterList.add(element.promoterId);
    }
    final response = await locator<DialogService>().showConfirmationDialog(
        title: "Caution",
        description: "Are you sure you want add these promoters?");
    if (response?.confirmed ?? false) {
      await _firebaseService.addPromoters(eventid, promoterList);
      _navigationService.back();
    }
  }

  updatePromoterSearchList(String? promoter) {
    promoterSearchList = promoters
        .where((element) =>
            element.promoterId
                .toLowerCase()
                .contains((promoter ?? "").toLowerCase()) ||
            element.name.toLowerCase().contains((promoter ?? "").toLowerCase()))
        .toList();

    notifyListeners();
  }
}
