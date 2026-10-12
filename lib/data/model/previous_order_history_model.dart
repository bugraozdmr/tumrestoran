import 'dart:convert';

PreviousOrderHistoryModel previousOrderHistoryModelFromJson(String str) =>
    PreviousOrderHistoryModel.fromJson(json.decode(str));

String previousOrderHistoryModelToJson(PreviousOrderHistoryModel data) =>
    json.encode(data.toJson());

class PreviousOrderHistoryModel {
  final List<PreviousOrderHistory>? data;
  final Links? links;
  final Meta? meta;

  PreviousOrderHistoryModel({this.data, this.links, this.meta});

  factory PreviousOrderHistoryModel.fromJson(Map<String, dynamic> json) =>
      PreviousOrderHistoryModel(
        data: json["data"] == null
            ? []
            : List<PreviousOrderHistory>.from(
                json["data"]!.map((x) => PreviousOrderHistory.fromJson(x)),
              ),
        links: json["links"] == null ? null : Links.fromJson(json["links"]),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
    "links": links?.toJson(),
    "meta": meta?.toJson(),
  };
}

class PreviousOrderHistory {
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

  PreviousOrderHistory({
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

  factory PreviousOrderHistory.fromJson(Map<String, dynamic> json) =>
      PreviousOrderHistory(
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

class Links {
  final String? first;
  final String? last;
  final dynamic prev;
  final dynamic next;

  Links({this.first, this.last, this.prev, this.next});

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    first: json["first"],
    last: json["last"],
    prev: json["prev"],
    next: json["next"],
  );

  Map<String, dynamic> toJson() => {
    "first": first,
    "last": last,
    "prev": prev,
    "next": next,
  };
}

class Meta {
  final int? currentPage;
  final int? from;
  final int? lastPage;
  final List<Link>? links;
  final String? path;
  final int? perPage;
  final int? to;
  final int? total;

  Meta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.links,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    currentPage: json["current_page"],
    from: json["from"],
    lastPage: json["last_page"],
    links: json["links"] == null
        ? []
        : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
    path: json["path"],
    perPage: json["per_page"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "from": from,
    "last_page": lastPage,
    "links": links == null
        ? []
        : List<dynamic>.from(links!.map((x) => x.toJson())),
    "path": path,
    "per_page": perPage,
    "to": to,
    "total": total,
  };
}

class Link {
  final String? url;
  final String? label;
  final bool? active;

  Link({this.url, this.label, this.active});

  factory Link.fromJson(Map<String, dynamic> json) =>
      Link(url: json["url"], label: json["label"], active: json["active"]);

  Map<String, dynamic> toJson() => {
    "url": url,
    "label": label,
    "active": active,
  };
}
