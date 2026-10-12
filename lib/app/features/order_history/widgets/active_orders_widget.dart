import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodnanny/data/model/active_order_history_model.dart';
import 'package:foodnanny/widgets/text_widget.dart';
import 'package:get/get.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../utils/svg_icon.dart';
import '../../../../widgets/normal_text.dart';
import '../../order_details/view/order_details_screen.dart';

class ActiveOrdersWidget extends StatelessWidget {
  const ActiveOrdersWidget({super.key, required this.orders});
  final ActiveOrderHistory? orders;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => OrderDetailScreen(orderId: orders!.id!.toString()));
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColor.black20),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    SvgIcon.reserve,
                    colorFilter: const ColorFilter.mode(
                      AppColor.highlightDark,
                      BlendMode.srcIn,
                    ),
                    height: 30.h,
                  ),
                ],
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
                            color: orders!.status == 1
                                ? AppColor.pendingColor
                                : orders!.status == 4
                                ? AppColor.processingColor
                                : orders!.status == 7
                                ? AppColor.processingColor
                                : orders!.status == 8
                                ? AppColor.preparingColor
                                : orders!.status == 10
                                ? AppColor.onTheWayColor
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
                                color: orders!.status == 1
                                    ? AppColor.pendingTextColor
                                    : orders!.status == 4
                                    ? AppColor.acceptTextColor
                                    : orders!.status == 7
                                    ? AppColor.processingTextColor
                                    : orders!.status == 8
                                    ? AppColor.preparingTextColor
                                    : orders!.status == 10
                                    ? AppColor.onTheWayTextColor
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
                        NormalText(
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
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff00749B),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        NormalText(
                          text: "${"TOTAL:".tr} ${orders!.totalCurrencyPrice}",
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        Row(
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
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
