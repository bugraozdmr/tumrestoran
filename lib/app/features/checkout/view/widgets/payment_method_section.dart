import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:foodnanny/app/features/profile/controller/profile_controller.dart';
import 'package:get/get.dart';

import '../../../../../config/theme/app_color.dart';
import '../../../../../widgets/divider_widget.dart';
import '../../../../../widgets/normal_text.dart';
import '../../../../../widgets/text_widget.dart';
import '../../controller/checkout_controller.dart';

class PaymentMethodSection extends StatelessWidget {
  const PaymentMethodSection({super.key, required this.checkoutController});

  final CheckoutController checkoutController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NormalText(
          text: "PAYMENT_METHOD".tr,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
        SizedBox(height: 16.h),
        const DividerWidget(),
        SizedBox(height: 16.h),
        Obx(
          () =>
              checkoutController.paymentMethods.isEmpty ||
                  checkoutController.selectPaymentMethod.value == -2
              ? const SizedBox()
              : SizedBox(
                  child: MasonryGridView.builder(
                    shrinkWrap: true,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                    itemCount: checkoutController.paymentMethods.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          checkoutController.selectPaymentMethod.value = index;

                          checkoutController.paymentMethodId =
                              checkoutController.paymentMethods[index].id;

                          checkoutController.paymentMethodSlug =
                              checkoutController.paymentMethods[index].slug ??
                              "";
                        },
                        child: Container(
                          width: 156.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color:
                                  checkoutController
                                          .selectPaymentMethod
                                          .value ==
                                      index
                                  ? AppColor.primaryColor
                                  : AppColor.border,
                            ),
                            color:
                                checkoutController.selectPaymentMethod.value ==
                                    index
                                ? AppColor.primaryLight
                                : AppColor.whiteColor,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 8.h),
                              CachedNetworkImage(
                                imageUrl: checkoutController
                                    .paymentMethods[index]
                                    .image!,
                                height: 24.h,
                                width: 40.w,
                              ),
                              SizedBox(height: 8.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextWidget(
                                    text: checkoutController
                                        .paymentMethods[index]
                                        .name!,
                                  ),
                                  if (checkoutController
                                          .paymentMethods[index]
                                          .slug ==
                                      "credit")
                                    TextWidget(
                                      text:
                                          " (${Get.find<ProfileController>().profileModel.value.data?.balance ?? "000"})",
                                    ),
                                ],
                              ),

                              SizedBox(height: 8.h),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),

        SizedBox(height: 24.h),
      ],
    );
  }
}
