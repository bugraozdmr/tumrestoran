import 'dart:convert';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  final String? message;
  final String? token;
  final int? restaurantId;
  final User? user;
  final List<Menu>? menu;
  final List<Permission>? permission;
  final Permission? defaultPermission;

  LoginModel({
    this.message,
    this.token,
    this.restaurantId,
    this.user,
    this.menu,
    this.permission,
    this.defaultPermission,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    message: json["message"],
    token: json["token"],
    restaurantId: json["restaurant_id"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    menu: json["menu"] == null
        ? []
        : List<Menu>.from(json["menu"]!.map((x) => Menu.fromJson(x))),
    permission: json["permission"] == null
        ? []
        : List<Permission>.from(
            json["permission"]!.map((x) => Permission.fromJson(x)),
          ),
    defaultPermission: json["defaultPermission"] == null
        ? null
        : Permission.fromJson(json["defaultPermission"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "token": token,
    "restaurant_id": restaurantId,
    "user": user?.toJson(),
    "menu": menu == null
        ? []
        : List<dynamic>.from(menu!.map((x) => x.toJson())),
    "permission": permission == null
        ? []
        : List<dynamic>.from(permission!.map((x) => x.toJson())),
    "defaultPermission": defaultPermission?.toJson(),
  };
}

class Permission {
  final int? id;
  final String? title;
  final String? name;
  final String? url;
  final bool? access;

  Permission({this.id, this.title, this.name, this.url, this.access});

  factory Permission.fromJson(Map<String, dynamic> json) => Permission(
    id: json["id"],
    title: json["title"],
    name: json["name"],
    url: json["url"],
    access: json["access"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "name": name,
    "url": url,
    "access": access,
  };
}

class Menu {
  final int? id;
  final String? name;
  final String? language;
  final String? url;
  final String? icon;
  final String? status;
  final String? parent;
  final String? type;
  final String? priority;
  final List<Menu>? children;

  Menu({
    this.id,
    this.name,
    this.language,
    this.url,
    this.icon,
    this.status,
    this.parent,
    this.type,
    this.priority,
    this.children,
  });

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
    id: json["id"],
    name: json["name"],
    language: json["language"],
    url: json["url"],
    icon: json["icon"],
    status: json["status"],
    parent: json["parent"],
    type: json["type"],
    priority: json["priority"],
    children: json["children"] == null
        ? []
        : List<Menu>.from(json["children"]!.map((x) => Menu.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "language": language,
    "url": url,
    "icon": icon,
    "status": status,
    "parent": parent,
    "type": type,
    "priority": priority,
    "children": children == null
        ? []
        : List<dynamic>.from(children!.map((x) => x.toJson())),
  };
}

class User {
  final int? id;
  final int? restaurantId;
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
