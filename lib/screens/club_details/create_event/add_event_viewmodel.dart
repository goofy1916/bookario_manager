import 'dart:io';

import 'package:flutter/material.dart';
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

  int couplePassIndex = 0;

  int malePassIndex = 0;

  int tablePassIndex = 0;

  int femalePassIndex = 0;

  void updateShowRatio() {
    showRatio = !showRatio;
    notifyListeners();
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
    if (selectedPassType == couple) {
      couplePasses[couplePassIndex]['passTitle'] = couple +
          "\n" +
          couplePasses[couplePassIndex][passNameController].text +
          ": Cost : " +
          couplePasses[couplePassIndex][totalCostController].text +
          ", Cover : " +
          couplePasses[couplePassIndex][totalCoverController].text;
      couplePassIndex++;
      couplePasses.add({
        "passNameController": TextEditingController(),
        "totalCostController": TextEditingController(),
        "totalCoverController": TextEditingController()
      });
    }
    if (selectedPassType == male) {
      malePasses[malePassIndex]['passTitle'] = male +
          " Stag\n" +
          malePasses[malePassIndex][passNameController].text +
          ": Cost : " +
          malePasses[malePassIndex][totalCostController].text +
          ", Cover : " +
          malePasses[malePassIndex][totalCoverController].text;
      malePasses.add({
        "passNameController": TextEditingController(),
        "totalCostController": TextEditingController(),
        "totalCoverController": TextEditingController()
      });
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
      femalePasses.add({
        "passNameController": TextEditingController(),
        "totalCostController": TextEditingController(),
        "totalCoverController": TextEditingController()
      });
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
}
