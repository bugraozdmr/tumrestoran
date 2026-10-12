import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tumrestoran/data/model/campaign_model.dart';
import 'package:get/get.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../utils/svg_icon.dart';
import '../../../../widgets/text_widget.dart';

Future<dynamic> campaignInfoDialog(Campaign campaign) {
  return Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      backgroundColor: AppColor.whiteColor,
      insetPadding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  text: "OFFER_DETAILS".tr,
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
            SizedBox(height: 12.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      SvgIcon.discountShape,

                      height: 20.h,
                      colorFilter: ColorFilter.mode(
                        AppColor.primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),

                    SizedBox(width: 8.w),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            text: campaign.title ?? "",
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12.h),
            TextWidget(
              text: "NEW_AND_EXISTING_CUSTOMERS".tr,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
            TextWidget(
              text: "VALID_FOR_SELECTED_RESTAURANTS".tr,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
            SizedBox(height: 16.h),
            TextWidget(
              text: "VALID_DATE".trParams({
                'date': '${campaign.startDate} - ${campaign.endDate}',
              }).tr,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
            if (campaign.percentage!.isNotEmpty)
              TextWidget(
                text: "${"DISCOUNT".tr} ${campaign.percentage ?? ''}",
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),

            if (campaign.description!.isNotEmpty)
              Html(data: campaign.description ?? ""),
          ],
        ),
      ),
    ),
  );
}
