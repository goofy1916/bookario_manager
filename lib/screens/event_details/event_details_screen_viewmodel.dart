import 'dart:developer';

import 'package:bookario_manager/app.locator.dart';
import 'package:bookario_manager/app.router.dart';
import 'package:bookario_manager/models/coupon_model.dart';
import 'package:bookario_manager/models/event_model.dart';
import 'package:bookario_manager/models/pass_type_model.dart';
import 'package:bookario_manager/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class EventDetailsViewModel extends BaseViewModel {
  FirebaseService firebaseService = locator<FirebaseService>();
  final NavigationService _navigationService = locator<NavigationService>();

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

  TextEditingController maleCountController = TextEditingController(text: "0");

  TextEditingController femaleCountController =
      TextEditingController(text: "0");

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

    firebaseService.addCoupon(eventId: event.id!, coupon: couponModel.toJson());
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
        await firebaseService.getCouponsForEvent(eventId: event.id);
  }

  updateEvent(EventModel currentEvent) async {
    event = currentEvent;
    setBusyForObject("coupons", true);
    await getCouponsForEvent();
    setBusyForObject("coupons", false);
  }

  removePass(String passType, PassType pass) async {
    final response = await locator<DialogService>().showConfirmationDialog(
        title: "Confirm",
        description: "Are you sure you want to remove this passes?");
    if (response!.confirmed) {
      await firebaseService.removePass(passType, pass.type, event.id!);
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

  void createPasses() async {
    final result = await _navigationService.navigateTo(Routes.createPassView,
        arguments: CreatePassViewArguments(event: event));
    setBusy(true);
    if (result != null && result) {
      event = await locator<FirebaseService>().getEvent(event.id!);
    }
    setBusy(false);
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
      await firebaseService.updateCrowd(event.id!, maleCount, femaleCount);
      _navigationService.back();

      notifyListeners();
    } catch (e) {
      await locator<DialogService>()
          .showDialog(title: "Invalid Values", description: "$e");
    }
  }

  refreshEvent() async {
    event = await firebaseService.getEvent(event.id!);
    notifyListeners();
  }

  removeCoupon(CouponModel coupon) async {
    final response = await locator<DialogService>().showConfirmationDialog(
        title: "Caution",
        description: "Are you sure you want delete this coupond?");
    if (response?.confirmed ?? false) {
      await firebaseService.removeCoupon(coupon, event.id!);
      refreshEvent();
    }
  }
}
