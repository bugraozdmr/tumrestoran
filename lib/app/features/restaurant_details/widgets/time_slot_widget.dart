import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../widgets/text_widget.dart';

class TimeSlotWidget extends StatelessWidget {
  const TimeSlotWidget({super.key, required this.day, required this.timeSlot});

  final String day;
  final String timeSlot;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 24.w),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(text: day, fontSize: 14.sp),
                    Column(
                      children: [
                        TextWidget(
                          text: timeSlot.isEmpty ? "CLOSED".tr : timeSlot,
                          fontSize: 14.sp,
                          color: AppColor.black80,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
