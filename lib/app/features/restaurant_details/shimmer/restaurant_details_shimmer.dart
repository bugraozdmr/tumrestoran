import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tumrestoran/widgets/shimmer/resturant_details_shimmer/restuarant_item_card_shimmer.dart';

import '../../../../widgets/shimmer/resturant_details_shimmer/available_deals_shimmer.dart';
import '../../../../widgets/shimmer/resturant_details_shimmer/restaurant_details_section_shimmer.dart';
import '../../../../widgets/shimmer/resturant_details_shimmer/restaurant_image_section_shimmer.dart';
import '../../../../widgets/shimmer/resturant_details_shimmer/restaurant_menu_title_shimmer.dart'
    show RestaurantMenuTitleShimmer;
import '../../../../widgets/shimmer/resturant_details_shimmer/restuarant_menu_shimmer.dart';

class RestaurantDetailsShimmer extends StatelessWidget {
  const RestaurantDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            RestaurantImageSectionShimmer(),
            SizedBox(height: 24.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  RestaurantDeliverySectionShimmer(),
                  SizedBox(height: 24.h),
                  AvailableDealsShimmer(),
                  SizedBox(height: 24.h),
                  RestaurantMenuTitleShimmer(),
                  SizedBox(height: 24.h),

                  RestuarantMenuShimmer(),
                  SizedBox(height: 16.h),

                  RestaurantItemCardShimmer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
