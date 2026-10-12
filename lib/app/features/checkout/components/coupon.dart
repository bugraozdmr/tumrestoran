import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/utils.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../utils/svg_icon.dart';
import '../../../../widgets/normal_text.dart';

class CouponWidget extends StatelessWidget {
  const CouponWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58.h,
      width: 296.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: AppColor.whiteColor,
        boxShadow: const [
          BoxShadow(
            color: AppColor.black10,
            blurRadius: 1,
            spreadRadius: 2,
            offset: (Offset(0, 1)),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  SvgIcon.ticketDiscount,
                  colorFilter: ColorFilter.mode(
                    AppColor.highlightDark,
                    BlendMode.srcIn,
                  ),
                  height: 24.h,
                ),
              ],
            ),
            SizedBox(width: 12.w),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NormalText(
                  text: 'SELECT_APPLY_COUPON'.tr,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColor.highlightDark,
                ),
                NormalText(
                  text: 'GET_DISCOUNT_WITH_YOUR_ORDER'.tr,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [SvgPicture.asset(SvgIcon.rightArrow, height: 24.h)],
            ),
          ],
        ),
      ),
    );
  }
}
