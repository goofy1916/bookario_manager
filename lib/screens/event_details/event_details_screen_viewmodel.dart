import 'dart:developer';

import 'package:bookario_manager/app.locator.dart';
import 'package:bookario_manager/app.router.dart';
import 'package:bookario_manager/components/enum.dart';
import 'package:bookario_manager/models/coupon_model.dart';
import 'package:bookario_manager/models/event_model.dart';
import 'package:bookario_manager/models/pass_type_model.dart';
import 'package:bookario_manager/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class EventDetailsViewModel extends BaseViewModel {
  final FirebaseService _firebaseService = locator<FirebaseService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();

  // *Coupon creation logic
  bool isCouponPercent = false;

  final percentOff = TextEditingController();
  final maxCoupons = TextEditingController();
  final maxDiscount = TextEditingController();
  final minAmounRequired = TextEditingController();
  final maxDiscountAmount = TextEditingController();

  List<CouponModel> couponsForEvent = [];

  bool addNewCoupon = false;
  String couponType = "Percent";

  late EventModel event;

  List<Map<String, dynamic>> promoterDetails = [];

  TextEditingController maleCountController = TextEditingController(text: "0");

  TextEditingController femaleCountController =
      TextEditingController(text: "0");

  EventDisplayType eventDisplayType = EventDisplayType.edit;

  updateIsCouponPercent(bool value) {
    isCouponPercent = value;
    notifyListeners();
  }

  void newCoupon() {
    addNewCoupon = true;
    notifyListeners();
  }

  updateCouponType(String? value) {
    couponType = value!;
    notifyListeners();
  }

  Future<void> addCoupon() async {
    CouponModel couponModel = CouponModel(
        percentOff: couponType == "Percent"
            ? double.parse(percentOff.text.toString())
            : null,
        maxAmount: double.parse(maxDiscount.text.toString()),
        minAmountRequired: double.parse(minAmounRequired.text.toString()),
        maxCoupons: int.parse(maxCoupons.text.toString()),
        remainingCoupons: int.parse(maxCoupons.text.toString()));

    _firebaseService.addCoupon(
        eventId: event.id!, coupon: couponModel.toJson());
    log("Coupon Added: " + couponModel.toJson().toString());
    cancelCoupon();
    setBusyForObject("coupons", true);
    await getCouponsForEvent();
    setBusyForObject("coupons", false);
  }

  void cancelCoupon() {
    percentOff.clear();
    addNewCoupon = false;
    maxCoupons.clear();
    maxDiscount.clear();
    minAmounRequired.clear();
    notifyListeners();
  }

  getCouponsForEvent() async {
    couponsForEvent =
        await _firebaseService.getCouponsForEvent(eventId: event.id);
  }

  setEvent(EventModel currentEvent, EventDisplayType eventDisplayType) async {
    event = currentEvent;
    this.eventDisplayType = eventDisplayType;

    getPromoterPasses();
    setBusyForObject("coupons", true);
    await getCouponsForEvent();
    setBusyForObject("coupons", false);
  }

  removePass(String passType, PassType pass) async {
    final response = await _dialogService.showConfirmationDialog(
        title: "Confirm",
        description: "Are you sure you want to remove this passes?");
    if (response!.confirmed) {
      await _firebaseService.removePass(passType, pass.type, event.id!);
      setBusy(true);

      event = await locator<FirebaseService>().getEvent(event.id!);

      setBusy(false);
      notifyListeners();
    }
  }

  goToQrCodeScanner(EventDetailsViewModel viewModel) async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.QR);
    log("QR code : " + barcodeScanRes);
    if (barcodeScanRes.isNotEmpty) {
      viewModel.checkScannedPass(barcodeScanRes);
    }
  }

  updateEvent() async {
    await _firebaseService.updateEvent(event.toJson(), event.id!);
    refreshEvent();
  }

  void createPasses() async {
    final result = await _navigationService.navigateTo(Routes.createPassView,
        arguments: CreatePassViewArguments(event: event));
    setBusy(true);
    if (result != null && result) {
      event = await _firebaseService.getEvent(event.id!);
    }
    setBusy(false);
  }

  getPromoters() async {
    List<String> promoters = [];
    event.promoters?.forEach((element) {
      promoters.add(element.toString());
    });
    await _navigationService.navigateTo(Routes.addPromoters,
        arguments:
            AddPromotersArguments(eventId: event.id!, promoters: promoters));
    refreshEvent();
  }

  void checkScannedPass(String barcodeScanRes) {
    _navigationService.navigateTo(Routes.showScannedPass,
        arguments: ShowScannedPassArguments(
            passId: barcodeScanRes, eventId: event.id!));
  }

  checkAllPasses() {
    _navigationService.navigateTo(Routes.bookingHistory,
        arguments: BookingHistoryArguments(eventId: event.id!));
  }

  Future<void> balanceCrowd() async {
    try {
      int maleCount = int.parse(maleCountController.text) + event.totalMale;
      int femaleCount =
          int.parse(femaleCountController.text) + event.totalFemale;
      await _firebaseService.updateCrowd(event.id!, maleCount, femaleCount);
      _navigationService.back();

      notifyListeners();
    } catch (e) {
      await _dialogService.showDialog(
          title: "Invalid Values", description: "$e");
    }
  }

  refreshEvent() async {
    log("Event refreshed");
    event = await _firebaseService.getEvent(event.id!);
    notifyListeners();
  }

  removeCoupon(CouponModel coupon) async {
    final response = await _dialogService.showConfirmationDialog(
        title: "Caution",
        description: "Are you sure you want delete this coupon?");
    if (response?.confirmed ?? false) {
      await _firebaseService.removeCoupon(coupon, event.id!);
      refreshEvent();
    }
  }

  handleBack(bool confirm) async {
    if (confirm) {
      final response = await _dialogService.showConfirmationDialog(
          title: "Caution",
          description: "Are you sure you want create this event?");
      if (response?.confirmed ?? false) {
        _navigationService.back(result: true);
      }
    }
  }

  EventDetailsType selectedEventDetailsType = EventDetailsType.passes;

  toggleDetailType(EventDetailsType eventDetailsType) {
    selectedEventDetailsType = eventDetailsType;
    notifyListeners();
  }

  makeEventPremium() async {
    final response = await _dialogService.showConfirmationDialog(
        title: "Confirm",
        description: "Are you sure you want make this Event Premium?");

    if (response?.confirmed ?? false) {
      final response = await _navigationService.navigateTo(Routes.makePayment,
          arguments:
              MakePaymentArguments(type: "Premium event", amount: 500.00));

      if (response?[0] == "SUCCESS") {
        Map<String, dynamic> transation = {
          'type': "premium event",
          'amount': 500,
          'eventId': event.id!,
          'dateTime': Timestamp.now(),
          'transactionID': response[1],
        };
        await _firebaseService.makeEventPremium(event.id!, transation);
        refreshEvent();
      }
    }
  }

  void getPromoterPasses() async {
    for (final promoter in event.promoters ?? []) {
      final passCount =
          await _firebaseService.getPassesByPromoter(event.id!, promoter);
      promoterDetails.add({"id": promoter, "passCount": passCount});
    }
    log("Promoter Passes:" + promoterDetails.toString());
  }
}
