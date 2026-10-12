import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../widgets/normal_text.dart';

class LabelButton extends StatelessWidget {
  const LabelButton({
    super.key,
    required this.svgIcon,
    required this.text,
    this.onTap,
    required this.backgroundColor,
    this.borderColor,
  });
  final String svgIcon;
  final String text;
  final void Function()? onTap;
  final Color? backgroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48.h,
        width: 88.w,
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: borderColor ?? Colors.transparent)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              svgIcon,
              height: 16.h,
            ),
            SizedBox(width: 8.w),
            NormalText(text: text, fontSize: 14.sp, fontWeight: FontWeight.w500)
          ],
        ),
      ),
    );
  }
}
