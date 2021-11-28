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

  int couplePassIndex = 0;

  int malePassIndex = 0;

  int tablePassIndex = 0;

  int femalePassIndex = 0;

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
    final newEntry = {
      "passNameController": TextEditingController(),
      "totalCostController": TextEditingController(),
      "totalCoverController": TextEditingController()
    };
    if (selectedPassType == couple) {
      couplePasses[couplePassIndex]['passTitle'] = couple +
          "\n" +
          couplePasses[couplePassIndex][passNameController].text +
          ": Cost : " +
          couplePasses[couplePassIndex][totalCostController].text +
          ", Cover : " +
          couplePasses[couplePassIndex][totalCoverController].text;
      couplePassIndex++;
      couplePasses.add(newEntry);
    }
    if (selectedPassType == male) {
      malePasses[malePassIndex]['passTitle'] = male +
          " Stag\n" +
          malePasses[malePassIndex][passNameController].text +
          ": Cost : " +
          malePasses[malePassIndex][totalCostController].text +
          ", Cover : " +
          malePasses[malePassIndex][totalCoverController].text;
      malePasses.add(newEntry);
      malePassIndex++;
    }
    if (selectedPassType == female) {
      femalePasses[femalePassIndex]['passTitle'] = female +
          " Stag\n" +
          femalePasses[femalePassIndex][passNameController].text +
          ": Cost : " +
          femalePasses[femalePassIndex][totalCostController].text +
          ", Cover : " +
          femalePasses[femalePassIndex][totalCoverController].text;
      femalePasses.add(newEntry);
      femalePassIndex++;
    }
    if (selectedPassType == table) {
      tablePasses[tablePassIndex]['passTitle'] = table +
          "\n" +
          tablePasses[tablePassIndex][passNameController].text +
          ": Cost : " +
          tablePasses[tablePassIndex][totalCostController].text +
          ", Cover : " +
          tablePasses[tablePassIndex][totalCoverController].text +
          ", Allowed : " +
          tablePasses[tablePassIndex][totalAllowedController].text;
      tablePasses.add({
        "passNameController": TextEditingController(),
        "totalCostController": TextEditingController(),
        "totalCoverController": TextEditingController(),
        totalAllowedController: TextEditingController()
      });
      tablePassIndex++;
    }
    notifyListeners();
  }

  removePass(String type, String title) {
    if (type == couple) {
      couplePasses.removeWhere((element) => element['passTitle'] == title);
      couplePassIndex = couplePasses.length - 1;
    }
    if (type == male) {
      malePasses.removeWhere((element) => element['passTitle'] == title);
      malePassIndex = malePasses.length - 1;
    }
    if (type == female) {
      femalePasses.removeWhere((element) => element['passTitle'] == title);
      femalePassIndex = femalePasses.length - 1;
    }
    if (type == table) {
      tablePasses.removeWhere((element) => element['passTitle'] == title);
      tablePassIndex = tablePasses.length - 1;
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
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      List<PassType> femaleEntry = femalePasses
          .map((pass) => PassType(
              double.tryParse(
                      (pass[totalCoverController] as TextEditingController)
                          .text) ??
                  0,
              double.tryParse(
                      (pass[totalCostController] as TextEditingController)
                          .text) ??
                  1,
              pass[passNameController].text,
              null))
          .toList();

      List<PassType> maleEntry = malePasses
          .map((pass) => PassType(
              double.tryParse(
                      (pass[totalCoverController] as TextEditingController)
                          .text) ??
                  0,
              double.tryParse(
                      (pass[totalCostController] as TextEditingController)
                          .text) ??
                  1,
              pass[passNameController].text,
              null))
          .toList();

      List<PassType> coupleEntry = couplePasses
          .map((pass) => PassType(
              double.tryParse(
                      (pass[totalCoverController] as TextEditingController)
                          .text) ??
                  0,
              double.tryParse(
                      (pass[totalCostController] as TextEditingController)
                          .text) ??
                  1,
              pass[passNameController].text,
              null))
          .toList();

      List<PassType> tableEntry = tablePasses
          .map((pass) => PassType(
              double.tryParse(
                      (pass[totalCoverController] as TextEditingController)
                          .text) ??
                  0,
              double.tryParse(
                      (pass[totalCostController] as TextEditingController)
                          .text) ??
                  1,
              pass[passNameController].text,
              int.tryParse((pass[totalCoverController] as TextEditingController)
                      .text) ??
                  0))
          .toList();

      String thumbnailURL = await _firebaseService.uploadImageToFirebase(
          coverPhoto!, eventNameTextController.text);

      EventModel event = EventModel(
          clubId: "club.id",
          dateTime: Timestamp.fromDate(
              DateTime.tryParse(dateTimeTextController.text)!),
          desc: eventDescriptionTextController.text,
          maxPasses: int.tryParse(totalCapacityTextController.text) ?? 0,
          name: eventNameTextController.text,
          femaleRatio: int.tryParse(femaleRatioTextController.text) ?? 1,
          maleRatio: int.tryParse(maleRatioTextController.text) ?? 1,
          eventThumbnail: "eventThumbnail",
          location: location!,
          stagFemaleEntry: femaleEntry,
          stagMaleEntry: maleEntry,
          coupleEntry: coupleEntry,
          tableOption: tableEntry,
          remainingPasses: int.tryParse(totalCapacityTextController.text) ?? 0,
          maxTables: int.tryParse(tableCountTextController.text) ?? 0,
          totalMale: int.tryParse(maleCountTextController.text) ?? 0,
          totalFemale: int.tryParse(femaleCountTextController.text) ?? 0,
          totalTable: int.tryParse(tableCountTextController.text) ?? 0,
          promoters: selectedPromoters.map((e) => e.promoterId).toList());

      print("Created Event: " + event.toJson().toString());
    }
  }
}
