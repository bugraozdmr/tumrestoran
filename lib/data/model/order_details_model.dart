import 'dart:convert';

OrderDetailsModel orderDetailsModelFromJson(String str) =>
    OrderDetailsModel.fromJson(json.decode(str));

class OrderDetailsModel {
  final Data? data;

  OrderDetailsModel({this.data});

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) =>
      OrderDetailsModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  final int? id;
  final String? orderSerialNo;
  final dynamic token;
  final int? discount;
  final int? serviceFee;
  final int? riderTip;
  final num? deliveryFee;
  final double? totalTax;
  final String? subtotalCurrencyPrice;
  final String? subtotalWithoutTaxCurrencyPrice;
  final String? discountCurrencyPrice;
  final String? deliveryFeeCurrencyPrice;
  final String? riderTipCurrencyPrice;
  final String? serviceFeeCurrencyPrice;
  final String? totalCurrencyPrice;
  final String? totalTaxCurrencyPrice;
  final int? orderType;
  final String? orderDatetime;
  final String? orderDate;
  final String? orderTime;
  final String? deliveryDate;
  final String? deliveryTime;
  final int? paymentMethod;
  final int? paymentStatus;
  final int? isAdvanceOrder;
  final int? preparationTime;
  final int? status;
  final String? statusName;
  final dynamic reason;
  final User? user;
  final OrderAddress? orderAddress;
  final Restaurant? restaurant;
  final DeliveryBoy? deliveryBoy;
  final dynamic coupon;
  final Transaction? transaction;
  final List<OrderItem>? orderItems;
  final bool? restaurantReviewStatus;
  final bool? deliveryManReviewStatus;

  Data({
    this.id,
    this.orderSerialNo,
    this.token,
    this.discount,
    this.serviceFee,
    this.riderTip,
    this.deliveryFee,
    this.totalTax,
    this.subtotalCurrencyPrice,
    this.subtotalWithoutTaxCurrencyPrice,
    this.discountCurrencyPrice,
    this.deliveryFeeCurrencyPrice,
    this.riderTipCurrencyPrice,
    this.serviceFeeCurrencyPrice,
    this.totalCurrencyPrice,
    this.totalTaxCurrencyPrice,
    this.orderType,
    this.orderDatetime,
    this.orderDate,
    this.orderTime,
    this.deliveryDate,
    this.deliveryTime,
    this.paymentMethod,
    this.paymentStatus,
    this.isAdvanceOrder,
    this.preparationTime,
    this.status,
    this.statusName,
    this.reason,
    this.user,
    this.orderAddress,
    this.restaurant,
    this.deliveryBoy,
    this.coupon,
    this.transaction,
    this.orderItems,
    this.deliveryManReviewStatus,
    this.restaurantReviewStatus,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    orderSerialNo: json["order_serial_no"],
    token: json["token"],
    discount: json["discount"],
    serviceFee: json["service_fee"],
    riderTip: json["rider_tip"],
    deliveryFee: json["delivery_fee"],
    totalTax: json["total_tax"]?.toDouble(),
    subtotalCurrencyPrice: json["subtotal_currency_price"],
    subtotalWithoutTaxCurrencyPrice:
        json["subtotal_without_tax_currency_price"],
    discountCurrencyPrice: json["discount_currency_price"],
    deliveryFeeCurrencyPrice: json["delivery_fee_currency_price"],
    riderTipCurrencyPrice: json["rider_tip_currency_price"],
    serviceFeeCurrencyPrice: json["service_fee_currency_price"],
    totalCurrencyPrice: json["total_currency_price"],
    totalTaxCurrencyPrice: json["total_tax_currency_price"],
    orderType: json["order_type"],
    orderDatetime: json["order_datetime"],
    orderDate: json["order_date"],
    orderTime: json["order_time"],
    deliveryDate: json["delivery_date"],
    deliveryTime: json["delivery_time"],
    paymentMethod: json["payment_method"],
    paymentStatus: json["payment_status"],
    isAdvanceOrder: json["is_advance_order"],
    preparationTime: json["preparation_time"],
    status: json["status"],
    statusName: json["status_name"],
    restaurantReviewStatus: json['restaurant_review_status'] ?? false,
    deliveryManReviewStatus: json['delivery_boy_review_status'],
    reason: json["reason"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    orderAddress: json["order_address"] == null
        ? null
        : OrderAddress.fromJson(json["order_address"]),
    restaurant: json["restaurant"] == null
        ? null
        : Restaurant.fromJson(json["restaurant"]),
    deliveryBoy: json["delivery_boy"] == null
        ? null
        : DeliveryBoy.fromJson(json["delivery_boy"]),
    coupon: json["coupon"],
    transaction: json["transaction"] == null
        ? null
        : Transaction.fromJson(json["transaction"]),
    orderItems: json["order_items"] == null
        ? []
        : List<OrderItem>.from(
            json["order_items"]!.map((x) => OrderItem.fromJson(x)),
          ),
  );
}

class User {
  final int? id;
  final int? restaurantId;
  final int? hubId;
  final String? name;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? email;
  final String? username;
  final String? balance;
  final String? currencyBalance;
  final String? image;
  final int? roleId;
  final String? countryCode;
  final int? order;
  final String? createDate;
  final String? updateDate;

  User({
    this.id,
    this.restaurantId,
    this.hubId,
    this.name,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.username,
    this.balance,
    this.currencyBalance,
    this.image,
    this.roleId,
    this.countryCode,
    this.order,
    this.createDate,
    this.updateDate,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    restaurantId: json["restaurant_id"],
    hubId: json["hub_id"],
    name: json["name"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    phone: json["phone"],
    email: json["email"],
    username: json["username"],
    balance: json["balance"],
    currencyBalance: json["currency_balance"],
    image: json["image"],
    roleId: json["role_id"],
    countryCode: json["country_code"],
    order: json["order"],
    createDate: json["create_date"],
    updateDate: json["update_date"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "restaurant_id": restaurantId,
    "hub_id": hubId,
    "name": name,
    "first_name": firstName,
    "last_name": lastName,
    "phone": phone,
    "email": email,
    "username": username,
    "balance": balance,
    "currency_balance": currencyBalance,
    "image": image,
    "role_id": roleId,
    "country_code": countryCode,
    "order": order,
    "create_date": createDate,
    "update_date": updateDate,
  };
}

class DeliveryBoy {
  final int? id;
  final int? restaurantId;
  final int? hubId;
  final String? name;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? email;
  final String? username;
  final String? balance;
  final String? currencyBalance;
  final String? image;
  final int? roleId;
  final String? countryCode;
  final int? order;
  final String? createDate;
  final String? updateDate;

  DeliveryBoy({
    this.id,
    this.restaurantId,
    this.hubId,
    this.name,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.username,
    this.balance,
    this.currencyBalance,
    this.image,
    this.roleId,
    this.countryCode,
    this.order,
    this.createDate,
    this.updateDate,
  });

  factory DeliveryBoy.fromJson(Map<String, dynamic> json) => DeliveryBoy(
    id: json["id"],
    restaurantId: json["restaurant_id"],
    hubId: json["hub_id"],
    name: json["name"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    phone: json["phone"],
    email: json["email"],
    username: json["username"],
    balance: json["balance"],
    currencyBalance: json["currency_balance"],
    image: json["image"],
    roleId: json["role_id"],
    countryCode: json["country_code"],
    order: json["order"],
    createDate: json["create_date"],
    updateDate: json["update_date"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "restaurant_id": restaurantId,
    "hub_id": hubId,
    "name": name,
    "first_name": firstName,
    "last_name": lastName,
    "phone": phone,
    "email": email,
    "username": username,
    "balance": balance,
    "currency_balance": currencyBalance,
    "image": image,
    "role_id": roleId,
    "country_code": countryCode,
    "order": order,
    "create_date": createDate,
    "update_date": updateDate,
  };
}

class OrderAddress {
  final int? id;
  final int? userId;
  final String? label;
  final String? address;
  final String? apartment;
  final String? latitude;
  final String? longitude;

  OrderAddress({
    this.id,
    this.userId,
    this.label,
    this.address,
    this.apartment,
    this.latitude,
    this.longitude,
  });

  factory OrderAddress.fromJson(Map<String, dynamic> json) => OrderAddress(
    id: json["id"],
    userId: json["user_id"],
    label: json["label"],
    address: json["address"],
    apartment: json["apartment"],
    latitude: json["latitude"],
    longitude: json["longitude"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "label": label,
    "address": address,
    "apartment": apartment,
    "latitude": latitude,
    "longitude": longitude,
  };
}

class OrderItem {
  final int? id;
  final int? orderId;
  final int? restaurantId;
  final int? itemId;
  final String? itemName;
  final String? itemImage;
  final int? quantity;
  final String? discount;
  final String? price;
  final List<ItemVariation>? itemVariations;
  final List<ItemExtra>? itemExtras;
  final String? itemVariationCurrencyTotal;
  final String? itemExtraCurrencyTotal;
  final double? totalConvertPrice;
  final String? totalCurrencyPrice;
  final String? instruction;
  final String? taxType;
  final String? taxRate;
  final String? taxCurrencyRate;
  final String? taxName;
  final String? taxCurrencyAmount;
  final String? totalWithoutTaxCurrencyPrice;

  OrderItem({
    this.id,
    this.orderId,
    this.restaurantId,
    this.itemId,
    this.itemName,
    this.itemImage,
    this.quantity,
    this.discount,
    this.price,
    this.itemVariations,
    this.itemExtras,
    this.itemVariationCurrencyTotal,
    this.itemExtraCurrencyTotal,
    this.totalConvertPrice,
    this.totalCurrencyPrice,
    this.instruction,
    this.taxType,
    this.taxRate,
    this.taxCurrencyRate,
    this.taxName,
    this.taxCurrencyAmount,
    this.totalWithoutTaxCurrencyPrice,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    id: json["id"],
    orderId: json["order_id"],
    restaurantId: json["restaurant_id "],
    itemId: json["item_id"],
    itemName: json["item_name"],
    itemImage: json["item_image"],
    quantity: json["quantity"],
    discount: json["discount"],
    price: json["price"],
    itemVariations: json["item_variations"] == null
        ? []
        : List<ItemVariation>.from(
            json["item_variations"]!.map((x) => ItemVariation.fromJson(x)),
          ),
    itemExtras: json["item_extras"] == null
        ? []
        : List<ItemExtra>.from(
            json["item_extras"]!.map((x) => ItemExtra.fromJson(x)),
          ),
    itemVariationCurrencyTotal: json["item_variation_currency_total"],
    itemExtraCurrencyTotal: json["item_extra_currency_total"],
    totalConvertPrice: json["total_convert_price"]?.toDouble(),
    totalCurrencyPrice: json["total_currency_price"],
    instruction: json["instruction"],
    taxType: json["tax_type"],
    taxRate: json["tax_rate"],
    taxCurrencyRate: json["tax_currency_rate"],
    taxName: json["tax_name"],
    taxCurrencyAmount: json["tax_currency_amount"],
    totalWithoutTaxCurrencyPrice: json["total_without_tax_currency_price"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_id": orderId,
    "restaurant_id ": restaurantId,
    "item_id": itemId,
    "item_name": itemName,
    "item_image": itemImage,
    "quantity": quantity,
    "discount": discount,
    "price": price,
    "item_variations": itemVariations == null
        ? []
        : List<dynamic>.from(itemVariations!.map((x) => x.toJson())),
    "item_extras": itemExtras == null
        ? []
        : List<dynamic>.from(itemExtras!.map((x) => x.toJson())),
    "item_variation_currency_total": itemVariationCurrencyTotal,
    "item_extra_currency_total": itemExtraCurrencyTotal,
    "total_convert_price": totalConvertPrice,
    "total_currency_price": totalCurrencyPrice,
    "instruction": instruction,
    "tax_type": taxType,
    "tax_rate": taxRate,
    "tax_currency_rate": taxCurrencyRate,
    "tax_name": taxName,
    "tax_currency_amount": taxCurrencyAmount,
    "total_without_tax_currency_price": totalWithoutTaxCurrencyPrice,
  };
}

class ItemExtra {
  final int? id;
  final int? itemId;
  final String? name;

  ItemExtra({this.id, this.itemId, this.name});

  factory ItemExtra.fromJson(Map<String, dynamic> json) =>
      ItemExtra(id: json["id"], itemId: json["item_id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "item_id": itemId, "name": name};
}

class ItemVariation {
  final int? id;
  final int? itemId;
  final dynamic itemAttributeId;
  final String? attributeName;
  final String? name;

  ItemVariation({
    this.id,
    this.itemId,
    this.itemAttributeId,
    this.attributeName,
    this.name,
  });

  factory ItemVariation.fromJson(Map<String, dynamic> json) => ItemVariation(
    id: json["id"],
    itemId: json["item_id"],
    itemAttributeId: json["item_attribute_id"],
    attributeName: json["attribute_name"] ?? "",
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "item_id": itemId,
    "item_attribute_id": itemAttributeId,
    "variation_name": attributeName,
    "name": name,
  };
}

class Restaurant {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? latitude;
  final String? longitude;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? address;
  final int? status;
  final int? currentStatus;
  final int? apply;
  final String? image;
  final String? logo;
  final List<CuisineId>? cuisineId;
  final String? cuisine;

  Restaurant({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.latitude,
    this.longitude,
    this.city,
    this.logo,
    this.state,
    this.zipCode,
    this.address,
    this.status,
    this.currentStatus,
    this.apply,
    this.image,
    this.cuisineId,
    this.cuisine,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    city: json["city"],
    logo: json["logo"],
    state: json["state"],
    zipCode: json["zip_code"],
    address: json["address"],
    status: json["status"],
    currentStatus: json["current_status"],
    apply: json["apply"],
    image: json["image"],
    cuisineId: json["cuisine_id"] == null
        ? []
        : List<CuisineId>.from(
            json["cuisine_id"]!.map((x) => CuisineId.fromJson(x)),
          ),
    cuisine: json["cuisine"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "latitude": latitude,
    "longitude": longitude,
    "city": city,
    "state": state,
    "zip_code": zipCode,
    "address": address,
    "status": status,
    "current_status": currentStatus,
    "apply": apply,
    "image": image,
    "cuisine_id": cuisineId == null
        ? []
        : List<dynamic>.from(cuisineId!.map((x) => x.toJson())),
    "cuisine": cuisine,
  };
}

class CuisineId {
  final int? id;
  final int? restaurantId;
  final int? cuisineId;

  CuisineId({this.id, this.restaurantId, this.cuisineId});

  factory CuisineId.fromJson(Map<String, dynamic> json) => CuisineId(
    id: json["id"],
    restaurantId: json["restaurant_id"],
    cuisineId: json["cuisine_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "restaurant_id": restaurantId,
    "cuisine_id": cuisineId,
  };
}

class Transaction {
  final int? id;
  final int? orderId;
  final String? orderSerialNo;
  final String? transactionNo;
  final String? amount;
  final String? paymentMethod;
  final String? type;
  final String? sign;
  final String? date;

  Transaction({
    this.id,
    this.orderId,
    this.orderSerialNo,
    this.transactionNo,
    this.amount,
    this.paymentMethod,
    this.type,
    this.sign,
    this.date,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json["id"],
    orderId: json["order_id"],
    orderSerialNo: json["order_serial_no"],
    transactionNo: json["transaction_no"],
    amount: json["amount"],
    paymentMethod: json["payment_method"],
    type: json["type"],
    sign: json["sign"],
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_id": orderId,
    "order_serial_no": orderSerialNo,
    "transaction_no": transactionNo,
    "amount": amount,
    "payment_method": paymentMethod,
    "type": type,
    "sign": sign,
    "date": date,
  };
}
