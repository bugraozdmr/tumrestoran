import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../config/theme/app_color.dart';
import 'text_widget.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton(
      {super.key,
      required this.onPressed,
      required this.text,
      this.width,
      this.borderColor,
      this.textColor,
      this.height,
      this.textFontSize});
  final void Function()? onPressed;
  final String text;
  final double? height;
  final double? width;
  final Color? borderColor;
  final Color? textColor;
  final double? textFontSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height ?? 48.h,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
            color: AppColor.whiteColor,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
                color: borderColor ?? AppColor.primaryColor, width: 1.w)),
        child: Center(
          child: TextWidget(
            text: text,
            color: textColor ?? AppColor.primaryColor,
            fontWeight: FontWeight.w500,
            fontSize: textFontSize ?? 16.sp,
          ),
        ),
      ),
    );
  }
}
