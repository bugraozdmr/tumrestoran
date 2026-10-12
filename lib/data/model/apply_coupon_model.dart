import 'dart:convert';

ApplyCouponModel applyCouponModelFromJson(String str) =>
    ApplyCouponModel.fromJson(json.decode(str));

String applyCouponModelToJson(ApplyCouponModel data) =>
    json.encode(data.toJson());

class ApplyCouponModel {
  final Data? data;

  ApplyCouponModel({this.data});

  factory ApplyCouponModel.fromJson(Map<String, dynamic> json) =>
      ApplyCouponModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"data": data?.toJson()};
}

class Data {
  final int? id;
  final int? restaurantId;
  final String? name;
  final String? description;
  final String? code;
  final int? type;
  final String? flatDiscount;
  final int? convertDiscount;
  final String? currencyDiscount;
  final int? discountType;
  final String? minimumOrder;
  final String? minimumOrderCurrencyAmount;
  final String? discountAlt;
  final String? maximumDiscount;

  Data({
    this.id,
    this.restaurantId,
    this.name,
    this.description,
    this.code,
    this.flatDiscount,
    this.type,
    this.convertDiscount,
    this.currencyDiscount,
    this.discountType,
    this.minimumOrder,
    this.minimumOrderCurrencyAmount,
    this.discountAlt,
    this.maximumDiscount,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    restaurantId: json["restaurant_id"],
    name: json["name"],
    description: json["description"],
    code: json["code"],
    type: json['type'],
    flatDiscount: json["flat_discount"],
    convertDiscount: json["convert_discount"],
    currencyDiscount: json["currency_discount"],
    discountType: json["discount_type"],
    minimumOrder: json["minimum_order"],
    minimumOrderCurrencyAmount: json["minimum_order_currency_amount"],
    discountAlt: json['discount_alt'],
    maximumDiscount: json['maximum_discount'],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "restaurant_id": restaurantId,
    "name": name,
    "description": description,
    "code": code,
    "flat_discount": flatDiscount,
    "convert_discount": convertDiscount,
    "currency_discount": currencyDiscount,
    "discount_type": discountType,
    "minimum_order": minimumOrder,
    "minimum_order_currency_amount": minimumOrderCurrencyAmount,
  };
}
