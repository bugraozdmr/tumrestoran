import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../widgets/normal_text.dart';

class CustomChip extends StatelessWidget {
  const CustomChip({
    super.key,
    required this.iconImg,
    required this.label,
    this.actionIcon,
    this.width,
    this.isPressed = false,
    this.onTap,
    this.actionIconOnTap,
  });

  final String iconImg;
  final String label;
  final double? width;
  final String? actionIcon;
  final bool isPressed;
  final VoidCallback? onTap;
  final VoidCallback? actionIconOnTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36.h,
        width: width,
        decoration: BoxDecoration(
          color: isPressed == true ? AppColor.whiteColor : AppColor.background,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColor.black10),
          boxShadow: const [
            BoxShadow(color: AppColor.border, blurRadius: 2, spreadRadius: 0.4),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(iconImg, height: 16.h, width: 16.w, fit: BoxFit.fill),
              SizedBox(width: 6.w),
              NormalText(
                text: label,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(width: 16.w),
              isPressed == true
                  ? GestureDetector(
                      onTap: actionIconOnTap,
                      child: SvgPicture.asset(
                        actionIcon ?? "",
                        height: 16.h,
                        width: 16.w,
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
