import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tumrestoran/data/model/previous_order_history_model.dart';
import 'package:tumrestoran/widgets/text_widget.dart';
import 'package:get/get.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../utils/svg_icon.dart';
import '../../../../widgets/normal_text.dart';
import '../../order_details/view/order_details_screen.dart';

class PreviousOrdersWidget extends StatelessWidget {
  const PreviousOrdersWidget({super.key, required this.orders});
  final PreviousOrderHistory? orders;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColor.black20),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [SvgPicture.asset(SvgIcon.reserve, height: 30.h)],
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      NormalText(
                        text: "ORDER_ID:".tr,
                        fontSize: 14.sp,
                        color: AppColor.black80,
                      ),
                      SizedBox(width: 4.w),
                      NormalText(
                        text: '#${orders!.orderSerialNo.toString()}',
                        fontSize: 14.sp,
                      ),
                      SizedBox(width: 16.w),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: orders!.status == 10
                              ? AppColor.preparingColor
                              : orders!.status == 13
                              ? AppColor.deliveredColor
                              : orders!.status == 16
                              ? AppColor.canceledColor
                              : orders!.status == 19
                              ? AppColor.rejectedColor
                              : orders!.status == 22
                              ? AppColor.returnedColor
                              : AppColor.primaryColor,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 8.w,
                            right: 8.w,
                            top: 1.h,
                            bottom: 1.h,
                          ),
                          child: Center(
                            child: NormalText(
                              text: orders!.statusName.toString(),
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                              color: orders!.status == 13
                                  ? AppColor.deliveredTextColor
                                  : orders!.status == 16
                                  ? AppColor.canceledTextColor
                                  : orders!.status == 19
                                  ? AppColor.rejectedTextColor
                                  : orders!.status == 22
                                  ? AppColor.returnedTextColor
                                  : AppColor.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  NormalText(
                    text: orders!.orderDatetime.toString(),
                    color: AppColor.black80,
                    fontSize: 12.sp,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: "FORM:".tr,
                        fontSize: 14.sp,
                        color: AppColor.black80,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: orders!.restaurantName.toString(),
                              fontSize: 14.sp,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  NormalText(
                    text: orders!.orderType == 5
                        ? "DELIVERY".tr
                        : orders!.orderType == 10
                        ? "TAKEAWAY".tr
                        : orders!.orderType == 15
                        ? "POS".tr
                        : "",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColor.deliveryType,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          NormalText(
                            text: "TOTAL:".tr,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          NormalText(
                            text: " ${orders!.totalCurrencyPrice}",
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(
                            () => OrderDetailScreen(
                              orderId: orders!.id!.toString(),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            NormalText(
                              text: "SEE_DETAILS".tr,
                              fontSize: 12.sp,
                              color: AppColor.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                            SvgPicture.asset(
                              SvgIcon.rightArrow,
                              height: 14.h,
                              width: 14.w,
                              colorFilter:  ColorFilter.mode(
                                AppColor.primaryColor,
                                BlendMode.srcIn,
                              ),
                            ),
                          ],
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
