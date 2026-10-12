import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tumrestoran/app/features/home/controller/home_controller.dart';
import 'package:tumrestoran/data/model/item_category_model.dart';
import 'package:tumrestoran/data/model/restuarant_model.dart';
import 'package:get/get.dart';

import '../../../../data/model/item_details_model.dart';
import '../../cart/widget/cart_modal_sheet.dart';
import '../controller/restaurant_details_controller.dart';
import '../widgets/item_card_list.dart';

class CategorySection extends StatelessWidget {
  final ItemCategoryDetails category;
  final HomeController homeController;
  final RestaurantDetailsController resDetailsController;

  final Restaurant restaurant;
  const CategorySection({
    super.key,
    required this.category,
    required this.homeController,
    required this.restaurant,
    required this.resDetailsController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            category.name ?? "",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Rubik',
            ),
          ),
        ),

        if (category.items == null || category.items!.isEmpty)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 8.h),
                Text(
                  "ITEM_NOT_FOUND".tr,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'Rubik',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          )
        else
          ...category.items!.map(
            (p) => Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: ItemCardList(
                isSingleOffer: homeController.isSingleOfferAvailable,
                singleOfferPercentage:
                    homeController.checkSingleOfferModel.value.data?.amount ??
                    0,
                image: p.thumb,
                title: p.name,
                description: p.descriptionAlt,
                cautionName: p.name,
                caution: p.caution,
                originalPrice: p.convertPrice,
                convertedDiscountPrice: p.convertDiscountedPrice,
                currencyPrice: p.currencyPrice,
                currencyDiscountedPrice: p.currencyDiscountedPrice,
                itemSlug: p.slug,

                discountOption: p.discountOption ?? "",

                discountType: p.discountType.toString(),

                isHalal: p.halal.toString(),

                itemDetailsOnTap: () async {
                  if (resDetailsController.isModalOpen.value) return;
                  resDetailsController.isModalOpen.value = true;
                  await resDetailsController.getItemDetails(slug: p.slug!);

                  await showModalBottomSheet(
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    // ignore: use_build_context_synchronously
                    context: context,
                    builder: (context) {
                      final screenHeight = MediaQuery.of(context).size.height;

                      return ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: screenHeight * 0.9,
                        ),
                        child: Padding(
                          padding: MediaQuery.viewInsetsOf(context),
                          child: CartModalSheet(
                            isSingleOffer:
                                homeController.isSingleOfferAvailable,
                            singleOfferPercentage:
                                homeController
                                    .checkSingleOfferModel
                                    .value
                                    .data
                                    ?.amount ??
                                0,
                            discountType: p.discountType.toString(),
                            item:
                                resDetailsController.itemDetails.value.data ??
                                MainItem(),
                            restaurant: restaurant,
                          ),
                        ),
                      );
                    },
                  ).whenComplete(() {
                    resDetailsController.isModalOpen.value = false;
                  });
                },
              ),
            ),
          ),
      ],
    );
  }
}
