import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../utils/svg_icon.dart';
import '../../../../widgets/normal_text.dart';
import '../controller/checkout_controller.dart';

class TimeScheduleCard extends StatefulWidget {
  const TimeScheduleCard({
    super.key,
    required this.checkoutController,
    required this.restaurantId,
    required this.isDelivery,
  });

  final CheckoutController checkoutController;
  final int restaurantId;
  final bool isDelivery;

  @override
  State<TimeScheduleCard> createState() => _TimeScheduleCardState();
}

class _TimeScheduleCardState extends State<TimeScheduleCard> {
  @override
  void initState() {
    widget.checkoutController.isToday.value == true;
    widget.checkoutController.getTodayDeliveryTime(
      restaurantId: widget.restaurantId,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180.w,
      child: GestureDetector(
        onTap: () async {
          widget.checkoutController.selectTime.value = 10;
          widget.checkoutController.deliveryTime = null;

          await showDialog(
            context: context,
            builder: (_) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: AlertDialog(
                insetPadding: EdgeInsets.zero,
                surfaceTintColor: AppColor.whiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.r)),
                ),
                content: SizedBox(
                  width: 328.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          NormalText(
                            text: 'SELECT_DELIVERY_DATE'.tr,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),

                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: SvgPicture.asset(
                              SvgIcon.closeCircle,
                              height: 24.h,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Divider(color: AppColor.black40),

                      widget.checkoutController.deliveryTimeModel.value.data ==
                                  null ||
                              widget
                                  .checkoutController
                                  .deliveryTimeModel
                                  .value
                                  .data!
                                  .isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 24.h),
                                  Text("NO_SCHEDLUE_FOUND".tr),
                                ],
                              ),
                            )
                          : Obx(
                              () => Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 42.h,
                                    decoration: BoxDecoration(
                                      color: AppColor.background,
                                      borderRadius: BorderRadius.circular(21.r),
                                      border: Border.all(
                                        color: AppColor.black20,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            widget
                                                    .checkoutController
                                                    .isToday
                                                    .value =
                                                true;
                                            widget
                                                    .checkoutController
                                                    .selectDesireTime
                                                    .value =
                                                -1;
                                            await widget.checkoutController
                                                .getTodayDeliveryTime(
                                                  restaurantId:
                                                      widget.restaurantId,
                                                );
                                          },
                                          child: Container(
                                            height: 42.h,
                                            decoration: BoxDecoration(
                                              color:
                                                  widget
                                                          .checkoutController
                                                          .isToday
                                                          .value ==
                                                      true
                                                  ? AppColor.primaryColor
                                                  : AppColor.background,
                                              borderRadius:
                                                  BorderRadius.circular(21.r),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 16.w,
                                              ),
                                              child: Center(
                                                child: NormalText(
                                                  text: "Today".tr,
                                                  color:
                                                      widget
                                                              .checkoutController
                                                              .isToday
                                                              .value ==
                                                          true
                                                      ? AppColor.whiteColor
                                                      : AppColor.black100,
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            widget
                                                    .checkoutController
                                                    .isToday
                                                    .value =
                                                false;
                                            widget
                                                    .checkoutController
                                                    .selectDesireTime
                                                    .value =
                                                -1;
                                            widget.checkoutController
                                                .getTomorrowDeliveryTime(
                                                  restaurantId:
                                                      widget.restaurantId,
                                                );
                                          },
                                          child: Container(
                                            height: 42.h,
                                            width: 88.w,
                                            decoration: BoxDecoration(
                                              color:
                                                  widget
                                                          .checkoutController
                                                          .isToday
                                                          .value ==
                                                      false
                                                  ? AppColor.primaryColor
                                                  : AppColor.background,
                                              borderRadius:
                                                  BorderRadius.circular(21.r),
                                            ),
                                            child: Center(
                                              child: NormalText(
                                                text: "Tomorrow".tr,
                                                fontSize: 14.sp,
                                                color:
                                                    widget
                                                            .checkoutController
                                                            .isToday
                                                            .value ==
                                                        false
                                                    ? AppColor.whiteColor
                                                    : AppColor.black100,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                      SizedBox(height: 24.h),
                      widget.checkoutController.deliveryTimeModel.value.data ==
                                  null ||
                              widget
                                  .checkoutController
                                  .deliveryTimeModel
                                  .value
                                  .data!
                                  .isEmpty
                          ? SizedBox.shrink()
                          : NormalText(
                              text: 'DESERIED_DELIVERY_TIME'.tr,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),

                      SizedBox(height: 12.h),
                      Expanded(
                        child: Obx(
                          () =>
                              widget
                                          .checkoutController
                                          .selectDesireTime
                                          .value ==
                                      -3 ||
                                  widget
                                          .checkoutController
                                          .deliveryTimeModel
                                          .value
                                          .data ==
                                      null
                              ? const SizedBox()
                              : GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 12.h,
                                        crossAxisSpacing: 16.w,
                                        childAspectRatio: 3,
                                      ),

                                  itemCount: widget
                                      .checkoutController
                                      .deliveryTimeModel
                                      .value
                                      .data!
                                      .length,
                                  itemBuilder: (context, index) {
                                    return widget
                                                .checkoutController
                                                .deliveryTimeModel
                                                .value
                                                .data?[index]
                                                .label ==
                                            "now"
                                        ? const SizedBox()
                                        : GestureDetector(
                                            onTap: () {
                                              widget
                                                      .checkoutController
                                                      .selectDesireTime
                                                      .value =
                                                  index;
                                              widget
                                                  .checkoutController
                                                  .deliveryTime = widget
                                                  .checkoutController
                                                  .deliveryTimeModel
                                                  .value
                                                  .data![index]
                                                  .time;

                                              Get.back();
                                            },
                                            child: Container(
                                              height: 40.h,
                                              width: 144.w,
                                              decoration: BoxDecoration(
                                                color:
                                                    widget
                                                            .checkoutController
                                                            .selectDesireTime
                                                            .value ==
                                                        index
                                                    ? AppColor.primaryLight
                                                    : AppColor.background,
                                                borderRadius:
                                                    BorderRadius.circular(20.r),
                                                border: Border.all(
                                                  color:
                                                      widget
                                                              .checkoutController
                                                              .selectDesireTime
                                                              .value ==
                                                          index
                                                      ? AppColor.primaryColor
                                                      : Colors.transparent,
                                                ),
                                              ),
                                              child: Center(
                                                child: NormalText(
                                                  text:
                                                      widget
                                                          .checkoutController
                                                          .deliveryTimeModel
                                                          .value
                                                          .data?[index]
                                                          .label ??
                                                      "11.30 am - 12.00 pm",
                                                  fontSize: 12.sp,
                                                ),
                                              ),
                                            ),
                                          );
                                  },
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        child: Container(
          height: 60.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: widget.checkoutController.selectTime.value == 10
                ? AppColor.primaryLight
                : AppColor.background,
            border: Border.all(
              color: widget.checkoutController.selectTime.value == 10
                  ? AppColor.primaryColor
                  : Colors.transparent,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 12.w, right: 8.w, top: 6.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    NormalText(
                      text: 'SCHEDULE_FOR_LATER'.tr,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    const Spacer(),
                    SvgPicture.asset(
                      widget.checkoutController.selectTime.value == 10
                          ? SvgIcon.radioCircleMarked
                          : SvgIcon.radioCircle,
                      height: 16.h,
                    ),
                  ],
                ),
                NormalText(text: 'CHOOSE_A_TIME'.tr, fontSize: 14.sp),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
