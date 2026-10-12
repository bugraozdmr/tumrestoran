import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodnanny/app/features/checkout/view/widgets/is_current_time_in_range.dart';
import 'package:get/get.dart';

import '../../../../../widgets/normal_text.dart';
import '../../../cart/controller/cart_controller.dart';
import '../../controller/checkout_controller.dart';
import '../../components/time_now_card.dart';
import '../../components/time_schedule_card.dart';

class DeliveryTimeSection extends StatelessWidget {
  const DeliveryTimeSection({
    super.key,
    required this.checkoutController,
    required this.cartController,
  });

  final CheckoutController checkoutController;
  final CartController cartController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NormalText(
          text: "DELIVERY_TIME".tr,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
        SizedBox(height: 12.h),

        Obx(() {
          final data = checkoutController.deliveryTimeModel.value.data;

          bool showTimeNowCard =
              data != null &&
              data.isNotEmpty &&
              isCurrentTimeInRange(
                fromTime: data[0].fromTime!,
                toTime: data[0].toTime!,
              );

          return checkoutController.selectTime.value == -2
              ? const SizedBox()
              : Row(
                  children: [
                    !showTimeNowCard
                        ? SizedBox.shrink()
                        : Padding(
                            padding: EdgeInsets.only(right: 16.w),
                            child: TimeNowCard(
                              onTap: () {
                                checkoutController.selectTime.value = 5;
                                checkoutController.selectDesireTime.value = -1;
                                if (checkoutController
                                        .deliveryTimeModel
                                        .value
                                        .data?[0]
                                        .label ==
                                    "now") {
                                  checkoutController.deliveryTime =
                                      checkoutController
                                          .deliveryTimeModel
                                          .value
                                          .data?[0]
                                          .time;
                                }
                              },
                              checkoutController: checkoutController,
                              foodPreparationTime:
                                  "${cartController.foodPreparationTime.value} mins",
                            ),
                          ),

                    Expanded(
                      child: TimeScheduleCard(
                        checkoutController: checkoutController,
                        restaurantId: cartController.restId.value,
                        isDelivery: cartController.isDeliver.value,
                      ),
                    ),
                  ],
                );
        }),
        SizedBox(height: 24.h),
      ],
    );
  }
}
