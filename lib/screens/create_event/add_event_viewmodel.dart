import 'dart:developer';
import 'dart:io';

import 'package:bookario_manager/app.locator.dart';
import 'package:bookario_manager/models/club_details.dart';
import 'package:bookario_manager/models/event_model.dart';
import 'package:bookario_manager/models/promoter_model.dart';
import 'package:bookario_manager/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AddEventViewModel extends IndexTrackingViewModel {
  final FirebaseService _firebaseService = locator<FirebaseService>();

  late ClubDetails club;

  final formKey = GlobalKey<FormState>();

  FocusNode eventNameFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();
  FocusNode dateFocusNode = FocusNode();
  FocusNode timeHrFocusNode = FocusNode();
  FocusNode timeMinFocusNode = FocusNode();
  FocusNode capacityFocusNode = FocusNode();
  FocusNode maleCountFocusNode = FocusNode();
  FocusNode femaleCountFocusNode = FocusNode();
  FocusNode coupleCountFocusNode = FocusNode();
  FocusNode mfmRatioFocusNode = FocusNode();
  FocusNode mffRatioFocusNode = FocusNode();
  FocusNode pricesFocusNode = FocusNode();

  File? coverPhoto;
  bool loading = false;

  TextEditingController dateTimeTextController = TextEditingController();

  TextEditingController eventNameTextController = TextEditingController();

  TextEditingController eventDescriptionTextController =
      TextEditingController();

  TextEditingController totalCapacityTextController = TextEditingController();

  bool showRatio = false;

  TextEditingController maleCountTextController = TextEditingController();

  TextEditingController femaleCountTextController = TextEditingController();

  TextEditingController couplesCountTextController = TextEditingController();

  TextEditingController maleRatioTextController = TextEditingController();

  TextEditingController femaleRatioTextController = TextEditingController();

  List<PromoterModel> promoters = [];
  TextEditingController tableCountTextController = TextEditingController();

  List<String> locations = [];

  String? location;

  List<PromoterModel> selectedPromoters = [];

  void updateShowRatio() {
    showRatio = !showRatio;
    notifyListeners();
  }

  Future<void> imgFromGallery() async {
    final XFile? image = await ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxHeight: 500);
    if (image != null) {
      coverPhoto = File(image.path);
      notifyListeners();
    }
  }

  getPromotersAndLocation(ClubDetails currentClub) async {
    setBusy(true);
    club = currentClub;
    promoters = await _firebaseService.getPromoters();
    locations = await _firebaseService.getLocations();
    setBusy(false);
  }

  updateSelectedPromoters(List<PromoterModel> selection) {
    selectedPromoters = selection;
    notifyListeners();
  }

  removePromoter(String title) {
    selectedPromoters.removeWhere((element) => element.name == title);
    notifyListeners();
  }

  createEvent() async {
    try {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();

        String thumbnailURL = await _firebaseService.uploadImageToFirebase(
            coverPhoto!, eventNameTextController.text);

        EventModel event = EventModel(
          clubId: club.id,
          dateTime: Timestamp.fromDate(
              DateTime.tryParse(dateTimeTextController.text)!),
          desc: eventDescriptionTextController.text,
          maxPasses: int.tryParse(totalCapacityTextController.text) ?? 0,
          name: eventNameTextController.text,
          femaleRatio:
              showRatio ? int.parse(femaleRatioTextController.text) : 0,
          maleRatio: showRatio ? int.parse(maleRatioTextController.text) : 0,
          eventThumbnail: thumbnailURL,
          location: location!,
          stagFemaleEntry: [],
          stagMaleEntry: [],
          coupleEntry: [],
          tableOption: [],
          bookedPasses: <String>[],
          remainingPasses: int.tryParse(totalCapacityTextController.text) ?? 0,
          maxTables: !showRatio ? int.parse(tableCountTextController.text) : 0,
          totalMale: !showRatio ? int.parse(maleCountTextController.text) : 0,
          totalFemale:
              !showRatio ? int.parse(femaleCountTextController.text) : 0,
          totalTable: !showRatio ? int.parse(tableCountTextController.text) : 0,
        );

        log("Created Event: " + event.toJson().toString());
        await _firebaseService.createEvent(event.toJson());
      }
    } catch (e) {
      await locator<DialogService>().showDialog(
          title: "Something went wrong!",
          description: "Please check all the fields have valid data!");
    }
  }
}
