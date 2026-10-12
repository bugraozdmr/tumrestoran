import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:tumrestoran/utils/helper/type_safer.dart';

ItemDetailsModel itemDetailsModelFromJson(String str) =>
    ItemDetailsModel.fromJson(json.decode(str));

String itemDetailsModelToJson(ItemDetailsModel data) =>
    json.encode(data.toJson());

class ItemDetailsModel {
  final MainItem? data;

  ItemDetailsModel({this.data});

  factory ItemDetailsModel.fromJson(Map<String, dynamic> json) =>
      ItemDetailsModel(
        data: json["data"] == null ? null : MainItem.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"data": data?.toJson()};
}

class MainItem {
  final int? id;
  final String? name;
  final String? slug;
  final String? thumb;
  final String? caution;
  final String? description;
  final String? descriptionAlt;
  final int? restaurantId;
  final String? flatPrice;
  final double? convertPrice;
  final String? currencyPrice;
  final Tax? tax;
  final int? itemType;
  final Map<String, List<Variation>>? variations;
  final List<ItemAttributeElement>? itemAttributes;
  final List<Extra>? extras;
  final List<Addon>? addons;
  final String? discount;
  final String? discountType;
  final String? discountOption;
  final String? flatDiscountedPrice;
  final double? convertDiscountedPrice;
  final String? currencyDiscountedPrice;
  final String? maximumPurchaseQnty;

  MainItem({
    this.id,
    this.name,
    this.slug,
    this.thumb,
    this.caution,
    this.description,
    this.restaurantId,
    this.flatPrice,
    this.convertPrice,
    this.currencyPrice,
    this.tax,
    this.descriptionAlt,
    this.itemType,
    this.variations,
    this.itemAttributes,
    this.extras,
    this.addons,
    this.discount,
    this.discountOption,
    this.discountType,
    this.flatDiscountedPrice,
    this.convertDiscountedPrice,
    this.currencyDiscountedPrice,
    this.maximumPurchaseQnty,
  });

