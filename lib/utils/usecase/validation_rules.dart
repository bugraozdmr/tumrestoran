import 'package:get/get.dart';

class ValidationRules {
  final regExpression =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  String? normal(value) {
    if (value == null || value.isEmpty) {
      return "THIS_FIELD_IS_REQUIRED".tr;
    }
    return null;
  }

  email(value) {
    RegExp regExp = RegExp(regExpression);
    if (value == null || value.isEmpty) {
      return "EMAIL_IS_REQUIRED".tr;
    } else if (!regExp.hasMatch(value)) {
      return 'ENTER_A_VALID_EMAIL'.tr;
    } else if (!value.contains('@')) {
      return "ENTER_A_VALID_EMAIL".tr;
    } else {
      return null;
    }
  }

  password(value) {
    if (value == null || value.isEmpty) {
      return "PASSWORD_IS_REQUIRED".tr;
    } else if (value.length <= 5) {
      return "PASSWORD_LENGTH_SHOULD_BE_AT_LEAST_6".tr;
    } else {
      return null;
    }
  }

  phone(value) {
    if (value == null || value.isEmpty) {
      return "PHONE_IS_REQUIRED".tr;
    } else {
      return null;
    }
  }

  firstName(value) {
    if (value == null || value.isEmpty) {
      return "FIRST_NAME_IS_REQUIRED".tr;
    } else {
      return null;
    }
  }

  lastName(value) {
    if (value == null || value.isEmpty) {
      return "LAST_NAME_IS_REQUIRED".tr;
    } else {
      return null;
    }
  }
}
