import 'dart:developer';

import 'package:bookario_manager/app.locator.dart';
import 'package:bookario_manager/models/event_model.dart';
import 'package:bookario_manager/models/pass_type_model.dart';
import 'package:bookario_manager/services/firebase_service.dart';
import 'package:flutter/material.dart';
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

class CreatePassViewModel extends BaseViewModel {
  String? selectedPassType;

  late EventModel currentEvent;

  updateEventId(EventModel event) {
    currentEvent = event;
  }

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

  addPassesToEvent() async {
    femalePasses.removeWhere((element) {
      return element[passNameController].text == "";
    });
    malePasses.removeWhere((element) => element[passNameController].text == "");
    couplePasses
        .removeWhere((element) => element[passNameController].text == "");
    tablePasses
        .removeWhere((element) => element[passNameController].text == "");

    List<Map<String, dynamic>> femaleEntry = femalePasses
        .map((pass) => PassType(
                double.tryParse(
                        (pass[totalCoverController] as TextEditingController)
                            .text) ??
                    0,
                double.parse(
                    (pass[totalCostController] as TextEditingController).text),
                pass[passNameController].text,
                null)
            .toJson())
        .toList();

    List<Map<String, dynamic>> maleEntry = malePasses
        .map((pass) => PassType(
                double.tryParse(
                        (pass[totalCoverController] as TextEditingController)
                            .text) ??
                    0,
                double.parse(
                    (pass[totalCostController] as TextEditingController).text),
                pass[passNameController].text,
                null)
            .toJson())
        .toList();

    List<Map<String, dynamic>> coupleEntry = couplePasses
        .map((pass) => PassType(
                double.tryParse(
                        (pass[totalCoverController] as TextEditingController)
                            .text) ??
                    0,
                double.parse(
                    (pass[totalCostController] as TextEditingController).text),
                pass[passNameController].text,
                null)
            .toJson())
        .toList();

    List<Map<String, dynamic>> tableEntry = tablePasses
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
                        .text))
            .toJson())
        .toList();

    final response = await locator<DialogService>().showConfirmationDialog(
        title: "Confirm",
        description: "Are you sure you want to create these passes?");

    Map<String, dynamic> eventJson = currentEvent.toJson();

    log("passes" +
        {
          "stagMaleEntry": maleEntry + eventJson["stagMaleEntry"],
          "stagFemaleEntry": femaleEntry + eventJson["stagFemaleEntry"],
          "coupleEntry": coupleEntry + eventJson["coupleEntry"],
          "tableOption": tableEntry + eventJson["tableOption"],
        }.toString());
    if (response!.confirmed) {
      await locator<FirebaseService>().addPassesToEvent(currentEvent.id!, {
        "stagMaleEntry": maleEntry + eventJson["stagMaleEntry"],
        "stagFemaleEntry": femaleEntry + eventJson["stagFemaleEntry"],
        "coupleEntry": coupleEntry + eventJson["coupleEntry"],
        "tableOption": tableEntry + eventJson["tableOption"],
      });
      locator<NavigationService>().back(result: true);
    }
  }
}

// "stagFemaleEntry": stagFemaleEntryJson,
      // "stagMaleEntry": stagMaleEntryJson,
      // "coupleEntry": coupleEntryJson,
      // "tableOption":