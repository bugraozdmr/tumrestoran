import 'dart:convert';

CouponModel couponModelFromJson(String str) =>
    CouponModel.fromJson(json.decode(str));

String couponModelToJson(CouponModel data) => json.encode(data.toJson());

class CouponModel {
  final List<Coupon>? data;

  CouponModel({this.data});

  factory CouponModel.fromJson(Map<String, dynamic> json) => CouponModel(
    data: json["data"] == null
        ? []
        : List<Coupon>.from(json["data"]!.map((x) => Coupon.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Coupon {
  final int? id;
  final int? restaurantId;
  final String? name;
  final String? description;
  final String? code;
  final int? type;
  final String? flatDiscount;
  final String? discountAlt;
  final int? convertDiscount;
  final String? currencyDiscount;
  final int? discountType;
  final String? minimumOrder;
  final String? minimumOrderCurrencyAmount;

  Coupon({
    this.id,
    this.restaurantId,
    this.name,
    this.description,
    this.code,
    this.type,
    this.flatDiscount,
    this.discountAlt,
    this.convertDiscount,
    this.currencyDiscount,
    this.discountType,
    this.minimumOrder,
    this.minimumOrderCurrencyAmount,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
    id: json["id"],
    restaurantId: json["restaurant_id"],
    name: json["name"],
    description: json["description"],
    code: json["code"],
    flatDiscount: json["flat_discount"],
    type: json['type'],
    discountAlt: json["discount_alt"],
    convertDiscount: json["convert_discount"],
    currencyDiscount: json["currency_discount"],
    discountType: json["discount_type"],
    minimumOrder: json["minimum_order"],
    minimumOrderCurrencyAmount: json["minimum_order_currency_amount"],
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
