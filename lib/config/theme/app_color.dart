import 'package:flutter/material.dart';

import '../../main.dart';

class AppColor {
  static Color get primaryColor {
    String colorCode = box.read('primaryColor') ?? 'F36805';

    return Color(int.parse('FF$colorCode', radix: 16));
  }

  static const primaryLight = Color(0xffFFF8F2);
  static const whiteColor = Color(0xffFFFFFF);
  static const blackColor = Color(0xff000000);
  static const borderColor = Color(0xffD9DBE9);
  static const black10 = Color(0xffF7F7FC);
  static const black20 = Color(0xffEFF0F6);
  static const black40 = Color(0xffD9DBE9);
  static const background = Color(0xffF7F7FC);
  static const black80 = Color(0xff6E7191);
  static const black100 = Color(0xff1F1F39);
  static const green = Color(0xff1AB759);
  static const fontColor = Color(0xff1F1F39);
  static const inputBorderColor = Color(0xffD9DBE9);
  static const border = Color.fromRGBO(126, 133, 142, 0.16);
  static const itemBorder = Color(0xffD9D9D9);
  static const highlightLight = Color(0xffE9FAFF);
  static const highlightDark = Color(0xff00749B);
  static const negativeDark = Color(0xffE93C3C);
  static const positiveDark = Color(0xff1AB759);
  static const positiveLight = Color(0xffE0FFED);
  static const addressColor = Color(0xffF7F7F7);
  static const pendingColor = Color(0xffFFF4DA);
  static const acceptColor = Color.fromARGB(255, 208, 243, 223);
  static const processingColor = Color(0xffE1FFED);
  static const preparingColor = Color(0xffE1FFED);
  static const onTheWayColor = Color(0xffBDEFFF);
  static const deliveredColor = Color(0xffFFF8F2);
  static const canceledColor = Color(0xffFFDADA);
  static const rejectedColor = Color(0xffFFDADA);
  static const returnedColor = Color(0xffFFDADA);
  static const pendingTextColor = Color(0xffE89806);
  static const acceptTextColor = Color(0xff1AB759);
  static const processingTextColor = Color(0xff2AC769);
  static const preparingTextColor = Color(0xff2AC769);
  static const onTheWayTextColor = Color(0xff008BBA);
  static const deliveredTextColor = Color(0xffF36805);
  static const canceledTextColor = Color(0xffE93C3C);
  static const rejectedTextColor = Color(0xffE93C3C);
  static const returnedTextColor = Color(0xffE93C3C);
  static const unSelectColor = Color(0xffFFEBDD);
  static const deliveryType = Color(0xff00749b);
}
