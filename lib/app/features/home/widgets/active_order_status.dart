// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodnanny/app/features/order_details/controller/order_details_controller.dart';
import 'package:foodnanny/app/features/order_details/view/order_details_screen.dart';
import 'package:foodnanny/app/features/order_history/controller/order_history_controller.dart';
import 'package:foodnanny/utils/svg_icon.dart';
import 'package:get/get.dart';

import '../../../../config/theme/app_color.dart';

class ActiveOrderStatus extends StatefulWidget {
  const ActiveOrderStatus({super.key});

  @override
  State<ActiveOrderStatus> createState() => _ActiveOrderStatusState();
}

class _ActiveOrderStatusState extends State<ActiveOrderStatus> {
  final orderHistoryController = Get.put(OrderHistoryController());

  @override
  void initState() {
    Get.put(OrderDetailsController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      orderHistoryController.getCurrentlyActiveOrder();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        Get.to(
          () => OrderDetailScreen(
            orderId: orderHistoryController.currentlyActiveOrder[0].id
                .toString(),
          ),
        );
      },
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(color: AppColor.primaryLight),
        child: Padding(
          padding: EdgeInsets.all(15.r),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 24.w,
                        height: 24.h,
                        child: SvgPicture.asset(
                          SvgIcon.iconRouting,
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            AppColor.primaryColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.h),
                      Obx(
                        () => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "YOUR_ORDER_PROCESS_STAGE".tr,
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                                color: AppColor.primaryColor,
                              ),
                            ),
                            SizedBox(height: 8.h),

                            if (orderHistoryController
                                    .currentlyActiveOrder[0]
                                    .status ==
                                4)
                              Text(
                                "YOUR_ORDER_IS_CONFIRMED".tr,
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.sp,
                                  color: AppColor.primaryColor,
                                ),
                              ),
                            if (orderHistoryController
                                    .currentlyActiveOrder[0]
                                    .status ==
                                7)
                              Text(
                                "YOUR_ORDER_IS_BEING_PREPARING".tr,
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.sp,
                                  color: AppColor.primaryColor,
                                ),
                              ),
                            if (orderHistoryController
                                    .currentlyActiveOrder[0]
                                    .status ==
                                8)
                              Text(
                                "YOUR_ORDER_IS_PREPARED".tr,
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.sp,
                                  color: AppColor.primaryColor,
                                ),
                              ),
                            SizedBox(height: 4.h),
                            if (orderHistoryController
                                    .currentlyActiveOrder[0]
                                    .status ==
                                10)
                              Text(
                                "YOUR_ORDER_IS_OUT_FOR_DELIVERY".tr,
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.sp,
                                  color: AppColor.primaryColor,
                                ),
                              ),
                            SizedBox(height: 4.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 24.w,
                    height: 24.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColor.primaryColor,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(3.r),
                      child: SvgPicture.asset(
                        SvgIcon.arrowRight,
                        fit: BoxFit.contain,
                        colorFilter: ColorFilter.mode(
                          AppColor.whiteColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              SizedBox(
                width: double.infinity,
                height: 14.h,
                child: SvgPicture.asset(
                  SvgIcon.iconTimeline,
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    AppColor.primaryColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
