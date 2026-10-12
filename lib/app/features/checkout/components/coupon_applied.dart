import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tumrestoran/app/features/checkout/controller/checkout_controller.dart';
import 'package:tumrestoran/config/theme/app_color.dart';
import 'package:tumrestoran/utils/svg_icon.dart';
import 'package:tumrestoran/widgets/text_widget.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:get/utils.dart';

class CouponAppliedWidget extends StatelessWidget {
  const CouponAppliedWidget({
    this.deleteCoupon,
    this.discount,
    super.key,
    required this.type,
  });

  final String? discount;
  final void Function()? deleteCoupon;
  final int type;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColor.positiveDark),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Row(
          children: [
            Column(
              children: [
                SvgPicture.asset(
                  SvgIcon.ticketDiscount,
                  height: 24.h,
                  colorFilter: const ColorFilter.mode(
                    AppColor.positiveDark,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: "OFFER_APPLIED".tr,
                        color: AppColor.positiveDark,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      Obx(() {
                        final discount = Get.find<CheckoutController>()
                            .couponDiscountText
                            .value;

                        return TextWidget(
                          text: type == 10
                              ? "YOU_GOT_FREE_DELIVERY".tr
                              : "YOU_SAVED".trParams({'discount': discount}),
                          fontSize: 12.sp,
                        );
                      }),
                    ],
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: deleteCoupon,
                        child: SvgPicture.asset(
                          SvgIcon.trashCan,
                          height: 20.h,
                          colorFilter: ColorFilter.mode(
                            AppColor.rejectedTextColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
