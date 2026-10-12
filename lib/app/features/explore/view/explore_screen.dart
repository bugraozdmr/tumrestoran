import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodnanny/app/features/explore/controller/explore_controller.dart';
import 'package:foodnanny/app/features/favorite/controller/favorite_controller.dart';
import 'package:foodnanny/config/theme/app_color.dart';
import 'package:foodnanny/utils/svg_icon.dart';
import 'package:foodnanny/widgets/shimmer/home_shimmer/all_restaurant_shimmer.dart';
import 'package:foodnanny/widgets/title_text.dart';
import 'package:get/get.dart';
import '../../../../main.dart';
import '../../../../widgets/item/item.dart';
import '../../../../widgets/text_widget.dart';
import '../../address/controller/address_controller.dart';
import '../../auth/view/login_screen.dart';
import '../../restaurant_details/view/restuarant_details_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final exploreController = Get.put(ExploreController());
  final addressController = Get.put(AddressController());
  bool searchIcon = false;
  final favoriteController = Get.find<FavoriteController>();

  @override
  void initState() {
    super.initState();
    addressController.getAddresses();
    exploreController.getAllRestuarantBySearch(
      lat: box.read('pickedLat') ?? '',
      long: box.read('pickedLong') ?? '',
      deliveryOrderType: "5",
      query: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        extendBody: true,

        resizeToAvoidBottomInset: false,
        backgroundColor: AppColor.whiteColor,
        body: Padding(
          padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              /*------ [ Search ] -----------*/
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: TextFormField(
                    controller: exploreController.searchController,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        setState(() {
                          searchIcon = true;
                        });
                      } else {
                        setState(() {
                          searchIcon = false;
                        });
                      }

                      exploreController.getAllRestuarantBySearch(
                        lat: box.read('pickedLat') ?? '',
                        long: box.read('pickedLong') ?? '',
                        deliveryOrderType: "5",
                        query: exploreController.searchController.text,
                      );
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 16.h, bottom: 16.h),
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(15.r),
                        child: SvgPicture.asset(
                          SvgIcon.searchNormal,
                          colorFilter: ColorFilter.mode(
                            AppColor.black80,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      fillColor: AppColor.background,
                      filled: true,
                      border: InputBorder.none,
                      hintText: "SEARCH_RESTAURANT_OR_FOOD".tr,
                      suffixIcon: searchIcon == true
                          ? GestureDetector(
                              onTap: () {
                                exploreController.searchController.clear();
                                exploreController.getAllRestuarantBySearch(
                                  lat: box.read('pickedLat') ?? '',
                                  long: box.read('pickedLong') ?? '',
                                  deliveryOrderType: "5",
                                  query: '',
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.all(15.r),
                                child: SvgPicture.asset(
                                  SvgIcon.closeCircleSolid,
                                ),
                              ),
                            )
                          : SizedBox(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Obx(
                () => TitleText(
                  text:
                      '${exploreController.searchResultList.length} ${exploreController.searchController.text.isNotEmpty ? '${'RESTAURANT_MATCH'.tr} ' : 'RESTAURANTS'.tr}'
                      '${exploreController.searchController.text.isNotEmpty ? ' "${exploreController.searchController.text}"' : ''}',
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(height: 12.h),
              Expanded(
                child: Obx(
                  () => exploreController.restaurantLoader.value == false
                      ? exploreController.searchResultList.isNotEmpty
                            ? RefreshIndicator(
                                color: AppColor.primaryColor,
                                onRefresh: () async {
                                  exploreController.getAllRestuarantBySearch(
                                    lat: box.read('pickedLat') ?? '',
                                    long: box.read('pickedLong') ?? '',
                                    deliveryOrderType: "5",
                                    query: '',
                                  );
                                },
                                child: ListView.builder(
                                  padding: EdgeInsets.only(
                                    bottom:
                                        MediaQuery.of(
                                              context,
                                            ).viewInsets.bottom >
                                            0
                                        ? 0
                                        : 0.h,
                                  ),
                                  shrinkWrap: true,

                                  itemCount:
                                      exploreController.searchResultList.length,
                                  itemBuilder: (context, index) {
                                    var restaurent = exploreController
                                        .searchResultList[index];
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 16.h),
                                      child: ItemWidget(
                                        restaurantOfferText: restaurent.amount
                                            .toString(),
                                        isClosed: restaurent.availability == 10
                                            ? true
                                            : false,
                                        restaurant: restaurent,
                                        favTap: () async {
                                          if (box.read('isLoggedIn')) {
                                            await favoriteController
                                                .toggleFavorite(
                                                  restaurantId: restaurent.id!,
                                                  favorite:
                                                      restaurent.favorite ??
                                                      false,
                                                );
                                          } else {
                                            Get.to(() => LoginScreen());
                                          }
                                        },
                                        onTap: () {
                                          Get.to(
                                            () => RestuarantDetailsScreen(
                                              restaurant: restaurent,
                                            ),
                                          );
                                        },
                                        width: double.infinity,
                                      ),
                                    );
                                  },
                                ),
                              )
                            : SingleChildScrollView(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 120.h),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        SvgPicture.asset(
                                          SvgIcon.empty,
                                          height: 180.h,
                                          width: 186.w,
                                        ),
                                        SizedBox(height: 24.h),
                                        TextWidget(
                                          text: 'NO_FOOD_OR_RESTAURNT'.tr,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.sp,
                                          color: AppColor.black100,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                      : SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.only(
                              top:
                                  exploreController.restaurantLoader.value ==
                                      false
                                  ? 0.h
                                  : 0,
                            ),
                            child: Center(
                              child: Column(children: [AllRestaurantShimmer()]),
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
