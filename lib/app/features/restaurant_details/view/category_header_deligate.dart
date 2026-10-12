import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../utils/images.dart';
import '../../../../utils/svg_icon.dart';
import '../controller/restaurant_details_controller.dart';
import '../widgets/custom_chip.dart';

class CategoryHeaderDeligate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final RestaurantDetailsController resDetailsController;

  CategoryHeaderDeligate({
    required this.tabBar,
    required this.resDetailsController,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          tabBar,

          SizedBox(height: 12.h),

          SizedBox(
            height: 50.h,
            child: Obx(() {
              final hasData =
                  resDetailsController.itemCategoryDetails.value.data != null;

              if (!hasData) {
                return const SizedBox.shrink();
              }

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomChip(
                      onTap: () {
                        resDetailsController.vegPress.value = true;
                        resDetailsController.nonVegPress.value = false;
                        resDetailsController.filterByItemVegNonVeg(5);
                      },
                      isPressed: resDetailsController.vegPress.value,
                      iconImg: AppImages.veg,
                      label: "VEG".tr,
                      actionIcon: SvgIcon.closeCircle,
                      actionIconOnTap: () {
                        resDetailsController.vegPress.value = false;
                        resDetailsController.filteredItemCategoryList.clear();
                      },
                    ),

                    SizedBox(width: 16.w),

                    CustomChip(
                      onTap: () {
                        resDetailsController.nonVegPress.value = true;
                        resDetailsController.vegPress.value = false;
                        resDetailsController.filterByItemVegNonVeg(10);
                      },
                      isPressed: resDetailsController.nonVegPress.value,
                      iconImg: AppImages.nonVeg,
                      label: "NON_VEG".tr,
                      actionIcon: SvgIcon.closeCircle,
                      actionIconOnTap: () {
                        resDetailsController.nonVegPress.value = false;
                        resDetailsController.filteredItemCategoryList.clear();
                      },
                    ),
                  ],
                ),
              );
            }),
          ),

          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  @override
  double get maxExtent => _totalHeight;

  @override
  double get minExtent => _totalHeight;

  double get _totalHeight {
    final tabBarHeight = tabBar.preferredSize.height;
    final topSpacing = 12.h;
    final chipsContainerHeight = 50.h;
    final bottomSpacing = 8.h;

    final total =
        tabBarHeight + topSpacing + chipsContainerHeight + bottomSpacing;

    return total;
  }

  @override
  bool shouldRebuild(CategoryHeaderDeligate oldDelegate) {
    return oldDelegate.resDetailsController != resDetailsController;
  }
}
