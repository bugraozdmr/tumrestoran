import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodnanny/app/features/restaurant_details/view/restuarant_details_screen.dart';
import 'package:foodnanny/config/theme/app_color.dart';
import 'package:foodnanny/utils/svg_icon.dart';
import 'package:foodnanny/widgets/appbar_widget.dart';
import 'package:foodnanny/widgets/item/item.dart';
import 'package:foodnanny/widgets/loader/loader.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../../utils/images.dart';
import '../../auth/view/login_screen.dart';
import '../controller/favorite_controller.dart';

class MyFavoriteScreen extends StatefulWidget {
  const MyFavoriteScreen({super.key});

  @override
  State<MyFavoriteScreen> createState() => _MyFavoriteScreenState();
}

class _MyFavoriteScreenState extends State<MyFavoriteScreen> {
  final FavoriteController controller = Get.find<FavoriteController>();

  @override
  void initState() {
    super.initState();
    controller.getFavoriteRestaurants();
    controller.loadMoreFavorite();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBarWidget(
        isIcon: true,
        iconButton: IconButton(
          icon: Container(
            height: 24.h,
            width: 24.w,
            decoration: BoxDecoration(
              color: AppColor.whiteColor,
              shape: BoxShape.circle,
              border: Border.all(color: AppColor.primaryColor),
            ),
            child: Padding(
              padding: EdgeInsets.all(4.r),
              child: SvgPicture.asset(
                SvgIcon.arrowLeftCircle,
                height: 24.h,
                width: 24.w,
                colorFilter: ColorFilter.mode(
                  AppColor.primaryColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          onPressed: () {
            Get.back();
          },
        ),
        text: "FAVORITE_RESTAURANTS".tr,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 20.h),
        child: Column(
          children: [
            Obx(() {
              if (controller.favoriteLoader.value) {
                return Center(
                  child: Column(
                    children: [
                      SizedBox(height: 220.h),
                      LoaderCircle(),
                    ],
                  ),
                );
              }
              if (controller.favoriteRestaurants.isEmpty) {
                return Center(
                  child: Column(
                    children: [
                      SizedBox(height: 140.h),
                      Image.asset(AppImages.emptyRestaurant, height: 140.h),

                      Text(
                        "NO_RESTAURANTS_FOUND".tr,
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontSize: 14.sp,
                          color: AppColor.black80,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Expanded(
                child: RefreshIndicator(
                  color: AppColor.primaryColor,
                  onRefresh: () async {
                    controller.getFavoriteRestaurants(isRefresh: true);
                  },
                  child: GridView.builder(
                    controller: controller.scrollController,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1.35, // width/height ratio
                        ),
                    itemCount:
                        controller.favoriteRestaurants.length +
                        (controller.isFetching ? 1 : 0),
                    itemBuilder: (context, index) {
                      final restaurant = controller.favoriteRestaurants[index];
                      if (index == controller.favoriteRestaurants.length) {
                        return controller.isFetching
                            ? const Center(child: LoaderCircle())
                            : const SizedBox.shrink();
                      }
                      return ItemWidget(
                        restaurantOfferText: "0",
                        isClosed: restaurant.availability == 10 ? true : false,
                        onTap: () {
                          Get.to(
                            () =>
                                RestuarantDetailsScreen(restaurant: restaurant),
                          );
                        },
                        favTap: () async {
                          if (box.read('isLoggedIn')) {
                            await controller.toggleFavorite(
                              restaurantId: restaurant.id!,
                              favorite: restaurant.favorite!,
                            );
                            await controller.getFavoriteRestaurants();
                          } else {
                            Get.to(() => LoginScreen());
                          }
                        },
                        restaurant: controller.favoriteRestaurants[index],
                      );
                    },
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
