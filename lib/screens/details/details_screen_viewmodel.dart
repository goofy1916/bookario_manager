import 'dart:developer';

import 'package:bookario_manager/app.locator.dart';
import 'package:bookario_manager/models/coupon_model.dart';
import 'package:bookario_manager/models/event_model.dart';
import 'package:bookario_manager/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class DetailsScreenViewModel extends BaseViewModel {
  FirebaseService firebaseService = locator<FirebaseService>();

  bool isCouponPercent = false;

  final percentOff = TextEditingController();
  final maxCoupons = TextEditingController();
  final maxDiscount = TextEditingController();
  final minAmounRequired = TextEditingController();
  final maxDiscountAmount = TextEditingController();

  late final EventModel event;

  List<CouponModel> couponsForEvent = [];

  bool addNewCoupon = false;
  String couponType = "Percent";

  TextStyle textStyle = const TextStyle(color: Colors.white, fontSize: 14);

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
    await getCouponsForEvevnt();
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

  updateEvent(EventModel currentEvent) async {
    event = currentEvent;
    setBusyForObject("coupons", true);
    await getCouponsForEvevnt();
    setBusyForObject("coupons", false);
  }

  getCouponsForEvevnt() async {
    couponsForEvent =
        await firebaseService.getCouponsForEvent(eventId: event.id);
  }
}
