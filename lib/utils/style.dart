// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../config/theme/app_color.dart';

class Dimensions {
  static double fontSizeExtraSmallSamll = 8;
  static double fontSizeExtraSmall = 10;
  static double fontSizeSmall = 12;
  static double fontSizeDefault = 14;
  static double fontSizeReasonHeading = 14;
  static double fontSizeReasonText = 12;
  static double fontSizeLarge = 16;
  static double fontSizeExtraLarge = 18;
  static double fontSizeExtraLarge22 = 22;
  static double fontSizeOverLarge = 26;
}

class ScreenSize {
  BuildContext context;
  ScreenSize(this.context);
  double get mainHeight => MediaQuery.of(context).size.height;
  double get mainWidth => MediaQuery.of(context).size.width;
  double get block => mainWidth / 100;
}

final textLight10 = TextStyle(
  fontFamily: 'Rubik',
  fontWeight: FontWeight.w400,
  color: AppColor.black80,
  fontSize: 10.sp,
);

final textLight12 = TextStyle(
  fontFamily: 'Rubik',
  fontWeight: FontWeight.w400,
  color: AppColor.black80,
  fontSize: 12.sp,
);

final textLight14 = TextStyle(
  fontFamily: 'Rubik',
  fontWeight: FontWeight.w400,
  color: AppColor.black80,
  fontSize: 14.sp,
);

final textNormal14 = TextStyle(
  fontFamily: 'Rubik',
  fontWeight: FontWeight.w400,
  color: AppColor.black100,
  fontSize: 14.sp,
);

final textNormal12 = TextStyle(
  fontFamily: 'Rubik',
  fontWeight: FontWeight.w500,
  color: AppColor.black100,
  fontSize: 12.sp,
);

final title18 = TextStyle(
  fontFamily: 'Rubik',
  fontWeight: FontWeight.w600,
  color: AppColor.black100,
  fontSize: 18.sp,
);
final title16 = TextStyle(
  fontFamily: 'Rubik',
  fontWeight: FontWeight.w500,
  color: AppColor.black100,
  fontSize: 16.sp,
);
