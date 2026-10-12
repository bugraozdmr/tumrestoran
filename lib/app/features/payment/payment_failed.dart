import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tumrestoran/app/features/bottom_navbar/views/bottom_navigation.dart';
import 'package:get/get.dart';

import '../../../config/theme/app_color.dart';
import '../../../widgets/text_widget.dart';

class PaymentFailedView extends GetView {
  const PaymentFailedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextWidget(
              text: "ARE_YOU_SURE_WANT_TO_CLOSE_THIS_PAYMENT_SESSION?".tr,
              color: AppColor.black100,
              fontWeight: FontWeight.w600,
              fontSize: 18.sp,
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.offAll(() => const BottomNavigationScreen());
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 1,
                      backgroundColor: AppColor.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                    ),
                    child: TextWidget(
                      text: "YES_CLOSE".tr,
                      color: AppColor.whiteColor,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 1,
                      backgroundColor: AppColor.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                    ),
                    child: TextWidget(
                      text: "RETRY".tr,
                      color: AppColor.whiteColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
