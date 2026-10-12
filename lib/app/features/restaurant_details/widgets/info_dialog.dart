import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodnanny/data/model/restaurant_details.dart';
import 'package:foodnanny/widgets/text_widget.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../utils/svg_icon.dart';
import '../../../../widgets/divider_widget.dart';
import '../../../../widgets/normal_text.dart';
import '../../home/widgets/google_map_widget.dart';
import '../controller/restaurant_details_controller.dart';
import 'time_slot_widget.dart';

class InfoDialog extends StatefulWidget {
  const InfoDialog({
    super.key,
    required this.restaurantController,
    required this.timeSlots,
  });

  final RestaurantDetailsController restaurantController;
  final List<TimeSlot>? timeSlots;

  @override
  State<InfoDialog> createState() => _InfoDialogState();
}

class _InfoDialogState extends State<InfoDialog> {
  Map<int, List<Map<String, dynamic>>>? groupedTimeSlots;

  final List<String> weekDays = const [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  Map<int, List<Map<String, dynamic>>> groupTimeSlotsByDay(
    List<Map<String, dynamic>> slots,
  ) {
    Map<int, List<Map<String, dynamic>>> grouped = {};

    for (var slot in slots) {
      int day = slot['day'];
      if (!grouped.containsKey(day)) {
        grouped[day] = [];
      }
      grouped[day]!.add(slot);
    }
    return grouped;
  }

  @override
  void initState() {
    super.initState();
    groupedTimeSlots = groupTimeSlotsByDay(
      widget.timeSlots!.map((slot) => slot.toJson()).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    double ratingStar =
        double.tryParse(
          widget.restaurantController.restaurantDetails.value.data?.ratingStar
                  ?.toString() ??
              "0",
        ) ??
        0;

    double ratingCount =
        double.tryParse(
          widget
                  .restaurantController
                  .restaurantDetails
                  .value
                  .data
                  ?.ratingStarCount
                  ?.toString() ??
              "0",
        ) ??
        0;

    double avgRating = ratingCount == 0 ? 0 : ratingStar / ratingCount;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: AlertDialog(
        insetPadding: EdgeInsets.zero,
        surfaceTintColor: AppColor.whiteColor,
        backgroundColor: AppColor.whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.r)),
        ),
        content: SizedBox(
          width: 328.w,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            text:
                                widget
                                    .restaurantController
                                    .restaurantDetails
                                    .value
                                    .data
                                    ?.name ??
                                "",
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),

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
                SizedBox(height: 16.h),
                const DividerWidget(),
                SizedBox(height: 8.h),

                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 42.h,
                        decoration: BoxDecoration(
                          color: AppColor.whiteColor,
                          borderRadius: BorderRadius.circular(21.r),
                          border: Border.all(color: AppColor.whiteColor),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                widget.restaurantController.isInfo.value = true;
                              },
                              child: Container(
                                height: 42.h,
                                decoration: BoxDecoration(
                                  color:
                                      widget
                                              .restaurantController
                                              .isInfo
                                              .value ==
                                          true
                                      ? AppColor.primaryColor
                                      : AppColor.whiteColor,
                                  borderRadius: BorderRadius.circular(21.r),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                  ),
                                  child: Center(
                                    child: NormalText(
                                      text: "INFO".tr,
                                      color:
                                          widget
                                                  .restaurantController
                                                  .isInfo
                                                  .value ==
                                              true
                                          ? AppColor.whiteColor
                                          : AppColor.primaryColor,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                widget.restaurantController.isInfo.value =
                                    false;
                              },
                              child: Container(
                                height: 42.h,
                                width: 88.w,
                                decoration: BoxDecoration(
                                  color:
                                      widget
                                              .restaurantController
                                              .isInfo
                                              .value ==
                                          false
                                      ? AppColor.primaryColor
                                      : AppColor.whiteColor,
                                  borderRadius: BorderRadius.circular(21.r),
                                ),
                                child: Center(
                                  child: NormalText(
                                    text: "REVIEWS".tr,
                                    fontSize: 14.sp,
                                    color:
                                        widget
                                                .restaurantController
                                                .isInfo
                                                .value ==
                                            false
                                        ? AppColor.whiteColor
                                        : AppColor.primaryColor,
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
                SizedBox(height: 8.h),
                const DividerWidget(),
                SizedBox(height: 12.h),
                Obx(
                  () => widget.restaurantController.isInfo.value == true
                      ? Column(
                          children: [

                            Row(
                              children: [
                                SvgPicture.asset(
                                  SvgIcon.location,
                                  height: 16.h,
                                  colorFilter: const ColorFilter.mode(
                                    AppColor.black80,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: TextWidget(
                                    text:
                                        widget
                                            .restaurantController
                                            .restaurantDetails
                                            .value
                                            .data
                                            ?.address ??
                                        "",
                                    fontSize: 14.sp,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            const DividerWidget(),
                            SizedBox(height: 12.h),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  SvgIcon.sms,
                                  height: 16.h,
                                  colorFilter: const ColorFilter.mode(
                                    AppColor.black80,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: TextWidget(
                                    text:
                                        widget
                                            .restaurantController
                                            .restaurantDetails
                                            .value
                                            .data
                                            ?.email ??
                                        "",
                                    fontSize: 14.sp,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            const DividerWidget(),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  SvgIcon.call,
                                  height: 16.h,
                                  colorFilter: const ColorFilter.mode(
                                    AppColor.black80,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: TextWidget(
                                    text:
                                        "${widget.restaurantController.restaurantDetails.value.data?.countryCode ?? ""}${widget.restaurantController.restaurantDetails.value.data?.phone ?? ""}",
                                    fontSize: 14.sp,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            const DividerWidget(),
                            SizedBox(height: 12.h),
                            Row(
                              children: [
                                SvgPicture.asset(SvgIcon.clock80, height: 16.h),
                                SizedBox(width: 8.w),
                                TextWidget(text: "OPENING_TIME".tr),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: weekDays.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final dayName = weekDays[index];
                                final slots = groupedTimeSlots?[index] ?? [];

                                String slotTimes = slots
                                    .map(
                                      (slot) =>
                                          '${slot['opening_time']} - ${slot['closing_time']}',
                                    )
                                    .join(',\n');

                                final filteredList = <Map<String, dynamic>>[];

                                for (int i = 0; i < weekDays.length; i++) {
                                  final dayName = weekDays[i];
                                  final slots = groupedTimeSlots?[i] ?? [];

                                  filteredList.add({
                                    'day': dayName,
                                    'slots': slots,
                                  });
                                }

                                return TimeSlotWidget(
                                  day: dayName,
                                  timeSlot: slotTimes,
                                );
                              },
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: "RATING_AND_REVIEWS".tr,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(SvgIcon.star, height: 16.h),
                                SizedBox(width: 8.w),
                                Row(
                                  children: [
                                    TextWidget(
                                      text: avgRating.toStringAsFixed(1),
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    SizedBox(width: 8.w),
                                    TextWidget(
                                      text:
                                          "(${widget.restaurantController.restaurantDetails.value.data?.ratingStarCount} ratings)",
                                      fontSize: 12.sp,
                                      color: AppColor.black80,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: widget
                                  .restaurantController
                                  .restaurantDetails
                                  .value
                                  .data
                                  ?.reviews
                                  ?.length,
                              itemBuilder: (context, index) {
                                final review = widget
                                    .restaurantController
                                    .restaurantDetails
                                    .value
                                    .data
                                    ?.reviews?[index];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 8.h),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 304.w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                          border: Border.all(
                                            color: AppColor.black20,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left: 12.w,
                                            right: 12.w,
                                            top: 12.h,
                                            bottom: 12.h,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              TextWidget(
                                                text:
                                                    review?.name ?? "John Doe",
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              Row(
                                                children: [
                                                  RatingBarIndicator(
                                                    itemSize: 16.h,
                                                    itemCount: 5,
                                                    rating: double.parse(
                                                      review?.star.toString() ??
                                                          "0",
                                                    ),
                                                    itemBuilder:
                                                        (context, index) {
                                                          return SvgPicture.asset(
                                                            SvgIcon.star,
                                                            height: 16.h,
                                                          );
                                                        },
                                                  ),
                                                  SizedBox(width: 4.w),
                                                  TextWidget(
                                                    text:
                                                        review?.createdAt ??
                                                        "6/9/2022",
                                                    fontSize: 12.sp,
                                                    color: AppColor.black80,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 12.h),
                                              TextWidget(
                                                text:
                                                    review?.review ??
                                                    "the french fry containers broke so all the fries came out the bottom. Overpriced too... but apart from that the food was good.",
                                                fontSize: 14.sp,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 12.h),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