  factory MainItem.fromJson(Map<String, dynamic> json) => MainItem(
    id: safeParse(json["id"], 'id'),
    name: safeParse(json["name"], 'name'),
    slug: safeParse(json["slug"], 'slug'),
    thumb: safeParse(json["thumb"], 'thumb'),
    caution: safeParse(json["caution"], 'caution'),
    description: safeParse(json["description"], 'description'),
    descriptionAlt: safeParse(json["description_alt"], 'description_alt'),
    restaurantId: safeParse(json["restaurent_id"], 'restaurent_id'),
    flatPrice: safeParse(json["flat_price"], 'flat_price'),
    convertPrice: safeParse(json["convert_price"], 'convert_price'),
    currencyPrice: safeParse(json["currency_price"], 'currency_price'),
    tax: json["tax"] == null ? null : Tax.fromJson(json["tax"]),
    itemType: safeParse(json["item_type"], 'item_type'),
    variations: json["variations"] is Map
        ? (json["variations"] as Map).map(
            (k, v) => MapEntry<String, List<Variation>>(
              k,
              List<Variation>.from(v.map((x) => Variation.fromJson(x))),
            ),
          )
        : {},
    itemAttributes: json["item_attributes"] == null
        ? []
        : List<ItemAttributeElement>.from(
            json["item_attributes"]!.map(
              (x) => ItemAttributeElement.fromJson(x),
            ),
          ),
    extras: json["extras"] == null
        ? []
        : List<Extra>.from(json["extras"]!.map((x) => Extra.fromJson(x))),
    addons: json["addons"] == null
        ? []
        : List<Addon>.from(json["addons"]!.map((x) => Addon.fromJson(x))),

    discount: safeParse(json["discount"], 'discount'),
    discountOption: safeParse(json['discount_option'], 'discount_option'),
    discountType: safeParse(json["discount_type"], 'discount_type'),
    flatDiscountedPrice: safeParse(
      json["flat_discounted_price"],
      'flat_discounted_price',
    ),
    convertDiscountedPrice: safeParse(
      json["convert_discounted_price"],
      'convert_discounted_price',
    ),
    currencyDiscountedPrice: safeParse(
      json["currency_discounted_price"],
      'currency_discounted_price',
    ),
    maximumPurchaseQnty: safeParse(
      json["maximum_purchase_quantity"],
      'maximum_purchase_quantity',
    ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "thumb": thumb,
    "caution": caution,
    "description": description,
    "restaurant_id": restaurantId,
    "flat_price": flatPrice,
    "convert_price": convertPrice,
    "currency_price": currencyPrice,
    "tax": tax?.toJson(),
    "item_type": itemType,
    "variations": Map.from(variations!).map(
      (k, v) => MapEntry<String, dynamic>(
        k,
        List<dynamic>.from(v.map((x) => x.toJson())),
      ),
    ),
    "item_attributes": itemAttributes == null
        ? []
        : List<dynamic>.from(itemAttributes!.map((x) => x.toJson())),
    "extras": extras == null
        ? []
        : List<dynamic>.from(extras!.map((x) => x.toJson())),
    "addons": addons == null
        ? []
        : List<dynamic>.from(addons!.map((x) => x.toJson())),
  };
}

class Addon {
  final int? id;
  final int? restaurantId;
  final int? itemId;
  final int? itemAddonId;
  final String? itemName;
  final String? addonItemName;
  final String? addonItemPrice;
  final String? addonItemFlatPrice;
  final double? addonItemConvertPrice;
  final String? addonItemCurrencyPrice;
  final Tax? addonItemTax;
  final String? addonItemFlatDiscountedPrice;
  final String? addonItemCurrencyDiscountedPrice;
  final dynamic addonItemConvertDiscountedPrice;
  final String? addonItemDiscountType;
  final String? addonItemDiscount;
  final int? addonItemStatus;
  final AddonVariations? variations;
  final double? variationTotal;
  final String? variationTotalFlatPrice;
  final double? variationTotalConvertPrice;
  final String? variationTotalCurrencyPrice;
  final double? total;
  final String? totalFlatPrice;
  final double? totalConvertPrice;
  final String? totalCurrencyPrice;
  final List<VariationName>? variationNames;
  final String? thumb;
  final String? cover;
  final String? preview;
  final String? caution;
  final String? addonMaximumPurchaseQnty;

  Addon({
    this.id,
    this.restaurantId,
    this.itemId,
    this.itemAddonId,
    this.itemName,
    this.addonItemName,
    this.addonItemPrice,
    this.addonItemFlatPrice,
    this.addonItemConvertPrice,
    this.addonItemCurrencyPrice,
    this.addonItemTax,
    this.addonItemFlatDiscountedPrice,
    this.addonItemCurrencyDiscountedPrice,
    this.addonItemConvertDiscountedPrice,
    this.addonItemDiscountType,
    this.addonItemDiscount,
    this.addonItemStatus,
    this.variations,
    this.variationTotal,
    this.variationTotalFlatPrice,
    this.variationTotalConvertPrice,
    this.variationTotalCurrencyPrice,
    this.total,
    this.totalFlatPrice,
    this.totalConvertPrice,
    this.totalCurrencyPrice,
    this.variationNames,
    this.thumb,
    this.cover,
    this.preview,
    this.caution,
    this.addonMaximumPurchaseQnty,
  });

