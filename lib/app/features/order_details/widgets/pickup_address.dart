import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tumrestoran/data/model/order_details_model.dart';
import 'package:tumrestoran/widgets/text_widget.dart';
import 'package:get/route_manager.dart';
import 'package:get/utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../utils/svg_icon.dart';
import '../../../../widgets/normal_text.dart';

class RestaurentAddressWidget extends StatefulWidget {
  const RestaurentAddressWidget({super.key, required this.restaurant});
  final Data restaurant;

  @override
  State<RestaurentAddressWidget> createState() =>
      _RestaurentAddressWidgetState();
}

class _RestaurentAddressWidgetState extends State<RestaurentAddressWidget> {
  GoogleMapController? mapController;
  final Set<Marker> _markers = {};
  @override
  Widget build(BuildContext context) {
    final cityZipState =
        "${widget.restaurant.restaurant?.city ?? ""} ${widget.restaurant.restaurant?.zipCode}  ${widget.restaurant.restaurant?.state}";
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.black100.withValues(alpha: 0.04),
            offset: Offset(0, 6),
            blurRadius: 32.r,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [
            Row(
              children: [
                NormalText(
                  text: "RESTAURANT_ADDRESS".tr,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Row(
                    children: [
                      SvgPicture.asset(SvgIcon.shop, height: 24.h),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            NormalText(
                              text: widget.restaurant.restaurant?.address ?? '',
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                            ),
                            if (cityZipState.isNotEmpty)
                              NormalText(
                                text: cityZipState,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      Get.dialog(
                        ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: 300.h),
                          child: Material(
                            color: Colors.transparent,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.r,
                                vertical: 24.h,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    double mapHeight =
                                        constraints.maxHeight * 0.8;

                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 16.w,
                                            vertical: 12.h,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              TextWidget(
                                                text: "ADDRESS".tr,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.sp,
                                              ),
                                              GestureDetector(
                                                onTap: () => Get.back(),
                                                child: SvgPicture.asset(
                                                  SvgIcon.closeCircle,
                                                  height: 20.h,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        SizedBox(height: 8.h),

                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              12.r,
                                            ),
                                            child: SizedBox(
                                              height: mapHeight,
                                              width: double.infinity,
                                              child: Container(
                                                color: AppColor.primaryLight,
                                                child: Center(
                                                  child: Icon(Icons.location_on, color: AppColor.primaryColor, size: 40),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    child: SvgPicture.asset(
                      SvgIcon.restaurantGroup,
                      height: 40.h,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
