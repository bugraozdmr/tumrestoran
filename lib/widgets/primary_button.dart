// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../config/theme/app_color.dart';
import 'normal_text.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.onTap,
    required this.text,
    this.color,
    required this.width,
  });

  final void Function() onTap;
  final String text;
  final Color? color;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48.h,
        width: width,
        decoration: BoxDecoration(
          color: color ?? AppColor.primaryColor,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Center(
          child: FittedBox(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: NormalText(
                text: text,
                color: AppColor.whiteColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
