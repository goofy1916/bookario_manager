import 'dart:developer';
import 'dart:io';

import 'package:bookario_manager/app.locator.dart';
import 'package:bookario_manager/models/club_details.dart';
import 'package:bookario_manager/models/event_model.dart';
import 'package:bookario_manager/models/pass_type_model.dart';
import 'package:bookario_manager/models/promoter_model.dart';
import 'package:bookario_manager/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

const String couple = "Couple";
const String male = "Male";
const String female = "Female";
const String table = "Table";
const String passNameController = "passNameController";
const String totalCostController = "totalCostController";
const String totalCoverController = "totalCoverController";
const String totalAllowedController = "totalAllowedController";

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

  String? selectedPassType;

  List<Map<String, dynamic>> couplePasses = [
    {
      "passNameController": TextEditingController(),
      "totalCostController": TextEditingController(),
      "totalCoverController": TextEditingController()
    }
  ];
  List<Map<String, dynamic>> malePasses = [
    {
      "passNameController": TextEditingController(),
      "totalCostController": TextEditingController(),
      "totalCoverController": TextEditingController()
    }
  ];
  List<Map<String, dynamic>> femalePasses = [
    {
      "passNameController": TextEditingController(),
      "totalCostController": TextEditingController(),
      "totalCoverController": TextEditingController()
    }
  ];
  List<Map<String, dynamic>> tablePasses = [
    {
      "passNameController": TextEditingController(),
      "totalCostController": TextEditingController(),
      "totalCoverController": TextEditingController(),
      "totalAllowedController": TextEditingController(),
    }
  ];

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

  void updateAddPassType(String passType) {
    if (passType.contains("Couple")) {
      selectedPassType = couple;
    } else if (passType.contains("Male")) {
      selectedPassType = male;
    } else if (passType.contains("Female")) {
      selectedPassType = female;
    } else if (passType.contains("Table")) {
      selectedPassType = table;
    }
    notifyListeners();
  }

  void clearSelectedPassType() {
    selectedPassType = null;
    notifyListeners();
  }

  void addPass() {
    final newEntry = <String, dynamic>{
      "passNameController": TextEditingController(),
      "totalCostController": TextEditingController(),
      "totalCoverController": TextEditingController()
    };
    if (selectedPassType == couple) {
      couplePasses[couplePasses.length - 1]['passTitle'] = couple +
          "\n" +
          couplePasses[couplePasses.length - 1][passNameController].text +
          ": Cost : " +
          couplePasses[couplePasses.length - 1][totalCostController].text +
          ", Cover : " +
          couplePasses[couplePasses.length - 1][totalCoverController].text;

      couplePasses.add(newEntry);
    }
    if (selectedPassType == male) {
      malePasses[malePasses.length - 1]['passTitle'] = male +
          " Stag\n" +
          malePasses[malePasses.length - 1][passNameController].text +
          ": Cost : " +
          malePasses[malePasses.length - 1][totalCostController].text +
          ", Cover : " +
          malePasses[malePasses.length - 1][totalCoverController].text;
      malePasses.add(newEntry);
    }
    if (selectedPassType == female) {
      femalePasses[femalePasses.length - 1]['passTitle'] = female +
          " Stag\n" +
          femalePasses[femalePasses.length - 1][passNameController].text +
          ": Cost : " +
          femalePasses[femalePasses.length - 1][totalCostController].text +
          ", Cover : " +
          femalePasses[femalePasses.length - 1][totalCoverController].text;
      femalePasses.add(newEntry);
    }
    if (selectedPassType == table) {
      tablePasses[tablePasses.length - 1]['passTitle'] = table +
          "\n" +
          tablePasses[tablePasses.length - 1][passNameController].text +
          ": Cost : " +
          tablePasses[tablePasses.length - 1][totalCostController].text +
          ", Cover : " +
          tablePasses[tablePasses.length - 1][totalCoverController].text +
          ", Allowed : " +
          tablePasses[tablePasses.length - 1][totalAllowedController].text;
      tablePasses.add({
        "passNameController": TextEditingController(),
        "totalCostController": TextEditingController(),
        "totalCoverController": TextEditingController(),
        totalAllowedController: TextEditingController()
      });
    }
    notifyListeners();
  }

  removePass(String type, String title) {
    if (type == couple) {
      couplePasses.removeWhere((element) => element['passTitle'] == title);
    }
    if (type == male) {
      malePasses.removeWhere((element) => element['passTitle'] == title);
    }
    if (type == female) {
      femalePasses.removeWhere((element) => element['passTitle'] == title);
    }
    if (type == table) {
      tablePasses.removeWhere((element) => element['passTitle'] == title);
    }
    notifyListeners();
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
        femalePasses.removeWhere((element) {
          return element[passNameController].text == "";
        });
        malePasses
            .removeWhere((element) => element[passNameController].text == "");
        couplePasses
            .removeWhere((element) => element[passNameController].text == "");
        tablePasses
            .removeWhere((element) => element[passNameController].text == "");

        List<PassType> femaleEntry = femalePasses
            .map((pass) => PassType(
                double.tryParse(
                        (pass[totalCoverController] as TextEditingController)
                            .text) ??
                    0,
                double.parse(
                    (pass[totalCostController] as TextEditingController).text),
                pass[passNameController].text,
                null))
            .toList();

        List<PassType> maleEntry = malePasses
            .map((pass) => PassType(
                double.tryParse(
                        (pass[totalCoverController] as TextEditingController)
                            .text) ??
                    0,
                double.parse(
                    (pass[totalCostController] as TextEditingController).text),
                pass[passNameController].text,
                null))
            .toList();

        List<PassType> coupleEntry = couplePasses
            .map((pass) => PassType(
                double.tryParse(
                        (pass[totalCoverController] as TextEditingController)
                            .text) ??
                    0,
                double.parse(
                    (pass[totalCostController] as TextEditingController).text),
                pass[passNameController].text,
                null))
            .toList();

        List<PassType> tableEntry = tablePasses
            .map((pass) => PassType(
                double.tryParse(
                        (pass[totalCoverController] as TextEditingController)
                            .text) ??
                    0,
                double.parse(
                    (pass[totalCostController] as TextEditingController).text),
                pass[passNameController].text,
                int.parse(
                    (pass[totalAllowedController] as TextEditingController)
                        .text)))
            .toList();

        String thumbnailURL = await _firebaseService.uploadImageToFirebase(
            coverPhoto!, eventNameTextController.text);

        EventModel event = EventModel(
            clubId: club.id,
            dateTime: Timestamp.fromDate(
                DateTime.tryParse(dateTimeTextController.text)!),
            desc: eventDescriptionTextController.text,
            maxPasses: int.tryParse(totalCapacityTextController.text) ?? 0,
            name: eventNameTextController.text,
            femaleRatio: int.tryParse(femaleRatioTextController.text) ?? 1,
            maleRatio: int.tryParse(maleRatioTextController.text) ?? 1,
            eventThumbnail: thumbnailURL,
            location: location!,
            stagFemaleEntry: femaleEntry,
            stagMaleEntry: maleEntry,
            coupleEntry: coupleEntry,
            tableOption: tableEntry,
            bookedPasses: <String>[],
            remainingPasses:
                int.tryParse(totalCapacityTextController.text) ?? 0,
            maxTables: int.tryParse(tableCountTextController.text) ?? 0,
            totalMale: int.tryParse(maleCountTextController.text) ?? 0,
            totalFemale: int.tryParse(femaleCountTextController.text) ?? 0,
            totalTable: int.tryParse(tableCountTextController.text) ?? 0,
            promoters: selectedPromoters.map((e) => e.promoterId).toList());

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
