import 'dart:convert';

import 'package:foodnanny/utils/helper/type_safer.dart';

ShowCouponModel showCouponModelFromJson(String str) =>
    ShowCouponModel.fromJson(json.decode(str));

String showCouponModelToJson(ShowCouponModel data) =>
    json.encode(data.toJson());

class ShowCouponModel {
  final Data? data;

  ShowCouponModel({this.data});

  factory ShowCouponModel.fromJson(Map<String, dynamic> json) =>
      ShowCouponModel(
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
  final String? discountAlt;
  final int? discountType;
  final int? type;
  final String? convertStartDate;
  final String? convertEndDate;
  final String? minimumOrder;
  final String? maximumDiscount;
  final String? minimumOrderCurrencyAmount;
  final String? maximumDiscountCurrencyAmount;

  Data({
    this.id,
    this.restaurantId,
    this.name,
    this.description,
    this.code,
    this.discountAlt,
    this.discountType,
    this.type,
    this.convertStartDate,
    this.convertEndDate,
    this.minimumOrder,
    this.maximumDiscount,
    this.minimumOrderCurrencyAmount,
    this.maximumDiscountCurrencyAmount,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: safeParse(json["id"], 'id'),
    restaurantId: safeParse(json["restaurant_id"], "restaurant_id"),
    name: safeParse(json["name"], "name"),
    description: safeParse(json["description"], "description"),
    code: safeParse(json["code"], "code"),
    discountAlt: json["discount_alt"],
    discountType: json["discount_type"],
    type: safeParse(json["type"], "type"),
    convertStartDate: json["convert_start_date"],
    convertEndDate: json["convert_end_date"],
    minimumOrder: safeParse(json["minimum_order"], "minimum_order"),
    maximumDiscount: safeParse(json["maximum_discount"], "maximum_discount"),
    minimumOrderCurrencyAmount: json["minimum_order_currency_amount"],
    maximumDiscountCurrencyAmount: json["maximum_discount_currency_amount"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "restaurant_id": restaurantId,
    "name": name,
    "description": description,
    "code": code,
    "discount_alt": discountAlt,
    "discount_type": discountType,
    "type": type,
    "convert_start_date": convertStartDate,
    "convert_end_date": convertEndDate,
    "minimum_order": minimumOrder,
    "maximum_discount": maximumDiscount,
    "minimum_order_currency_amount": minimumOrderCurrencyAmount,
    "maximum_discount_currency_amount": maximumDiscountCurrencyAmount,
  };
}