  factory Addon.fromJson(Map<String, dynamic> json) => Addon(
    id: safeParse(json["id"], "addon.id"),
    restaurantId: safeParse(json["restaurant_id"], "addon.restaurant_id"),
    itemId: safeParse(json["item_id"], "addon.item_id"),
    itemAddonId: safeParse(json["item_addon_id"], "item_addon_id"),
    itemName: safeParse(json["item_name"], "addon.item_name"),
    addonItemName: safeParse(json["addon_item_name"], "addon_item_name"),
    addonItemPrice: safeParse(json["addon_item_price"], "addon_item_price"),
    addonMaximumPurchaseQnty: safeParse(
      json['addon_item_maximum_purchase_quantity'],
      'addon_item_maximum_purchase_quantity',
    ),
    addonItemFlatPrice: safeParse(
      json["addon_item_flat_price"],
      "addon_item_flat_price",
    ),
    addonItemConvertPrice: safeParse(
      json["addon_item_convert_price"],
      "addon_item_convert_price",
    ),
    addonItemCurrencyPrice: safeParse(
      json["addon_item_currency_price"],
      "addon_item_currency_price",
    ),
    addonItemTax: json["addon_item_tax"] == null
        ? null
        : Tax.fromJson(json["addon_item_tax"]),
    addonItemFlatDiscountedPrice: safeParse(
      json["addon_item_flat_discounted_price"],
      "addon_item_flat_discounted_price",
    ),
    addonItemCurrencyDiscountedPrice: safeParse(
      json["addon_item_currency_discounted_price"],
      "addon_item_currency_discounted_price",
    ),
    addonItemConvertDiscountedPrice: safeParse(
      json["addon_item_convert_discounted_price"],
      "addon_item_convert_discounted_price",
    ),
    addonItemDiscountType: safeParse(
      json["addon_item_discount_type"],
      "addon_item_discount_type",
    ),
    addonItemDiscount: safeParse(
      json["addon_item_discount"],
      "addon_item_discount",
    ),
    addonItemStatus: safeParse(json["addon_item_status"], "addon_item_status"),
    variations: json["variations"] == null
        ? null
        : AddonVariations.fromJson(json["variations"]),
    variationTotal: safeParse(json["variation_total"], "variation_total"),
    variationTotalFlatPrice: safeParse(
      json["variation_total_flat_price"],
      "variation_total_flat_price",
    ),
    variationTotalConvertPrice: safeParse(
      json["variation_total_convert_price"],
      "variation_total_convert_price",
    ),
    variationTotalCurrencyPrice: safeParse(
      json["variation_total_currency_price"],
      "variation_total_currency_price",
    ),
    total: safeParse(json["total"], "variation.total"),
    totalFlatPrice: safeParse(
      json["total_flat_price"],
      "variation.total_flat_price",
    ),
    totalConvertPrice: safeParse(
      json["total_convert_price"],
      "variation.total_convert_price",
    ),
    totalCurrencyPrice: safeParse(
      json["total_currency_price"],
      "variation.total_currency_price",
    ),
    variationNames: json["variation_names"] == null
        ? []
        : List<VariationName>.from(
            json["variation_names"]!.map((x) => VariationName.fromJson(x)),
          ),
    thumb: safeParse(json["thumb"], "variation.thumb"),
    cover: safeParse(json["cover"], "variation.cover"),
    preview: safeParse(json["preview"], "variation.preview"),
    caution: safeParse(json["caution"], "variation.caution"),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "restaurant_id": restaurantId,
    "item_id": itemId,
    "item_addon_id": itemAddonId,
    "item_name": itemName,
    "addon_item_name": addonItemName,
    "addon_item_price": addonItemPrice,
    "addon_item_flat_price": addonItemFlatPrice,
    "addon_item_convert_price": addonItemConvertPrice,
    "addon_item_currency_price": addonItemCurrencyPrice,
    "addon_item_tax": addonItemTax?.toJson(),
    "addon_item_flat_discounted_price": addonItemFlatDiscountedPrice,
    "addon_item_currency_discounted_price": addonItemCurrencyDiscountedPrice,
    "addon_item_convert_discounted_price": addonItemConvertDiscountedPrice,
    "addon_item_discount_type": addonItemDiscountType,
    "addon_item_discount": addonItemDiscount,
    "addon_item_status": addonItemStatus,
    "variations": variations?.toJson(),
    "variation_total": variationTotal,
    "variation_total_flat_price": variationTotalFlatPrice,
    "variation_total_convert_price": variationTotalConvertPrice,
    "variation_total_currency_price": variationTotalCurrencyPrice,
    "total": total,
    "total_flat_price": totalFlatPrice,
    "total_convert_price": totalConvertPrice,
    "total_currency_price": totalCurrencyPrice,
    "variation_names": variationNames == null
        ? []
        : List<dynamic>.from(variationNames!.map((x) => x.toJson())),
    "thumb": thumb,
    "cover": cover,
    "preview": preview,
    "caution": caution,
  };
}

class AddonVariations {
  final int? the1;

  AddonVariations({this.the1});

