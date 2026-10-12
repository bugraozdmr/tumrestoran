import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodnanny/app/features/cart/controller/cart_controller.dart';
import 'package:foodnanny/app/features/cart/views/cart_screen.dart';
import 'package:foodnanny/app/features/restaurant_details/controller/coupon_controller.dart';
import 'package:foodnanny/app/features/restaurant_details/controller/restaurant_details_controller.dart';
import 'package:foodnanny/app/features/restaurant_details/shimmer/restaurant_details_shimmer.dart';
import 'package:foodnanny/app/features/restaurant_details/view/category_header_deligate.dart';
import 'package:foodnanny/app/features/restaurant_details/view/category_section.dart';
import 'package:foodnanny/app/features/restaurant_details/widgets/restuarant_image_section.dart';
import 'package:foodnanny/data/model/restuarant_model.dart';
import 'package:foodnanny/data/model/show_coupon_model.dart';
import 'package:foodnanny/utils/helper/format_price_with_currency.dart';
import 'package:foodnanny/widgets/divider_widget.dart';
import 'package:foodnanny/widgets/shimmer/resturant_details_shimmer/available_deals_shimmer.dart';
import 'package:foodnanny/widgets/text_widget.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../main.dart';
import '../../../../utils/svg_icon.dart';
import '../../../../widgets/shimmer/resturant_details_shimmer/restaurant_details_section_shimmer.dart';
import '../../../../widgets/shimmer/resturant_details_shimmer/restaurant_image_section_shimmer.dart';
import '../../../../widgets/shimmer/resturant_details_shimmer/restaurant_menu_title_shimmer.dart';
import '../../../../widgets/shimmer/resturant_details_shimmer/restuarant_menu_shimmer.dart';
import '../../../../widgets/title_text.dart';
import '../../auth/view/login_screen.dart';
import '../../favorite/controller/favorite_controller.dart';
import '../../home/controller/home_controller.dart';
import '../widgets/circle_icon_button.dart';
import '../widgets/delivery_info_section.dart';

class RestuarantDetailsScreen extends StatefulWidget {
  const RestuarantDetailsScreen({super.key, this.restaurant});
  final Restaurant? restaurant;

  @override
  State<RestuarantDetailsScreen> createState() =>
      _RestuarantDetailsScreenState();
}

