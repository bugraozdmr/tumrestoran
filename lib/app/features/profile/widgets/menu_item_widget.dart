import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../widgets/divider_widget.dart';
import '../../../../widgets/text_widget.dart';

class MenuItemWidget extends StatelessWidget {
  const MenuItemWidget({
    super.key,
    required this.svgIcon,
    required this.title,
    this.onTap,
  });
  final String svgIcon;
  final String title;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.w),
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                SvgPicture.asset(svgIcon, height: 16.h, width: 16.w),
                SizedBox(width: 16.w),
                TextWidget(
                  text: title.tr,
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  color: AppColor.black100,
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          const DividerWidget(),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }
}
