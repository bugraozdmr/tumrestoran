import 'dart:convert';

ActiveOrderHistoryModel activeOrderHistoryModelFromJson(String str) =>
    ActiveOrderHistoryModel.fromJson(json.decode(str));

String activeOrderHistoryModelToJson(ActiveOrderHistoryModel data) =>
    json.encode(data.toJson());

class ActiveOrderHistoryModel {
  final List<ActiveOrderHistory>? data;

  ActiveOrderHistoryModel({this.data});

  factory ActiveOrderHistoryModel.fromJson(Map<String, dynamic> json) =>
      ActiveOrderHistoryModel(
        data: json["data"] == null
            ? []
            : List<ActiveOrderHistory>.from(
                json["data"]!.map((x) => ActiveOrderHistory.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class ActiveOrderHistory {
  final int? id;
  final String? orderSerialNo;
  final int? userId;
  final int? restaurantId;
  final String? restaurantName;
  final int? orderItems;
  final String? totalCurrencyPrice;
  final String? totalTaxCurrencyPrice;
  final String? totalAmountPrice;
  final String? discountCurrencyPrice;
  final String? deliveryChargeCurrencyPrice;
  final int? paymentMethod;
  final int? paymentStatus;
  final int? preparationTime;
  final int? orderType;
  final String? orderDatetime;
  final int? status;
  final int? isAdvanceOrder;
  final String? statusName;
  final Customer? customer;
  final Transaction? transaction;

  ActiveOrderHistory({
    this.id,
    this.orderSerialNo,
    this.userId,
    this.restaurantId,
    this.restaurantName,
    this.orderItems,
    this.totalCurrencyPrice,
    this.totalTaxCurrencyPrice,
    this.totalAmountPrice,
    this.discountCurrencyPrice,
    this.deliveryChargeCurrencyPrice,
    this.paymentMethod,
    this.paymentStatus,
    this.preparationTime,
    this.orderType,
    this.orderDatetime,
    this.status,
    this.isAdvanceOrder,
    this.statusName,
    this.customer,
    this.transaction,
  });

  factory ActiveOrderHistory.fromJson(Map<String, dynamic> json) =>
      ActiveOrderHistory(
        id: json["id"],
        orderSerialNo: json["order_serial_no"],
        userId: json["user_id"],
        restaurantId: json["restaurant_id"],
        restaurantName: json["restaurant_name"],
        orderItems: json["order_items"],
        totalCurrencyPrice: json["total_currency_price"],
        totalTaxCurrencyPrice: json["total_tax_currency_price"],
        totalAmountPrice: json["total_amount_price"],
        discountCurrencyPrice: json["discount_currency_price"],
        deliveryChargeCurrencyPrice: json["delivery_charge_currency_price"],
        paymentMethod: json["payment_method"],
        paymentStatus: json["payment_status"],
        preparationTime: json["preparation_time"],
        orderType: json["order_type"],
        orderDatetime: json["order_datetime"],
        status: json["status"],
        isAdvanceOrder: json["is_advance_order"],
        statusName: json["status_name"],
        customer: json["customer"] == null
            ? null
            : Customer.fromJson(json["customer"]),
        transaction: json["transaction"] == null
            ? null
            : Transaction.fromJson(json["transaction"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_serial_no": orderSerialNo,
    "user_id": userId,
    "restaurant_id": restaurantId,
    "restaurant_name": restaurantName,
    "order_items": orderItems,
    "total_currency_price": totalCurrencyPrice,
    "total_tax_currency_price": totalTaxCurrencyPrice,
    "total_amount_price": totalAmountPrice,
    "discount_currency_price": discountCurrencyPrice,
    "delivery_charge_currency_price": deliveryChargeCurrencyPrice,
    "payment_method": paymentMethod,
    "payment_status": paymentStatus,
    "preparation_time": preparationTime,
    "order_type": orderType,
    "order_datetime": orderDatetime,
    "status": status,
    "is_advance_order": isAdvanceOrder,
    "status_name": statusName,
    "customer": customer?.toJson(),
    "transaction": transaction?.toJson(),
  };
}

class Customer {
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

  Customer({
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

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
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
