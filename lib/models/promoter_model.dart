class PromoterModel {
  final String name;
  final String promoterId;
  final String userId;

  PromoterModel(this.name, this.promoterId, this.userId);

  PromoterModel.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        promoterId = json['promoterId'] as String,
        userId = json['userId'] as String;
}
