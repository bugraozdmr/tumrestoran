import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../config/theme/app_color.dart';
import '../../../../../widgets/text_widget.dart';
import '../../../cart/controller/cart_controller.dart';
import '../../controller/checkout_controller.dart';

class RiderTipSection extends StatelessWidget {
  const RiderTipSection({
    super.key,
    required this.cartController,
    required this.checkoutController,
  });

  final CartController cartController;
  final CheckoutController checkoutController;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => cartController.isDeliver.value == false
          ? SizedBox()
          : Container(
              height: 160.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: AppColor.whiteColor,
                boxShadow: const [BoxShadow(color: AppColor.black80)],
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 16.w, top: 16.w, bottom: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: "TIP_YOUR_RIDER".tr,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(height: 8.h),
                    TextWidget(
                      text:
                          "TIP_SUBTITLE".tr,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(height: 12.h),
                    Expanded(
                      child: SizedBox(
                        child: Obx(
                          () => ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount:
                                checkoutController.tipModel.value.data?.length,
                            itemBuilder: (context, index) {
                              final tip = checkoutController
                                  .tipModel
                                  .value
                                  .data?[index];
                              checkoutController.tipModel.value.data;
                              return GestureDetector(
                                onTap: () {
                                  checkoutController.tipIndex.value = index;
                                  checkoutController.getRiderTipAmount(
                                    tip?.amount ?? 0,
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(right: 8.w),
                                  child: Obx(
                                    () => Container(
                                      width: 58.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          18.r,
                                        ),
                                        border: Border.all(
                                          color:
                                              checkoutController
                                                      .tipIndex
                                                      .value ==
                                                  index
                                              ? AppColor.primaryColor
                                              : AppColor.background,
                                        ),
                                        color:
                                            checkoutController.tipIndex.value ==
                                                index
                                            ? AppColor.primaryLight
                                            : AppColor.background,
                                      ),
                                      child: Center(
                                        child: TextWidget(
                                          text: tip?.label ?? "",
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
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
