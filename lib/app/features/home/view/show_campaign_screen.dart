import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tumrestoran/app/features/favorite/controller/favorite_controller.dart';
import 'package:tumrestoran/app/features/home/controller/home_controller.dart';
import 'package:tumrestoran/app/features/restaurant_details/view/restuarant_details_screen.dart';
import 'package:tumrestoran/app/features/restaurant_details/widgets/circle_icon_button.dart';
import 'package:tumrestoran/config/theme/app_color.dart';
import 'package:tumrestoran/main.dart';
import 'package:tumrestoran/utils/style.dart';
import 'package:tumrestoran/widgets/item/item.dart';
import 'package:tumrestoran/widgets/loader/loader.dart';
import 'package:get/get.dart';
import '../../../../utils/svg_icon.dart';
import '../../auth/view/login_screen.dart';
import '../../cart/controller/cart_controller.dart';
import '../widgets/campaing_info_dialog.dart';

class ShowCampaignScreen extends StatefulWidget {
  const ShowCampaignScreen({
    super.key,
    required this.slug,
    required this.cover,
    required this.bannerType,
  });

  final String slug;
  final String cover;
  final BannerType bannerType;

  @override
  State<ShowCampaignScreen> createState() => _ShowCampaignScreenState();
}

class _ShowCampaignScreenState extends State<ShowCampaignScreen> {
  final homeController = Get.find<HomeController>();
  final cartController = Get.find<CartController>();

  @override
  void initState() {
    super.initState();
    if (widget.bannerType == BannerType.offer) {
      homeController.showOffer(
        slug: widget.slug,
        lat: box.read('pickedLat') ?? '',
        long: box.read('pickedLong') ?? '',
        deliveryOrderType: cartController.isDeliver.value ? "5" : "10",
      );
    } else {
      homeController.showCampaign(
        slug: widget.slug,
        lat: box.read('pickedLat') ?? '',
        long: box.read('pickedLong') ?? '',
        deliveryOrderType: cartController.isDeliver.value ? "5" : "10",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Scaffold(
            backgroundColor: AppColor.whiteColor,
            appBar: AppBar(
              backgroundColor: AppColor.whiteColor,
              surfaceTintColor: AppColor.whiteColor,

              leading: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: EdgeInsets.all(12.r),
                  child: SvgPicture.asset(SvgIcon.arrowLeft),
                ),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.only(left: 16.w, right: 16.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: widget.cover,
                            height: 140.h,
                            width: double.infinity,
                            fit: BoxFit.fill,
                          ),

                          Positioned(
                            top: 8.h,
                            right: 8.w,
                            child: CircleIconButton(
                              icon: SvgIcon.infoCircle,
                              iconColor: AppColor.rejectedTextColor,
                              backgroundColor: AppColor.whiteColor,
                              onTap: () async {
                                await campaignInfoDialog(
                                  homeController.campaignInfoModel.value,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),
                    Text(
                      'AVAILABLE_RESTAURANT'.trParams({
                        'number': homeController.restaurantList.length
                            .toString(),
                      }),
                      style: title18,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: homeController.restaurantList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: ItemWidget(
                            restaurantOfferText: homeController
                                .restaurantList[index]
                                .amount
                                .toString(),
                            favTap: () async {
                              if (box.read('isLoggedIn')) {
                                await Get.find<FavoriteController>()
                                    .toggleFavorite(
                                      restaurantId: homeController
                                          .restaurantList[index]
                                          .id!,
                                      favorite:
                                          homeController
                                              .restaurantList[index]
                                              .favorite ??
                                          false,
                                    );
                              } else {
                                Get.to(() => LoginScreen());
                              }
                            },
                            onTap: () {
                              Get.to(
                                () => RestuarantDetailsScreen(
                                  restaurant:
                                      homeController.restaurantList[index],
                                ),
                              );
                            },
                            restaurant: homeController.restaurantList[index],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          homeController.showCampaignLoader.value
              ? Center(child: LoaderCircle())
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
