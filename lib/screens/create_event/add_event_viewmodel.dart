import 'dart:developer';
import 'dart:io';

import 'package:bookario_manager/app.locator.dart';
import 'package:bookario_manager/app.router.dart';
import 'package:bookario_manager/components/enum.dart';
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
  final NavigationService _navigationService = locator<NavigationService>();

  late ClubDetails club;
  CreateOrEdit createOrEdit = CreateOrEdit.create;
  EventModel? event;

  final formKey = GlobalKey<FormState>();

  FocusNode eventNameFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();
  FocusNode dateFocusNode = FocusNode();
  FocusNode timeHrFocusNode = FocusNode();
  FocusNode timeMinFocusNode = FocusNode();
  FocusNode capacityFocusNode = FocusNode();
  FocusNode mfmRatioFocusNode = FocusNode();
  FocusNode mffRatioFocusNode = FocusNode();
  FocusNode pricesFocusNode = FocusNode();

  bool hasCoverPhoto = false;
  File? coverPhoto;
  bool loading = false;

  TextEditingController dateTimeTextController = TextEditingController();

  TextEditingController eventNameTextController = TextEditingController();

  TextEditingController eventDescriptionTextController =
      TextEditingController();

  TextEditingController totalCapacityTextController = TextEditingController();

  bool showRatio = false;

  TextEditingController maleRatioTextController = TextEditingController();

  TextEditingController femaleRatioTextController = TextEditingController();

  TextEditingController tableCountTextController = TextEditingController();

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

  setClub(ClubDetails currentClub, CreateOrEdit? createOrEdit,
      EventModel? eventModel) async {
    setBusy(true);
    club = currentClub;
    this.createOrEdit = createOrEdit ?? CreateOrEdit.create;
    if (this.createOrEdit == CreateOrEdit.edit) {
      event = eventModel;
      updateControllers();
    }
    setBusy(false);
  }

  updateEvent() async {
    try {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        String? thumbnailURL;
        if (coverPhoto != null) {
          thumbnailURL = await _firebaseService.uploadImageToFirebase(
              coverPhoto!, eventNameTextController.text);
        }

        EventModel updatedEvent = EventModel(
            clubId: club.id,
            dateTime: Timestamp.fromDate(
                DateTime.tryParse(dateTimeTextController.text)!),
            desc: eventDescriptionTextController.text,
            maxPasses: int.tryParse(totalCapacityTextController.text) ?? 0,
            name: eventNameTextController.text,
            femaleRatio: event!.femaleRatio,
            maleRatio: event!.maleRatio,
            eventThumbnail: thumbnailURL ?? event!.eventThumbnail,
            location: club.area!,
            stagFemaleEntry: event!.stagFemaleEntry,
            stagMaleEntry: event!.stagMaleEntry,
            coupleEntry: event!.coupleEntry,
            tableOption: event!.tableOption,
            bookedPasses: event!.bookedPasses,
            remainingPasses:
                int.tryParse(totalCapacityTextController.text) ?? 0,
            maxTables: int.parse(tableCountTextController.text),
            totalMale: event!.totalMale,
            totalFemale: event!.totalFemale,
            totalTable: event!.totalTable,
            completeLocation: club.address!,
            premium: event!.premium);

        log("Updated Event : " + updatedEvent.toJson().toString());

        final result = await _navigationService.navigateTo(
            Routes.eventDetailsView,
            arguments: EventDetailsViewArguments(
                event: updatedEvent,
                eventDisplayType: EventDisplayType.preview));
        if (result ?? false) {
          await _firebaseService.updateEvent(updatedEvent.toJson(), event!.id!);
          _navigationService.navigateTo(Routes.clubHomeScreen);
        }
      }
    } catch (e) {
      await locator<DialogService>().showDialog(
          title: "Something went wrong!",
          description: "Please check all the fields have valid data!");
    }
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
            location: club.area!,
            stagFemaleEntry: [],
            stagMaleEntry: [],
            coupleEntry: [],
            tableOption: [],
            bookedPasses: <String>[],
            remainingPasses:
                int.tryParse(totalCapacityTextController.text) ?? 0,
            maxTables: int.parse(tableCountTextController.text),
            totalMale: 0,
            totalFemale: 0,
            totalTable: 0,
            completeLocation: club.address!,
            premium: false);

        final result = await _navigationService.navigateTo(
            Routes.eventDetailsView,
            arguments: EventDetailsViewArguments(
                event: event, eventDisplayType: EventDisplayType.preview));
        if (result ?? false) {
          await _firebaseService.createEvent(event.toJson());
          _navigationService.navigateTo(Routes.clubHomeScreen);
        }
      }
    } catch (e) {
      await locator<DialogService>().showDialog(
          title: "Something went wrong!",
          description: "Please check all the fields have valid data!");
    }
  }

  removeThumbnail() {
    coverPhoto = null;
    hasCoverPhoto = false;
    notifyListeners();
  }

  void updateControllers() {
    hasCoverPhoto = true;
    eventNameTextController = TextEditingController(text: event!.name);
    eventDescriptionTextController = TextEditingController(text: event!.desc);

    dateTimeTextController = TextEditingController(
        text: DateTime.fromMicrosecondsSinceEpoch(
                event!.dateTime.microsecondsSinceEpoch)
            .toString());
    totalCapacityTextController =
        TextEditingController(text: event!.remainingPasses.toString());
    if (event!.maleRatio > 0) {
      showRatio = true;
      maleRatioTextController =
          TextEditingController(text: event!.maleRatio.toString());
      femaleRatioTextController =
          TextEditingController(text: event!.femaleRatio.toString());
    }
    tableCountTextController =
        TextEditingController(text: event!.maxTables.toString());
  }
}