  factory AddonVariations.fromJson(Map<String, dynamic> json) =>
      AddonVariations(the1: json["1"]);

  Map<String, dynamic> toJson() => {"1": the1};
}

class VariationName {
  final int? id;
  final String? name;
  final String? attributeName;

  VariationName({this.id, this.name, this.attributeName});

  factory VariationName.fromJson(Map<String, dynamic> json) => VariationName(
    id: safeParse(json["id"], "variationName.id"),
    name: safeParse(json["name"], "variationName.name"),
    attributeName: safeParse(json["attribute_name"], "attribute_name"),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "attribute_name": attributeName,
  };
}

class ItemAttributeElement {
  final int? id;
  final int? restaurantId;
  final String? name;
  final int? status;

  ItemAttributeElement({this.id, this.restaurantId, this.name, this.status});

  factory ItemAttributeElement.fromJson(Map<String, dynamic> json) =>
      ItemAttributeElement(
        id: json["id"],
        restaurantId: json["restaurant_id"],
        name: json["name"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "restaurant_id": restaurantId,
    "name": name,
    "status": status,
  };
}

class Variations {
  Variations();

  factory Variations.fromJson(Map<String, dynamic> json) => Variations();

  Map<String, dynamic> toJson() => {};
}

class Extra extends Equatable {
  final int? id;
  final int? restaurantId;
  final int? itemId;
  final String? name;
  final String? price;
  final String? currencyPrice;
  final String? flatPrice;
  final double? convertPrice;
  final int? status;
  final String? item;

  const Extra({
    this.id,
    this.restaurantId,
    this.itemId,
    this.name,
    this.price,
    this.currencyPrice,
    this.flatPrice,
    this.convertPrice,
    this.status,
    this.item,
  });

  factory Extra.fromJson(Map<String, dynamic> json) => Extra(
    id: safeParse(json["id"], 'extra.id'),
    restaurantId: safeParse(json["restaurant_id"], 'extra.restaurent_id'),
    itemId: safeParse(json["item_id"], 'extra.item_id'),
    name: safeParse(json["name"], 'extra.name'),
    price: safeParse(json["price"], 'extra.price'),
    currencyPrice: safeParse(json["currency_price"], 'extra.currency_price'),
    flatPrice: safeParse(json["flat_price"], 'extra.flat_price'),
    convertPrice: safeParse(json["convert_price"], 'extra.convert_price'),
    status: safeParse(json["status"], 'extra.status'),
    item: safeParse(json["item"], 'extra.item'),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "restaurant_id": restaurantId,
    "item_id": itemId,
    "name": name,
    "price": price,
    "currency_price": currencyPrice,
    "flat_price": flatPrice,
    "convert_price": convertPrice,
    "status": status,
    "item": item,
  };

  @override
  List<Object?> get props => [id, itemId, name, item];
}

class Tax {
  final int? id;
  final int? restaurantId;
  final String? name;
  final String? code;
  final String? taxRate;
  final String? taxCurrencyRate;
  final int? taxConvertRate;
  final int? type;
  final int? status;

  Tax({
    this.id,
    this.restaurantId,
    this.name,
    this.code,
    this.taxRate,
    this.taxCurrencyRate,
    this.taxConvertRate,
    this.type,
    this.status,
  });

  factory Tax.fromJson(Map<String, dynamic> json) => Tax(
    id: safeParse(json["id"], 'tax.id'),
    restaurantId: safeParse(json["restaurant_id"], 'tax.restaurant_id'),
    name: safeParse(json["name"], 'tax.name'),
    code: safeParse(json["code"], 'tax.code'),
    taxRate: safeParse(json["tax_rate"], 'tax.tax_rate'),
    taxCurrencyRate: safeParse(
      json["tax_rate_currency"],
      'tax.tax_rate_currency',
    ),
    taxConvertRate: safeParse(json["tax_convert_rate"], 'tax.tax_convert_rate'),
    type: safeParse(json["type"], 'tax.type'),
    status: safeParse(json["status"], 'tax.status'),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "restaurant_id": restaurantId,
    "name": name,
    "code": code,
    "tax_rate": taxRate,
    "tax_currency_rate": taxCurrencyRate,
    "tax_convert_rate": taxConvertRate,
    "type": type,
    "status": status,
  };
}

class Variation extends Equatable {
  final int? id;
  final int? restaurantId;
  final int? itemId;
  final int? itemAttributeId;
  final String? name;
  final String? price;
  final dynamic caution;
  final int? status;
  final dynamic creatorType;
  final dynamic creatorId;
  final dynamic editorType;
  final dynamic editorId;
  final dynamic deletedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final double? convertPrice;
  final String? currencyPrice;
  final String? flatPrice;
  final VariationItemAttribute? itemAttribute;

