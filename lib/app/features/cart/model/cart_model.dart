// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:get/get.dart';

import 'package:foodnanny/data/model/item_details_model.dart';

// ignore: must_be_immutable
class CartModel extends Equatable {
  final MainItem product;
  final RxInt quantity;
  int? restaurantId;
  double? itemPrice;
  int? variationId;
  List<int>? extrasId;
  String? extrasText;
  String? instructionText;
  List<Variation>? variationObject;
  List<Extra>? extrasObject;
  dynamic addonObject;
  double? itemPriceForTax;
  double? taxRate;
  double? variationTotalPrice;
  double? extrasTotalPrice;
  double? addonTotalPrice;
  double? subtotal;
  double? total;

  CartModel({
    required this.product,
    int quantity = 1,
    this.itemPrice,
    this.restaurantId,

    this.variationId,
    this.extrasId,
    this.taxRate,
    this.extrasText,
    this.instructionText,
    this.variationObject,
    this.extrasObject,
    this.addonObject,
    this.variationTotalPrice,
    this.itemPriceForTax,
    this.extrasTotalPrice,
    this.addonTotalPrice,
    this.subtotal,
    this.total,
  }) : quantity = quantity.obs;

  double getItemTotal() {
    final itemTotal = 0.0.obs;
    itemTotal.value = quantity.value * double.parse(itemPrice.toString());
    return itemTotal.value;
  }

  @override
  List<Object?> get props => [
    product,
    restaurantId,
    variationId,
    extrasId,
    extrasText,
    variationObject,
    extrasObject,
    addonObject,
  ];
}

class AddonCartModel {
  final Addon addon;
  final RxInt quantity;
  final double addonCurrentPrice;

  AddonCartModel({
    required this.addon,
    int quantity = 1,
    required this.addonCurrentPrice,
  }) : quantity = quantity.obs;

  @override
  String toString() =>
      'AddonCartModel(addon: $addon, quantity: $quantity, addonCurrentPrice: $addonCurrentPrice)';
}
