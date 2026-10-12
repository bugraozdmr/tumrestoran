import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../utils/svg_icon.dart';
import '../../../../widgets/normal_text.dart';
import '../controller/checkout_controller.dart';

class TimeNowCard extends StatelessWidget {
  const TimeNowCard({
    super.key,
    required this.checkoutController,
    required this.foodPreparationTime,
    this.onTap,
  });

  final CheckoutController checkoutController;
  final String foodPreparationTime;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.h,
        width: 114.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: checkoutController.selectTime.value == 5
                ? AppColor.primaryLight
                : AppColor.background,
            border: Border.all(
                color: checkoutController.selectTime.value == 5
                    ? AppColor.primaryColor
                    : Colors.transparent)),
        child: Padding(
          padding: EdgeInsets.only(left: 12.w, right: 8.w, top: 6.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  NormalText(
                    text: "Now",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  const Spacer(),
                  SvgPicture.asset(
                      checkoutController.selectTime.value == 5
                          ? SvgIcon.radioCircleMarked
                          : SvgIcon.radioCircle,
                      height: 16.h)
                ],
              ),
              NormalText(text: foodPreparationTime, fontSize: 14.sp),
            ],
          ),
        ),
      ),
    );
  }
}
