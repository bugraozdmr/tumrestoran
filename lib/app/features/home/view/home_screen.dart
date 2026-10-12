import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodnanny/app/features/address/controller/address_controller.dart';
import 'package:foodnanny/app/features/auth/view/login_screen.dart';
import 'package:foodnanny/app/features/cart/controller/cart_controller.dart';
import 'package:foodnanny/app/features/favorite/controller/favorite_controller.dart';
import 'package:foodnanny/app/features/home/controller/home_controller.dart';
import 'package:foodnanny/app/features/home/view/show_campaign_screen.dart';
import 'package:foodnanny/app/features/home/widgets/custom_app_bar.dart';
import 'package:foodnanny/app/features/order_history/controller/order_history_controller.dart';
import 'package:foodnanny/app/features/profile/controller/profile_controller.dart';
import 'package:foodnanny/config/theme/app_color.dart';
import 'package:foodnanny/data/model/campaign_model.dart';
import 'package:foodnanny/main.dart';
import 'package:foodnanny/utils/helper/limit_text.dart';
import 'package:foodnanny/utils/style.dart';
import 'package:foodnanny/widgets/shimmer/home_shimmer/all_restaurant_shimmer.dart';
import 'package:foodnanny/widgets/shimmer/home_shimmer/cuisin_shimmer.dart';
import 'package:foodnanny/widgets/shimmer/home_shimmer/offer_widget_shimmer.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../utils/images.dart';
import '../../../../widgets/text_widget.dart';
import '../../../localization/controller/language_controller.dart';
import '../../restaurant_details/view/restuarant_details_screen.dart';
import '../widgets/active_order_status.dart';
import '../widgets/location_bottom_modal.dart';
import '../../../../widgets/item/item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController homeController = Get.put(HomeController());
  final addressController = Get.put(AddressController());
  final cartController = Get.find<CartController>();
  final favoriteController = Get.find<FavoriteController>();
  final orderHistoryController = Get.put(OrderHistoryController());
  final showCampaingInfoModel = CampaingModel().obs;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.put(ProfileController());
      Get.put(LanguageController());

      homeRefresher();

      addressController.selectedHomeAddress.value =
          box.read('pickAddress') ?? 'Konum Belirtilmedi';

      orderHistoryController.getCurrentlyActiveOrder();
    });
  }

  homeRefresher() async {
    homeController.selectedMenu.value = -1;

    Future.wait([
      addressController.getAddresses(),
      homeController.getSingleOfferRestaurants(
        lat: box.read('pickedLat') ?? '',
        long: box.read('pickedLong') ?? '',
        deliveryOrderType: cartController.isDeliver.value ? "5" : "10",
      ),
      homeController.getAllRestuarantByLatLong(
        lat: box.read('pickedLat') ?? '',
        long: box.read('pickedLong') ?? '',
        deliveryOrderType: cartController.isDeliver.value ? "5" : "10",
      ),
      homeController.getQuisine(),
      homeController.getCampaignsAndOffer(
        lat: box.read('pickedLat') ?? '',
        long: box.read('pickedLong') ?? '',
        deliveryOrderType: cartController.isDeliver.value ? "5" : "10",
      ),
    ]);
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
      child: Stack(
        children: [
          Scaffold(
            extendBody: true,
            backgroundColor: AppColor.whiteColor,
            appBar: CustomAppBar(
              onTap: () async {
                await locationBottomSheet(context);
              },
              pickedAddress: addressController.pickAddress,
            ),
            body: RefreshIndicator(
              color: AppColor.primaryColor,
              onRefresh: () async {
                orderHistoryController.getCurrentlyActiveOrder();

                await homeRefresher();
              },
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),
                    Padding(
                      padding: EdgeInsets.only(left: 16.w),
                      child: SizedBox(
                        height: 80.h,
                        child: Obx(
                          () => homeController.quisineList.isEmpty
                              ? const CuisinShimmer()
                              : ListView.builder(
                                  padding: EdgeInsets.zero,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: homeController.quisineList.length,
                                  itemBuilder: (context, index) {
                                    final quisineId = homeController
                                        .quisineList[index]
                                        .id
                                        .toString();
                                    return Padding(
                                      padding: EdgeInsets.only(right: 24.w),
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              homeController.seletectMenu(
                                                index,
                                              );

                                              if (homeController
                                                      .selectedMenu
                                                      .value ==
                                                  index) {
                                                await homeController
                                                    .getRestaurantByQuisineId(
                                                      lat: box.read(
                                                        'pickedLat',
                                                      ),
                                                      long: box.read(
                                                        'pickedLong',
                                                      ),
                                                      deliveryOrderType: "5",
                                                      quisineId: quisineId,
                                                    );
                                              } else {
                                                await homeController
                                                    .getAllRestuarantByLatLong(
                                                      lat: box.read(
                                                        'pickedLat',
                                                      ),
                                                      long: box.read(
                                                        'pickedLong',
                                                      ),
                                                      deliveryOrderType: "5",
                                                    );
                                              }
                                            },
                                            child: Obx(
                                              () => Container(
                                                height: 52.h,
                                                width: 52.w,
                                                decoration: BoxDecoration(
                                                  color: AppColor.background,
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color:
                                                        homeController
                                                                .selectedMenu
                                                                .value ==
                                                            index
                                                        ? AppColor.primaryColor
                                                        : AppColor.whiteColor,
                                                  ),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    CachedNetworkImage(
                                                      imageUrl:
                                                          homeController
                                                              .quisineList[index]
                                                              .image ??
                                                          "",
                                                      imageBuilder:
                                                          (
                                                            context,
                                                            imageProvider,
                                                          ) => Container(
                                                            height: 28.h,
                                                            width: 35.w,
                                                            decoration: BoxDecoration(
                                                              image: DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                              ),
                                                            ),
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            limitText(
                                              homeController
                                                      .quisineList[index]
                                                      .name ??
                                                  "",
                                            ),
                                            style: textNormal14,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ),
                    ),

                    Obx(() {
                      if (homeController.singleOfferLoader.value) {
                        return OfferWidgetShimmer();
                      }
                      if (homeController.sinlgeOfferRestaurants.isEmpty) {
                        return SizedBox.shrink();
                      }
                      return Padding(
                        padding: EdgeInsets.only(top: 16.h),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: 370.h),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColor.primaryColor.withValues(
                                alpha: 0.1,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 16.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 16.h,
                                      bottom: 16.h,
                                      left: 4.w,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              AppImages.giftPack,
                                              height: 42.h,
                                              width: 42.w,
                                              fit: BoxFit.cover,
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: 8.w),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextWidget(
                                              text: "GET_OFF".trParams({
                                                "amount":
                                                    "${homeController.singleOfferModel.value.data?.percentage}",
                                              }),
                                              color: AppColor.primaryColor,
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            SizedBox(height: 4.h),
                                            TextWidget(
                                              text: "UNTIL_TO".trParams({
                                                'start':
                                                    "${homeController.singleOfferModel.value.data?.startTime}",
                                                'end':
                                                    "${homeController.singleOfferModel.value.data?.endTime}",
                                              }),

                                              color: AppColor.primaryColor,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Expanded(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: homeController
                                          .sinlgeOfferRestaurants
                                          .length,
                                      itemBuilder: (context, index) {
                                        final singleOfferRestaurant =
                                            homeController
                                                .sinlgeOfferRestaurants[index];
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            right: 16.0,
                                          ),
                                          child: ItemWidget(
                                            height: 253.h,
                                            restaurantOfferText: 0.toString(),
                                            restaurant: singleOfferRestaurant,
                                            width: 251.w,
                                            onTap: () {
                                              Get.to(
                                                () => RestuarantDetailsScreen(
                                                  restaurant:
                                                      singleOfferRestaurant,
                                                ),
                                              );
                                            },
                                            favTap: () async {
                                              await favoriteController
                                                  .toggleFavorite(
                                                    restaurantId:
                                                        singleOfferRestaurant
                                                            .id ??
                                                        0,
                                                    favorite:
                                                        singleOfferRestaurant
                                                            .favorite ??
                                                        false,
                                                  );
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 16.h),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),

                    Obx(
                      () => homeController.bannerList.isEmpty
                          ? SizedBox()
                          : Padding(
                              padding: EdgeInsets.only(
                                left: 16.w,
                                top: 16.h,
                                bottom: 16.h,
                              ),
                              child: SizedBox(
                                height: 160.h,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: homeController.bannerList.length,
                                  itemBuilder: (context, index) {
                                    final banner = homeController.bannerList;
                                    return GestureDetector(
                                      onTap: () {
                                        Get.to(
                                          () => ShowCampaignScreen(
                                            slug: banner[index].data.slug ?? "",
                                            cover:
                                                banner[index].data.cover ?? "",
                                            bannerType: banner[index].type,
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 16.w),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                          child: SizedBox(
                                            height: 156.h,
                                            width: 304.w,
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  banner[index].data.thumb ??
                                                  "",
                                              fit: BoxFit.fill,
                                              placeholder: (context, url) =>
                                                  Shimmer.fromColors(
                                                    baseColor:
                                                        Colors.grey.shade300,
                                                    highlightColor:
                                                        Colors.grey.shade100,
                                                    child: Container(
                                                      height: 156.h,
                                                      width: 304.w,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                    ),

                    SizedBox(height: 24.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text("ALL_RESTAURANTS_NEARBY".tr, style: title18),
                    ),
                    SizedBox(height: 12.h),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Obx(() {
                        if (homeController.allResLoader.value) {
                          return const AllRestaurantShimmer();
                        }

                        final allRestaurants = homeController.restuarantModel;

                        if (allRestaurants.value.data == null ||
                            allRestaurants.value.data!.isEmpty) {
                          return SizedBox(
                            child: Center(
                              child: Column(
                                children: [
                                  SizedBox(height: 20.h),
                                  Image.asset(
                                    AppImages.emptyRestaurant,
                                    height: 140.h,
                                  ),

                                  Text(
                                    "NO_RESTAURANTS_FOUND".tr,
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: 14.sp,
                                      color: AppColor.black80,
                                    ),
                                  ),
                                  SizedBox(height: 40.h),
                                ],
                              ),
                            ),
                          );
                        }

                        final filteredList = allRestaurants.value.data!
                            .where((e) => e.availability == 5)
                            .toList();

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.only(top: 16.h),
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            final restaurant = filteredList[index];

                            return Padding(
                              padding: EdgeInsets.only(bottom: 16.h),
                              child: ItemWidget(
                                restaurantOfferText: restaurant.amount
                                    .toString(),
                                restaurant: restaurant,
                                favTap: () async {
                                  if (box.read('isLoggedIn')) {
                                    await favoriteController.toggleFavorite(
                                      restaurantId: restaurant.id!,
                                      favorite: restaurant.favorite!,
                                    );
                                  } else {
                                    Get.to(() => LoginScreen());
                                  }
                                },
                                onTap: () {
                                  Get.to(
                                    () => RestuarantDetailsScreen(
                                      restaurant: restaurant,
                                    ),
                                  );
                                },
                                width: double.infinity,
                              ),
                            );
                          },
                        );
                      }),
                    ),
                    SizedBox(height: 24.h),

                    Padding(
                      padding: EdgeInsets.only(left: 8.w, right: 8.w),
                      child: Obx(() {
                        if (homeController.restaurantLoader.value) {
                          return const AllRestaurantShimmer();
                        }
                        final unavailableRestaurants = homeController
                            .restuarantModel
                            .value
                            .data
                            ?.where((item) => item.availability == 10)
                            .toList();
                        if (unavailableRestaurants == null ||
                            unavailableRestaurants.isEmpty) {
                          return const SizedBox();
                        }
                        return Padding(
                          padding: EdgeInsets.only(
                            left: 8.w,
                            right: 8.w,
                            bottom: 36.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                child: Text(
                                  "CLOSED_FOR_NOW".tr,
                                  style: title18,
                                ),
                              ),
                              SizedBox(height: 12.h),
                              Column(
                                children: List.generate(
                                  unavailableRestaurants.length,
                                  (index) => Padding(
                                    padding: EdgeInsets.only(bottom: 16.h),
                                    child: ItemWidget(
                                      restaurantOfferText:
                                          unavailableRestaurants[index].amount
                                              .toString(),
                                      isClosed:
                                          unavailableRestaurants[index]
                                                  .availability ==
                                              10
                                          ? true
                                          : false,
                                      restaurant: unavailableRestaurants[index],
                                      favTap: () async {
                                        if (box.read('isLoggedIn')) {
                                          await favoriteController.toggleFavorite(
                                            restaurantId:
                                                unavailableRestaurants[index]
                                                    .id!,
                                            favorite:
                                                unavailableRestaurants[index]
                                                    .favorite!,
                                          );
                                        } else {
                                          Get.to(() => LoginScreen());
                                        }
                                      },
                                      onTap: () {
                                        Get.to(
                                          () => RestuarantDetailsScreen(
                                            restaurant:
                                                unavailableRestaurants[index],
                                          ),
                                        );
                                      },
                                      width: double.infinity,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),

                    Obx(
                      () => SizedBox(
                        height:
                            orderHistoryController
                                    .currentlyActiveOrder
                                    .isNotEmpty &&
                                box.read('isLoggedIn') == true
                            ? 80.h
                            : 0.h,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Obx(() {
            return orderHistoryController.currentlyActiveOrder.isNotEmpty &&
                    box.read('isLoggedIn') == true
                ? Positioned(
                    bottom: 0.h,
                    left: 0.w,
                    right: 0.w,
                    child: Material(child: const ActiveOrderStatus()),
                  )
                : SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
