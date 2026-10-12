import 'package:tumrestoran/app/features/profile/controller/profile_controller.dart';
import 'package:get/get.dart';

String formatPriceWithCurrency(double price) {
  final currency = Get.find<ProfileController>().currency.value;
  final position = Get.find<ProfileController>().currencyPosition.value;
  final decimalPoint =
      Get.find<ProfileController>()
          .settingModel
          .data
          ?.siteDigitAfterDecimalPoint ??
      2;

  final formattedPrice = price.toStringAsFixed(decimalPoint);

  return position == "5"
      ? '$currency$formattedPrice'
      : '$formattedPrice$currency';
}
