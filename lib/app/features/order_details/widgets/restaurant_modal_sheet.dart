import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tumrestoran/app/features/order_details/controller/review_controller.dart';
import 'package:tumrestoran/data/model/order_details_model.dart';
import 'package:tumrestoran/utils/svg_icon.dart';
import 'package:tumrestoran/widgets/custom_snackbar.dart';
import 'package:tumrestoran/widgets/text_widget.dart';
import 'package:get/get.dart';

import '../../../../config/theme/app_color.dart';
import 'submit_review_button.dart';

class RestaurantModalSheet extends StatefulWidget {
  const RestaurantModalSheet({super.key, required this.order});
  final Data order;

  @override
  State<RestaurantModalSheet> createState() => _RestaurantModalSheetState();
}

class _RestaurantModalSheetState extends State<RestaurantModalSheet> {
  final reviewController = Get.put(ReviewController());
  TextEditingController reviewTextController = TextEditingController();
  double rating = 0.0;

  @override
  void initState() {
    super.initState();
    rating = double.parse(
      reviewController.restaurantReview.value.data?.star.toString() ?? "0.0",
    );
    reviewTextController.text =
        reviewController.restaurantReview.value.data?.review ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
      ),
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                text: "WRITE_A_REIVEW_FOR_RESTAURANT".tr,
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ),

              SizedBox(height: 16.h),

              ListTile(
                leading: CircleAvatar(
                  radius: 24,
                  foregroundImage: NetworkImage(
                    widget.order.restaurant?.logo ?? "",
                  ),
                ),
                title: TextWidget(
                  text: "RESTAURANT".tr,
                  color: AppColor.black80,
                  fontSize: 14.sp,
                ),
                subtitle: TextWidget(
                  text: widget.order.restaurant?.name ?? "",
                  color: AppColor.black100,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),

              SizedBox(height: 24.h),
              TextWidget(text: "YOUR_RATING".tr, fontSize: 14.sp),
              RatingBar.builder(
                tapOnlyMode: true,
                unratedColor: AppColor.black40,
                initialRating: rating,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(2.r),
                    child: SvgPicture.asset(SvgIcon.star),
                  );
                },
                onRatingUpdate: (value) {
                  rating = value;
                },
              ),

              SizedBox(height: 16.h),

              TextWidget(text: "REVIEW_DETAILS".tr, fontSize: 14.sp),
              SizedBox(height: 8.h),
              TextFormField(
                controller: reviewTextController,
                maxLines: 4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: AppColor.black80),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: AppColor.black80),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: AppColor.black80),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: SubmitReviewButton(
                  onTap: () async {
                    if (rating == 0) {
                      return customSnackbar(
                        "ERROR".tr,
                        "THE_RATING_IS_REQUIRED".tr,
                        AppColor.rejectedTextColor,
                      );
                    }
                    if (reviewTextController.text.isEmpty) {
                      return customSnackbar(
                        "ERROR".tr,
                        "THE_REVIEW_FIELD_IS_REQUIRED".tr,
                        AppColor.rejectedTextColor,
                      );
                    }

                    await reviewController.submitRestaurantReview(
                      orderId: widget.order.id.toString(),
                      star: rating.toString(),
                      reviewText: reviewTextController.text,
                    );
                  },
                  text: Obx(
                    () => reviewController.submitReviewLoading.value
                        ? Center(
                            child: CircularProgressIndicator(
                              color: AppColor.whiteColor,
                            ),
                          )
                        : TextWidget(
                            text: "SUBMIT_REVIEW".tr,
                            color: AppColor.whiteColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                  ),
                  width: double.infinity,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