  const Variation({
    this.id,
    this.restaurantId,
    this.itemId,
    this.itemAttributeId,
    this.name,
    this.price,
    this.caution,
    this.status,
    this.creatorType,
    this.creatorId,
    this.editorType,
    this.editorId,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.convertPrice,
    this.currencyPrice,
    this.flatPrice,
    this.itemAttribute,
  });

  factory Variation.fromJson(Map<String, dynamic> json) => Variation(
    id: safeParse(json["id"], "variation.id"),
    restaurantId: safeParse(json["restaurant_id"], "variation.restaurant_id"),
    itemId: safeParse(json["item_id"], "variation.item_id"),
    itemAttributeId: safeParse(json["item_attribute_id"], "item_attribute_id"),
    name: safeParse(json["name"], "variation.name"),
    price: safeParse(json["price"], "variation.price"),
    caution: safeParse(json["caution"], "variation.caution"),
    status: safeParse(json["status"], "variation.status"),
    creatorType: safeParse(json["creator_type"], "variation.creator_type"),
    creatorId: safeParse(json["creator_id"], "variation.creator_id"),
    editorType: safeParse(json["editor_type"], "variation.editor_type"),
    editorId: safeParse(json["editor_id"], "variation.editor_id"),
    deletedAt: json["deleted_at"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    convertPrice: safeParse(json["convert_price"], "variation.convert_price"),
    currencyPrice: safeParse(
      json["currency_price"],
      "variation.currency_price",
    ),
    flatPrice: safeParse(json["flat_price"], "variation.flat_price"),
    itemAttribute: json["item_attribute"] == null
        ? null
        : VariationItemAttribute.fromJson(json["item_attribute"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "restaurant_id": restaurantId,
    "item_id": itemId,
    "item_attribute_id": itemAttributeId,
    "name": name,
    "price": price,
    "caution": caution,
    "status": status,
    "creator_type": creatorType,
    "creator_id": creatorId,
    "editor_type": editorType,
    "editor_id": editorId,
    "deleted_at": deletedAt,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "convert_price": convertPrice,
    "currency_price": currencyPrice,
    "flat_price": flatPrice,
    "item_attribute": itemAttribute?.toJson(),
  };

  @override
  List<Object?> get props => [itemAttributeId, id];
}

class VariationItemAttribute {
  final int? id;
  final int? restaurantId;
  final String? name;
  final int? status;
  final dynamic creatorType;
  final dynamic creatorId;
  final dynamic editorType;
  final dynamic editorId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  VariationItemAttribute({
    this.id,
    this.restaurantId,
    this.name,
    this.status,
    this.creatorType,
    this.creatorId,
    this.editorType,
    this.editorId,
    this.createdAt,
    this.updatedAt,
  });

  factory VariationItemAttribute.fromJson(Map<String, dynamic> json) =>
      VariationItemAttribute(
        id: safeParse(json["id"], "variationItemAttribute.id"),
        restaurantId: safeParse(
          json["restaurant_id"],
          "variationItemAttribute.restaurant_id",
        ),
        name: safeParse(json["name"], "variationItemAttribute.name"),
        status: safeParse(json["status"], "variationItemAttribute.status"),
        creatorType: json["creator_type"],
        creatorId: json["creator_id"],
        editorType: json["editor_type"],
        editorId: json["editor_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "restaurant_id": restaurantId,
    "name": name,
    "status": status,
    "creator_type": creatorType,
    "creator_id": creatorId,
    "editor_type": editorType,
    "editor_id": editorId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
