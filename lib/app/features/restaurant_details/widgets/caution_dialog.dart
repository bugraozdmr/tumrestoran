import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../utils/svg_icon.dart';
import '../../../../widgets/divider_widget.dart';
import '../../../../widgets/text_widget.dart';

class CautionDialog extends StatelessWidget {
  const CautionDialog({
    super.key,
    required this.name,
    required this.cautionText,
  });

  final String name;
  final String cautionText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: AppColor.whiteColor,
      backgroundColor: AppColor.whiteColor,
      content: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextWidget(text: name, fontSize: 18.sp),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              const DividerWidget(),
              SizedBox(height: 16.h),

              Html(data: cautionText),
            ],
          ),
          Positioned(
            right: 0.w,
            top: 0.h,
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: SvgPicture.asset(SvgIcon.closeCircle, height: 24.h),
            ),
          ),
        ],
      ),
    );
  }
}
