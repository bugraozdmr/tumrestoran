import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../utils/svg_icon.dart';
import '../../../../widgets/text_widget.dart';
import '../../cart/controller/cart_controller.dart';
import '../controller/checkout_controller.dart';

class CouponDialog extends StatefulWidget {
  const CouponDialog({
    super.key,
    required this.checkoutController,
    required this.cartController,
    this.applyCoupon,
  });
  final CheckoutController checkoutController;
  final CartController cartController;
  final void Function()? applyCoupon;

  @override
  State<CouponDialog> createState() => _CouponDialogState();
}

class _CouponDialogState extends State<CouponDialog> {
  @override
  void dispose() {
    widget.checkoutController.couponTextController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor: AppColor.whiteColor,
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    text: "AVAILABLE_COUPONS".tr,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: SvgPicture.asset(SvgIcon.closeCircle, height: 20.h),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColor.border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller:
                            widget.checkoutController.couponTextController,
                        decoration: InputDecoration(
                          hintText: "ENTER_COUPON_CODE".tr,
                          contentPadding: EdgeInsets.only(
                            left: 8.w,
                            bottom: 8.h,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: widget.applyCoupon,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(8.r),
                              bottomRight: Radius.circular(8.r),
                            ),
                            color: AppColor.primaryColor,
                          ),
                          child: Center(
                            child: TextWidget(
                              text: "APPLY".tr,
                              color: AppColor.whiteColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),

              /*----------- [ Show all Coupons List] ---------- */
              widget.checkoutController.couponModel.value.data == null
                  ? const SizedBox()
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget
                          .checkoutController
                          .couponModel
                          .value
                          .data!
                          .length,
                      itemBuilder: (context, index) {
                        final coupon =
                            widget.checkoutController.couponModel.value.data;

                        return Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(color: AppColor.border),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 0.h,
                                  right: 0.w,
                                  child: GestureDetector(
                                    onTap: () {
                                      widget
                                              .checkoutController
                                              .couponTextController
                                              .text =
                                          coupon?[index].code ?? "";
                                    },
                                    child: Container(
                                      width: 50.w,
                                      decoration: BoxDecoration(
                                        color: AppColor.primaryColor,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(8.r),
                                          bottomLeft: Radius.circular(8.r),
                                        ),
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(4.r),
                                          child: TextWidget(
                                            text: "APPLY".tr,
                                            color: AppColor.whiteColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxWidth: 190.w,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 8.h),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.amberAccent,
                                              borderRadius:
                                                  BorderRadius.circular(4.r),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 6.w,
                                                vertical: 4.w,
                                              ),
                                              child: TextWidget(
                                                text: 'CODE'.trParams({
                                                  'code': coupon![index].code
                                                      .toString(),
                                                }),

                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      TextWidget(
                                        text:
                                            coupon[index].code ==
                                                    'freedelivery' ||
                                                coupon[index].type == 10
                                            ? "GET_FREE_DELIVERY_WITH_YOUR_ORDER"
                                                  .tr
                                            : "COUPON_DESCRIPTION_TEXT".trParams({
                                                'discountAlt': coupon[index]
                                                    .discountAlt
                                                    .toString(),
                                                'order': coupon[index]
                                                    .minimumOrderCurrencyAmount
                                                    .toString(),
                                              }),
                                      ),
                                      SizedBox(height: 4.h),
                                      if (coupon[index].description!.isNotEmpty)
                                        ExpansionTile(
                                          tilePadding: EdgeInsets.zero,
                                          childrenPadding: EdgeInsets.symmetric(
                                            horizontal: 8.w,
                                            vertical: 4.h,
                                          ),
                                          title: TextWidget(
                                            text: 'TERMS_AND_CONDITIONS'.tr,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          children: [
                                            Html(
                                              data:
                                                  coupon[index].description ??
                                                  "",
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
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