class _RestuarantDetailsScreenState extends State<RestuarantDetailsScreen>
    with SingleTickerProviderStateMixin {
  bool nonVegPress = false;
  bool vegPress = false;

  final resDetailsController = Get.put((RestaurantDetailsController()));
  final couponController = Get.put(CouponController());
  final favoriteController = Get.find<FavoriteController>();
  final homeController = Get.find<HomeController>();

  TabController? _tabController;
  final scrollController = ScrollController();
  final Map<int, GlobalKey> categoryKeys = {};

  bool isTabClicked = false;

  final GlobalKey _headerKey = GlobalKey();
  double? _cachedHeaderHeight;
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      initializeTabController();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initRestuarantDetails();
      _cacheHeaderHeight();
      resDetailsController.resetFilters();
    });

    scrollController.addListener(_onScroll);
  }

  void _cacheHeaderHeight() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _headerKey.currentContext;
      if (context != null) {
        final box = context.findRenderObject() as RenderBox?;
        if (box != null && box.hasSize) {
          setState(() {
            _cachedHeaderHeight = box.size.height;
          });
        }
      }
    });
  }

  initializeTabController() async {
    await resDetailsController.getRestaurantDetails(
      slug: widget.restaurant?.slug ?? "",
    );
    await resDetailsController.getItemCategoryDetails(
      slug: widget.restaurant?.slug ?? "",
    );

    final length =
        resDetailsController.itemCategoryDetails.value.data?.length ?? 0;
    if (length > 0) {
      _tabController = TabController(length: length, vsync: this);
      initCategoryKeys();
      setState(() {});
    }
  }

  initRestuarantDetails() async {
    Future.wait([
      homeController.checkSingleOffer(
        restaurantId: widget.restaurant?.id.toString() ?? "",
        lat: box.read('pickedLat') ?? '',
        long: box.read('pickedLong') ?? '',
      ),
      resDetailsController.getOfferForRestaurant(
        restaurantId: widget.restaurant?.id.toString() ?? "",
        lat: box.read('pickedLat') ?? '',
        long: box.read('pickedLong') ?? '',
      ),

      couponController.getCoupons(
        restaurantId: widget.restaurant!.id.toString(),
      ),
    ]);
  }

  void initCategoryKeys() {
    final dataList = resDetailsController.itemCategoryDetails.value.data ?? [];
    categoryKeys.clear();
    for (int i = 0; i < dataList.length; i++) {
      categoryKeys[i] = GlobalKey();
    }
  }

  void _onScroll() {
    if (isTabClicked) return;

    final keys = categoryKeys.entries.toList();
    if (keys.isEmpty) return;

    int currentTab = 0;
    final headerOffset = 140.h;

    for (int i = 0; i < keys.length; i++) {
      final key = keys[i].value;
      final context = key.currentContext;
      if (context == null) continue;

      final box = context.findRenderObject() as RenderBox?;
      if (box == null || !box.hasSize) continue;

      final position = box.localToGlobal(Offset.zero).dy;

      if (position <= headerOffset) {
        currentTab = i;
      } else {
        break;
      }
    }

    if (_tabController?.index != currentTab) {
      _tabController?.animateTo(currentTab);
    }
  }

  void _onTabTap(int tabIndex) async {
    final key = categoryKeys[tabIndex];
    if (key == null) return;

    setState(() {
      isTabClicked = true;
    });

    try {
      await Future.delayed(Duration(milliseconds: 100));

      double totalHeightBeforeTarget = 0;

      for (int i = 0; i < tabIndex; i++) {
        final prevKey = categoryKeys[i];
        if (prevKey == null) {
          continue;
        }

        final prevContext = prevKey.currentContext;
        if (prevContext == null) {
          continue;
        }

        // ignore: use_build_context_synchronously
        final prevBox = prevContext.findRenderObject() as RenderBox?;
        if (prevBox == null || !prevBox.hasSize) {
          continue;
        }

        final categoryHeight = prevBox.size.height;
        totalHeightBeforeTarget += categoryHeight;
      }

      final headerHeight = _cachedHeaderHeight ?? 600.0;

      final stickyTabBarHeight = 118.h;

      final targetScroll =
          headerHeight + totalHeightBeforeTarget - stickyTabBarHeight;

      await scrollController.animateTo(
        targetScroll.clamp(
          scrollController.position.minScrollExtent,
          scrollController.position.maxScrollExtent,
        ),
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );

      await Future.delayed(Duration(milliseconds: 550));
    } catch (e) {
      debugPrint('Tab scroll error: $e');
    } finally {
      if (mounted) {
        setState(() {
          isTabClicked = false;
        });
      }
    }
  }

  @override
  dispose() {
    _tabController?.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final categoryData = resDetailsController.itemCategoryDetails.value.data;

      if (categoryData == null || _tabController == null) {
        return Scaffold(
          backgroundColor: AppColor.whiteColor,
          body: RestaurantDetailsShimmer(),
        );
      }

      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: AppColor.whiteColor,
          body: SafeArea(
            child: RefreshIndicator(
              color: AppColor.primaryColor,
              onRefresh: () async {
                initRestuarantDetails();
              },
              child: Stack(
                children: [
                  CustomScrollView(
                    controller: scrollController,
                    physics: AlwaysScrollableScrollPhysics(),

                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            Obx(
                              () =>
                                  resDetailsController
                                              .restaurantDetails
                                              .value
                                              .data ==
                                          null ||
                                      _tabController == null
                                  ? const RestaurantImageSectionShimmer()
                                  : RestuarantImageSection(
                                      restaurantId: widget.restaurant!.id!,
                                      favorite:
                                          widget.restaurant!.favorite ?? false,
                                      favTap: () async {
                                        if (box.read('isLoggedIn')) {
                                          await favoriteController
                                              .toggleFavorite(
                                                restaurantId:
                                                    widget.restaurant!.id!,
                                                favorite:
                                                    widget
                                                        .restaurant!
                                                        .favorite ??
                                                    false,
                                              );
                                        } else {
                                          Get.to(() => LoginScreen());
                                        }
                                      },
                                      cover: resDetailsController
                                          .restaurantDetails
                                          .value
                                          .data!
                                          .cover!,
                                      logo: resDetailsController
                                          .restaurantDetails
                                          .value
                                          .data!
                                          .logo!,
                                    ),
                            ),
                            Column(
                              children: [
                                Obx(
                                  () =>
                                      resDetailsController
                                                  .restaurantDetails
                                                  .value
                                                  .data ==
                                              null ||
                                          _tabController == null
                                      ? const RestaurantDeliverySectionShimmer()
                                      : resDetailsController
                                                .fakeResDetailsInt
                                                .value ==
                                            -5
                                      ? const SizedBox()
                                      : Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 16.w,
                                          ),
                                          child: DeliveryInfoSection(
                                            restaurantController:
                                                resDetailsController,
                                            restaurantTitle:
                                                resDetailsController
                                                    .restaurantDetails
                                                    .value
                                                    .data
                                                    ?.name ??
                                                "",
                                            quisine:
                                                resDetailsController
                                                    .restaurantDetails
                                                    .value
                                                    .data
                                                    ?.cuisine ??
                                                "",
                                            distance: "",
                                            rating:
                                                resDetailsController
                                                    .restaurantDetails
                                                    .value
                                                    .data
                                                    ?.ratingStar
                                                    .toString() ??
                                                "0",
                                            totalRatings:
                                                resDetailsController
                                                        .restaurantDetails
                                                        .value
                                                        .data
                                                        ?.ratingStarCount
                                                        .toString() !=
                                                    "null"
                                                ? "(${resDetailsController.restaurantDetails.value.data?.ratingStarCount.toString()})"
                                                : "(0 ratings)",
                                            availability:
                                                resDetailsController
                                                        .restaurantDetails
                                                        .value
                                                        .data
                                                        ?.availability ==
                                                    5
                                                ? "OPEN_NOW".tr
                                                : "CLOSED".tr,
                                            today:
                                                resDetailsController
                                                    .restaurantDetails
                                                    .value
                                                    .data
                                                    ?.today ??
                                                "",
                                            deliveryTime:
                                                resDetailsController
                                                        .restaurantDetails
                                                        .value
                                                        .data
                                                        ?.singleTimeSlots
                                                        .toString() !=
                                                    "null"
                                                ? "${resDetailsController.restaurantDetails.value.data?.singleTimeSlots.toString()}"
                                                : "Tue, Aug 22, 4.30 AM - 11.30 PM",
                                            orderLimit:
                                                resDetailsController
                                                        .restaurantDetails
                                                        .value
                                                        .data
                                                        ?.orderSetup
                                                        ?.currencyMinimumOrderLimit !=
                                                    null
                                                ? resDetailsController
                                                      .restaurantDetails
                                                      .value
                                                      .data!
                                                      .orderSetup!
                                                      .currencyMinimumOrderLimit
                                                      .toString()
                                                : "",
                                          ),
                                        ),
                                ),
                                SizedBox(height: 16.h),
                                const Divider(color: AppColor.borderColor),

                                /*------------[ Availalbe Deals ]--------------- */
                                Obx(
                                  () =>
                                      couponController.couponModel.value.data ==
                                              null ||
                                          _tabController == null
                                      ? const AvailableDealsShimmer()
                                      : Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 16.w,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  TitleText(
                                                    text: "AVAILABLE_DEALS".tr,
                                                    fontSize: 16.sp,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8.h),
                                              SizedBox(
                                                height: 105.h,
                                                child: ListView.builder(
                                                  itemCount: couponController
                                                      .couponModel
                                                      .value
                                                      .data
                                                      ?.length,
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemBuilder: (context, index) {
                                                    final coupon =
                                                        couponController
                                                            .couponModel
                                                            .value
                                                            .data?[index];
                                                    return GestureDetector(
                                                      onTap: () async {
                                                        await couponController
                                                            .showCoupon(
                                                              couponId: coupon
                                                                  .id
                                                                  .toString(),
                                                            );

                                                        final showCoupon =
                                                            couponController
                                                                .showCouponModel
                                                                .value
                                                                .data;

                                                        await couponDialog(
                                                          showCoupon,
                                                        );
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                              right: 16.w,
                                                            ),
                                                        child: Container(
                                                          width: 213.w,
                                                          decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  8.r,
                                                                ),
                                                            border: Border.all(
                                                              color: AppColor
                                                                  .borderColor,
                                                            ),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                  left: 8.w,
                                                                  top: 8.h,
                                                                  right: 8.w,
                                                                ),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    SvgPicture.asset(
                                                                      coupon!.code!.contains(
                                                                                'freedelivery',
                                                                              ) ||
                                                                              coupon.type ==
                                                                                  10
                                                                          ? SvgIcon.bike
                                                                          : coupon.discountType ==
                                                                                10
                                                                          ? SvgIcon.discountShape
                                                                          : SvgIcon.ticketDiscount,

                                                                      colorFilter: ColorFilter.mode(
                                                                        AppColor
                                                                            .primaryColor,
                                                                        BlendMode
                                                                            .srcIn,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                          4.w,
                                                                    ),
                                                                    TextWidget(
                                                                      text:
                                                                          coupon.convertDiscount ==
                                                                              0
                                                                          ? coupon.name.toString()
                                                                          : 'OFFER_TEXT'.trParams({
                                                                              'value': coupon.discountAlt.toString(),
                                                                            }),
                                                                      color: AppColor
                                                                          .primaryColor,
                                                                      fontSize:
                                                                          14.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),

                                                                    SizedBox(
                                                                      width:
                                                                          4.w,
                                                                    ),
                                                                    Expanded(
                                                                      child: TextWidget(
                                                                        text:
                                                                            "(${coupon.code})",
                                                                        color: AppColor
                                                                            .black100,
                                                                        fontSize:
                                                                            14.sp,
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,

                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 7.h,
                                                                ),
                                                                TextWidget(
                                                                  text:
                                                                      coupon.code!.contains(
                                                                            'freedelivery',
                                                                          ) ||
                                                                          coupon.type ==
                                                                              10
                                                                      ? 'FREE_DELIVERY_INFO'.trParams({
                                                                          "minOrderAmount": coupon
                                                                              .minimumOrderCurrencyAmount
                                                                              .toString(),
                                                                        })
                                                                      : 'MINIMUM_ORDER_INFO'.trParams({
                                                                          "amount": coupon
                                                                              .discountAlt
                                                                              .toString(),
                                                                          "minOrderAmount": coupon
                                                                              .minimumOrderCurrencyAmount
                                                                              .toString(),
                                                                        }),
                                                                  fontSize:
                                                                      11.sp,
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                                TextWidget(
                                                                  text:
                                                                      "USE_IN_CHECKOUT"
                                                                          .tr,
                                                                  fontSize:
                                                                      12.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: AppColor
                                                                      .black80,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                ),
                                SizedBox(height: 16.h),
                                const DividerWidget(),
                                SizedBox(height: 12.h),
                                Obx(
                                  () =>
                                      resDetailsController
                                                  .itemCategoryDetails
                                                  .value
                                                  .data ==
                                              null ||
                                          _tabController == null
                                      ? const RestaurantMenuTitleShimmer()
                                      : Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 16.w,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,

                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              TitleText(
                                                text: "RESTAURANT_MENU".tr,
                                                fontSize: 16.sp,
                                              ),
                                              Obx(
                                                () =>
                                                    resDetailsController
                                                            .showSearch
                                                            .value ==
                                                        true
                                                    ? Container(
                                                        height: 40.h,
                                                        width: 180.w,
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                24.r,
                                                              ),
                                                          border: Border.all(
                                                            color: AppColor
                                                                .borderColor,
                                                          ),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            CircleIconButton(
                                                              icon: SvgIcon
                                                                  .searchNormal,
                                                              onTap: () {
                                                                resDetailsController
                                                                        .showSearch
                                                                        .value =
                                                                    !resDetailsController
                                                                        .showSearch
                                                                        .value;
                                                              },
                                                            ),
                                                            SizedBox(
                                                              width: 4.w,
                                                            ),
                                                            Expanded(
                                                              child: TextField(
                                                                decoration: InputDecoration(
                                                                  contentPadding:
                                                                      EdgeInsets.only(
                                                                        top:
                                                                            4.h,
                                                                        bottom:
                                                                            4.h,
                                                                      ),
                                                                  hintText:
                                                                      "SEARCH"
                                                                          .tr,
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                ),
                                                                onChanged: (searchText) {
                                                                  resDetailsController
                                                                          .searchQueryText
                                                                          .value =
                                                                      searchText;
                                                                  resDetailsController
                                                                      .searchMenuByName(
                                                                        searchText,
                                                                      );

                                                                  if (searchText
                                                                      .isEmpty) {
                                                                    resDetailsController
                                                                        .filteredItemCategoryList
                                                                        .clear();
                                                                  }
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : CircleIconButton(
                                                        icon: SvgIcon
                                                            .searchNormal,
                                                        onTap: () {
                                                          resDetailsController
                                                                  .showSearch
                                                                  .value =
                                                              !resDetailsController
                                                                  .showSearch
                                                                  .value;
                                                        },
                                                      ),
                                              ),
                                            ],
                                          ),
                                        ),
                                ),
                                Obx(() {
                                  if (resDetailsController
                                              .itemCategoryDetails
                                              .value
                                              .data ==
                                          null ||
                                      _tabController == null) {
                                    return RestuarantMenuShimmer();
                                  }

                                  if (resDetailsController
                                      .searchQueryText
                                      .value
                                      .isNotEmpty) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8.h,
                                        horizontal: 16.w,
                                      ),
                                      child: Row(
                                        children: [
                                          TextWidget(
                                            text: "WE_FOUND_RESULT_FOR"
                                                .trParams({
                                                  'result': resDetailsController
                                                      .filteredItemCategoryList
                                                      .length
                                                      .toString(),
                                                  'query': resDetailsController
                                                      .searchQueryText
                                                      .value,
                                                }),
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  return SizedBox.shrink();
                                }),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SliverPersistentHeader(
                        pinned: true,
                        delegate: CategoryHeaderDeligate(
                          resDetailsController: resDetailsController,
                          tabBar: TabBar(
                            controller: _tabController,
                            onTap: _onTabTap,
                            padding: EdgeInsets.zero,
                            isScrollable: true,
                            tabAlignment: TabAlignment.start,
                            unselectedLabelColor: AppColor.black100,
                            labelColor: AppColor.primaryColor,
                            indicatorColor: AppColor.primaryColor,
                            tabs: List.generate(
                              resDetailsController
                                      .itemCategoryDetails
                                      .value
                                      .data
                                      ?.length ??
                                  0,
                              (index) => Tab(
                                child: TextWidget(
                                  text: resDetailsController
                                      .itemCategoryDetails
                                      .value
                                      .data![index]
                                      .name!,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final originalData =
                                resDetailsController
                                    .filteredItemCategoryList
                                    .isEmpty
                                ? resDetailsController
                                      .itemCategoryDetails
                                      .value
                                      .data!
                                : resDetailsController.filteredItemCategoryList;
                            final category = originalData[index];

                            final shouldShow =
                                resDetailsController
                                    .filteredItemCategoryList
                                    .isEmpty ||
                                resDetailsController.filteredItemCategoryList
                                    .any(
                                      (filtered) => filtered.id == category.id,
                                    );

                            if (!shouldShow) {
                              return SizedBox.shrink();
                            }

                            return CategorySection(
                              key: categoryKeys[index],
                              category: category,
                              homeController: homeController,
                              restaurant: widget.restaurant!,
                              resDetailsController: resDetailsController,
                            );
                          },
                          childCount:
                              resDetailsController
                                  .filteredItemCategoryList
                                  .isNotEmpty
                              ? resDetailsController
                                    .filteredItemCategoryList
                                    .length
                              : resDetailsController
                                        .itemCategoryDetails
                                        .value
                                        .data
                                        ?.length ??
                                    1,
                        ),
                      ),

                      Get.find<CartController>().cartItems.isEmpty &&
                              Get.find<CartController>().addonCartList.isEmpty
                          ? SliverToBoxAdapter(child: SizedBox(height: 0.h))
                          : SliverToBoxAdapter(child: SizedBox(height: 100.h)),
                    ],
                  ),

                  Get.find<CartController>().cartItems.isEmpty &&
                          Get.find<CartController>().addonCartList.isEmpty
                      ? SizedBox.shrink()
                      : Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Material(
                            child: Container(
                              width: double.infinity,
                              height: 100.h,
                              color: AppColor.whiteColor,
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(() => CartScreen());
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 24.h,
                                  ),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: AppColor.primaryColor,
                                      borderRadius: BorderRadius.circular(25.r),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: 4.w,
                                        right: 12.w,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            height: 44.h,
                                            width: 44.w,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppColor.whiteColor,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(10.r),
                                              child: SvgPicture.asset(
                                                SvgIcon.cart,

                                                colorFilter: ColorFilter.mode(
                                                  AppColor.primaryColor,
                                                  BlendMode.srcIn,
                                                ),
                                              ),
                                            ),
                                          ),
                                          TextWidget(
                                            text: "VIEW_YOUR_CART".tr,
                                            color: AppColor.whiteColor,
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w500,
                                          ),

                                          TextWidget(
                                            text: formatPriceWithCurrency(
                                              Get.find<CartController>()
                                                      .totalPrice +
                                                  Get.find<CartController>()
                                                      .addonCartTotal,
                                            ).tr,
                                            color: AppColor.whiteColor,
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Future<dynamic> couponDialog(Data? showCoupon) {
    return Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        backgroundColor: AppColor.whiteColor,
        insetPadding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    text: "OFFER_DETAILS".tr,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: SvgPicture.asset(SvgIcon.closeCircle, height: 20.h),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        showCoupon!.code!.contains('freedelivery') ||
                                showCoupon.type == 10
                            ? SvgIcon.bike
                            : showCoupon.discountType == 10
                            ? SvgIcon.discountShape
                            : SvgIcon.ticketDiscount,

                        height: 24.h,
                        colorFilter: ColorFilter.mode(
                          AppColor.primaryColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 8.w),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              text:
                                  showCoupon.code!.contains('freedelivery') ||
                                      showCoupon.type == 10
                                  ? "${couponController.showCouponModel.value.data?.name}"
                                        " (${couponController.showCouponModel.value.data?.code})"
                                  : '${'OFFER_TEXT'.trParams({'value': showCoupon.discountAlt.toString()})} (${couponController.showCouponModel.value.data?.code})',
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              TextWidget(
                text: "NEW_AND_EXISTING_CUSTOMERS".tr,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              TextWidget(
                text: "VALID_FOR_ALL_ITEMS".tr,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              TextWidget(
                text: "VALID_DATE".trParams({
                  'date':
                      '${showCoupon.convertStartDate} - ${showCoupon.convertEndDate}',
                }).tr,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),

              Padding(
                padding: EdgeInsets.only(top: 12.h),
                child: TextWidget(
                  text: "MINIMUM_ORDER".trParams({
                    "amount": showCoupon.minimumOrderCurrencyAmount.toString(),
                  }),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              if (double.parse(showCoupon.maximumDiscount ?? "0.0") > 0)
                TextWidget(
                  text: "MAXIMUM_DISCOUNT".trParams({
                    "amount": showCoupon.maximumDiscountCurrencyAmount ?? "0.0",
                  }),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              SizedBox(height: 4.h),
              TextWidget(
                text: "USE_IN_CHECKOUT".tr,

                color: AppColor.primaryColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),

              if (showCoupon.description!.isNotEmpty)
                ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  childrenPadding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 4.h,
                  ),
                  title: TextWidget(
                    text: 'TERMS_AND_CONDITIONS'.tr,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [Html(data: showCoupon.description ?? "")],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
