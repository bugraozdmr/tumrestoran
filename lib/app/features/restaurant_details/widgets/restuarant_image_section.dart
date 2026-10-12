import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodnanny/app/features/favorite/controller/favorite_controller.dart';
import 'package:foodnanny/app/features/restaurant_details/widgets/custom_cliper.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../utils/svg_icon.dart';

class RestuarantImageSection extends StatelessWidget {
  const RestuarantImageSection({
    super.key,
    required this.cover,
    required this.logo,

    this.favTap,
    required this.restaurantId,
    required this.favorite,
  });

  final String cover;
  final String logo;
  final int restaurantId;
  final bool favorite;
  final void Function()? favTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: Customshape(),
          child: CachedNetworkImage(
            imageUrl: cover,
            imageBuilder:
                (context, imageProvider) => Container(
                  height: 180.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                height: 32.h,
                                width: 32.w,
                                decoration: const BoxDecoration(
                                  color: AppColor.whiteColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: SvgPicture.asset(SvgIcon.arrowLeft),
                                ),
                              ),
                            ),
                            Obx(
                              () => Container(
                                height: 32.h,
                                width: 32.w,
                                decoration: const BoxDecoration(
                                  color: AppColor.whiteColor,
                                  shape: BoxShape.circle,
                                ),
                                child: GestureDetector(
                                  onTap: favTap,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.r),
                                    child: SvgPicture.asset(
                                      Get.find<FavoriteController>().isFavorite(
                                            restaurantId: restaurantId,
                                            modelValue: favorite,
                                          )
                                          ? SvgIcon.heartBold
                                          : SvgIcon.heart,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            placeholder:
                (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 180.w,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.r),
                        topRight: Radius.circular(15.r),
                      ),
                    ),
                  ),
                ),
            errorWidget:
                (context, url, error) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 180.w,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.r),
                        topRight: Radius.circular(15.r),
                      ),
                    ),
                  ),
                ),
          ),
        ),
        Positioned(
          bottom: 0.h,
          left: 16.w,
          child: CachedNetworkImage(
            imageUrl: logo,
            imageBuilder:
                (context, imageProvider) => Container(
                  height: 48.h,
                  width: 48.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.whiteColor,
                    image: DecorationImage(image: imageProvider),
                  ),
                ),
            placeholder:
                (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 48.h,
                    width: 48.w,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.r),
                        topRight: Radius.circular(15.r),
                      ),
                    ),
                  ),
                ),
            errorWidget:
                (context, url, error) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 48.h,
                    width: 48.w,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.r),
                        topRight: Radius.circular(15.r),
                      ),
                    ),
                  ),
                ),
          ),
        ),
      ],
    );
  }
}
