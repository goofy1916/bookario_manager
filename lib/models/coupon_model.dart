class CouponModel {
  String? id;
  double? percentOff;
  double maxAmount;
  double minAmountRequired;
  int maxCoupons;
  int remainingCoupons;

  CouponModel({
    this.id,
    this.percentOff,
    required this.maxAmount,
    required this.minAmountRequired,
    required this.maxCoupons,
    required this.remainingCoupons,
  });

  CouponModel.fromJson(Map<String, dynamic> json, this.id)
      : percentOff = json['percentOff'],
        maxAmount = json['maxAmount'],
        minAmountRequired = json['minAmountRequired'],
        maxCoupons = json['maxCoupons'],
        remainingCoupons = json['remainingCoupons'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['percentOff'] = percentOff;
    data['maxAmount'] = maxAmount;
    data['minAmountRequired'] = minAmountRequired;
    data['maxCoupons'] = maxCoupons;
    data['remainingCoupons'] = remainingCoupons;
    data.removeWhere((key, value) => value == null);
    return data;
  }
}
