import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tumrestoran/app/features/order_details/widgets/review_modal_sheet.dart';
import 'package:tumrestoran/data/model/order_details_model.dart';
import 'package:tumrestoran/widgets/text_widget.dart';
import 'package:get/get.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../utils/svg_icon.dart';
import '../../../../widgets/normal_text.dart';
import '../controller/order_details_controller.dart';

class DeliveryManWidget extends StatelessWidget {
  const DeliveryManWidget({super.key, required this.orderData});

  final Data orderData;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.black100.withValues(alpha: 0.04),
            offset: Offset(0, 6),
            blurRadius: 32.r,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NormalText(
              text: "DELIVERY_MAN".tr,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 8.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth:
                        Get.find<OrderDetailsController>()
                            .orderDetailsModel
                            .value
                            .data!
                            .deliveryManReviewStatus!
                        ? 200.w
                        : 300.w,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        orderData.deliveryBoy?.image ?? '',
                        height: 40.r,
                        width: 40.r,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            NormalText(
                              text: orderData.deliveryBoy?.name ?? '',
                              fontSize: 14.sp,
                              color: AppColor.black100,
                              fontWeight: FontWeight.w500,
                            ),
                            if (orderData.deliveryBoy?.phone != null)
                              NormalText(
                                text:
                                    "${orderData.deliveryBoy?.countryCode} ${orderData.deliveryBoy?.phone ?? ''}",
                                fontSize: 12.sp,
                                color: AppColor.black80,
                                fontWeight: FontWeight.w400,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                if (orderData.deliveryManReviewStatus == true)
                  GestureDetector(
                    onTap: () async {
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) => Padding(
                          padding: MediaQuery.of(context).viewInsets,
                          child: ReviewModalSheet(order: orderData),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColor.primaryLight,
                        borderRadius: BorderRadius.circular(8.r),
                      ),

                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(SvgIcon.reviewIcon, height: 16.h),
                            SizedBox(width: 4.w),
                            TextWidget(
                              text: "REVIEW".tr,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColor.primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (orderData.deliveryBoy?.phone != null &&
                    orderData.deliveryManReviewStatus != true)
                  GestureDetector(
                    onTap: () {
                      String phone = orderData.deliveryBoy?.phone ?? "";
                      Get.find<OrderDetailsController>().launchURL(
                        'tel:$phone',
                      );
                    },
                    child: Container(
                      height: 40.r,
                      width: 40.r,
                      decoration: const BoxDecoration(
                        color: AppColor.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.sp),
                        child: SvgPicture.asset(
                          SvgIcon.callCalling,
                          height: 16.h,
                          colorFilter:  ColorFilter.mode(
                            AppColor.primaryColor,
                            BlendMode.srcIn,
                          ),
                        ),
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
