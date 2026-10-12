import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tumrestoran/app/features/checkout/controller/checkout_controller.dart';
import 'package:tumrestoran/app/features/order_details/controller/order_details_controller.dart';
import 'package:tumrestoran/app/features/order_details/widgets/restaurant_modal_sheet.dart';
import 'package:tumrestoran/config/theme/app_color.dart';
import 'package:tumrestoran/utils/images.dart';
import 'package:tumrestoran/utils/svg_icon.dart';
import 'package:tumrestoran/widgets/appbar_widget.dart';
import 'package:tumrestoran/widgets/normal_text.dart';
import 'package:tumrestoran/widgets/text_widget.dart';
import 'package:get/get.dart';
import '../../../../widgets/divider_widget.dart';
import '../../../../widgets/loader/loader.dart';
import '../../bottom_navbar/controller/navbar_controller.dart';
import '../../bottom_navbar/views/bottom_navigation.dart';
import '../../cart/controller/cart_controller.dart';
import '../../profile/controller/profile_controller.dart';
import '../controller/review_controller.dart';
import '../widgets/delivery_address.dart';
import '../widgets/delivery_man.dart';
import '../widgets/order_item_widget.dart';
import '../widgets/pickup_address.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({
    super.key,
    required this.orderId,
    this.fromHome = false,
  });
  final String orderId;
  final bool fromHome;

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final orderDetailsController = Get.put(OrderDetailsController());
  final cartController = Get.find<CartController>();
  final checkoutController = Get.find<CheckoutController>();
  final reviewController = Get.put(ReviewController());

  @override
  void initState() {
    super.initState();
    initSetup();
  }

  initSetup() async {
    await Get.find<ProfileController>().getSettings();
    await orderDetailsController.getOrderDetails(id: widget.orderId.toString());

    if (orderDetailsController.orderDetailsModel.value.data?.status == 13) {
      await reviewController.getDeliveryBoyReview(
        orderId: widget.orderId.toString(),
      );
      await reviewController.getRestauantReview(
        orderId: widget.orderId.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              systemNavigationBarColor: Colors.white,
              systemNavigationBarIconBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.dark,
              statusBarColor: Colors.transparent,
              statusBarBrightness: Brightness.dark,
            ),
            child: Scaffold(
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
                    if (widget.fromHome) {
                      final navController = Get.put(NavbarController());
                      navController.changePage(0);
                      Get.off(() => const BottomNavigationScreen());
                    } else {
                      Get.back();
                    }
                  },
                ),
                text: "ORDER_DETAILS".tr,
              ),

              body: Obx(() {
                final order =
                    orderDetailsController.orderDetailsModel.value.data;

                if (order == null) {
                  return SizedBox.shrink();
                }

                return Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: RefreshIndicator(
                        color: AppColor.primaryColor,
                        onRefresh: () async {
                          await Get.find<ProfileController>().getSettings();

                          await orderDetailsController.getOrderDetails(
                            id: widget.orderId.toString(),
                          );
                          await reviewController.getRestauantReview(
                            orderId: widget.orderId.toString(),
                          );
                          await reviewController.getDeliveryBoyReview(
                            orderId: widget.orderId.toString(),
                          );
                        },
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              orderDetailsInfo(),

                              SizedBox(height: 24.h),

                              OrderGifAndTimeSection(
                                orderDetailsController: orderDetailsController,
                              ),

                              if (order.status != 16 &&
                                  order.status != 19 &&
                                  order.status != 22)
                                OrderTrackingSection(
                                  orderDetailsController:
                                      orderDetailsController,
                                ),

                              if (order.deliveryBoy != null &&
                                  order.status != 22)
                                Padding(
                                  padding: EdgeInsets.only(top: 16.h),
                                  child: DeliveryManWidget(orderData: order),
                                ),

                              SizedBox(height: 16.h),

                              DeliveryPickupAddressSection(
                                orderDetailsController: orderDetailsController,
                              ),

                              if (order.reason.toString() != "null" &&
                                  order.status != 22)
                                Padding(
                                  padding: EdgeInsets.only(bottom: 16.h),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: AppColor.whiteColor,
                                      borderRadius: BorderRadius.circular(16.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColor.black100.withValues(
                                            alpha: 0.04,
                                          ),
                                          offset: Offset(0, 6),
                                          blurRadius: 32.r,
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                        vertical: 16.h,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextWidget(
                                            text: "REASON".tr,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          TextWidget(
                                            text: order.reason,
                                            fontSize: 14.sp,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                              PaymentInfoCardSection(
                                orderDetailsController: orderDetailsController,
                              ),

                              SizedBox(height: 16.h),

                              orderDetailsItemCartSection(),

                              SizedBox(height: 28.h),

                              if (order.status == 1)
                                GestureDetector(
                                  onTap: () async {
                                    await orderDetailsController.orderCancel(
                                      id: int.parse(widget.orderId),
                                    );
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 28.h),
                                    child: Container(
                                      height: 48.h,
                                      width: 328.w,
                                      decoration: BoxDecoration(
                                        color: AppColor.negativeDark,
                                        borderRadius: BorderRadius.circular(
                                          24.r,
                                        ),
                                      ),
                                      child: Center(
                                        child: NormalText(
                                          text: "CANCEL_ORDER".tr,
                                          color: AppColor.whiteColor,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                              SizedBox(height: 24.h),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),

          orderDetailsController.orderDetailsLoader.value == true ||
                  orderDetailsController.orderCancelLoader.value == true
              ? Positioned(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white60,
                    child: const Center(child: LoaderCircle()),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Container orderDetailsItemCartSection() {
    return Container(
      width: 328.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: AppColor.whiteColor,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NormalText(
              text: "ORDER_DETAILS".tr,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: AppColor.black100,
            ),
            SizedBox(height: 24.h),

            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount:
                  orderDetailsController
                      .orderDetailsModel
                      .value
                      .data!
                      .orderItems
                      ?.length ??
                  0,
              itemBuilder: (context, index) {
                return OrderItemWidget(
                  order: orderDetailsController
                      .orderDetailsModel
                      .value
                      .data!
                      .orderItems?[index],
                  index: index,
                  length: orderDetailsController
                      .orderDetailsModel
                      .value
                      .data!
                      .orderItems
                      ?.length,
                );
              },
            ),
            const DividerWidget(),
            SizedBox(height: 16.h),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColor.black20),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 12.w,
                      right: 12.h,
                      top: 12.h,
                    ),
                    child: Column(
                      children: [
                        SummaryRow(
                          text: "SUBTOTAL".tr,
                          amount: orderDetailsController
                              .orderDetailsModel
                              .value
                              .data!
                              .subtotalCurrencyPrice
                              .toString(),
                        ),
                        SizedBox(height: 8.h),
                        SummaryRow(
                          text: "DELIVERY_FEE".tr,
                          amount: orderDetailsController
                              .orderDetailsModel
                              .value
                              .data!
                              .deliveryFeeCurrencyPrice
                              .toString(),
                          texColor: AppColor.positiveDark,
                        ),
                        SizedBox(height: 8.h),
                        SummaryRow(
                          text: "SERVICE_FEE".tr,
                          amount: orderDetailsController
                              .orderDetailsModel
                              .value
                              .data!
                              .serviceFeeCurrencyPrice
                              .toString(),
                        ),
                        SizedBox(height: 8.h),
                        SummaryRow(
                          text: "RIDER_TIP".tr,
                          amount: orderDetailsController
                              .orderDetailsModel
                              .value
                              .data!
                              .riderTipCurrencyPrice
                              .toString(),
                        ),
                        SizedBox(height: 8.h),

                        SummaryRow(
                          text: "TAX".tr,
                          amount: orderDetailsController
                              .orderDetailsModel
                              .value
                              .data!
                              .totalTaxCurrencyPrice
                              .toString(),
                        ),
                        SizedBox(height: 8.h),

                        SummaryRow(
                          text: "DISCOUNT".tr,
                          amount: orderDetailsController
                              .orderDetailsModel
                              .value
                              .data!
                              .discountCurrencyPrice
                              .toString(),
                        ),
                        SizedBox(height: 8.h),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),
                  const DottedDashedLine(
                    height: 0,
                    width: double.infinity,
                    axis: Axis.horizontal,
                    dashColor: AppColor.black20,
                  ),
                  SizedBox(height: 12.h),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: 12.h,
                      left: 12.w,
                      right: 12.w,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        NormalText(
                          text: "TOTAL".tr,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        NormalText(
                          text: orderDetailsController
                              .orderDetailsModel
                              .value
                              .data!
                              .totalCurrencyPrice
                              .toString(),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column orderDetailsInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            NormalText(
              text: "ORDER_ID:".tr,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
            NormalText(
              text:
                  ' #${orderDetailsController.orderDetailsModel.value.data!.orderSerialNo.toString()}',
              fontSize: 16.sp,
              color: const Color(0xff008BBA),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        NormalText(
          text: orderDetailsController
              .orderDetailsModel
              .value
              .data!
              .orderDatetime
              .toString(),
          color: AppColor.black80,
          fontSize: 12.sp,
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            NormalText(
              text: "ORDER_TYPE:".tr,
              fontSize: 14.sp,
              color: AppColor.black80,
              fontWeight: FontWeight.w400,
            ),
            SizedBox(width: 8.w),
            NormalText(
              text:
                  orderDetailsController
                          .orderDetailsModel
                          .value
                          .data!
                          .orderType ==
                      5
                  ? "DELIVERY".tr
                  : orderDetailsController
                            .orderDetailsModel
                            .value
                            .data!
                            .orderType ==
                        10
                  ? "TAKEAWAY".tr
                  : orderDetailsController
                            .orderDetailsModel
                            .value
                            .data!
                            .orderType ==
                        15
                  ? "POS".tr
                  : "",
              fontSize: 14.sp,
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth:
                    Get.find<OrderDetailsController>()
                        .orderDetailsModel
                        .value
                        .data!
                        .restaurantReviewStatus!
                    ? 220.w
                    : 300.w,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NormalText(
                    text: "ORDER_FROM:".tr,
                    fontSize: 14.sp,
                    color: AppColor.black80,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          text:
                              orderDetailsController
                                  .orderDetailsModel
                                  .value
                                  .data!
                                  .restaurant
                                  ?.name
                                  .toString() ??
                              '',
                          fontSize: 14.sp,
                          color: AppColor.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            if (orderDetailsController
                    .orderDetailsModel
                    .value
                    .data
                    ?.restaurantReviewStatus ==
                true)
              GestureDetector(
                onTap: () async {
                  await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return Padding(
                        padding: MediaQuery.of(context).viewInsets,
                        child: RestaurantModalSheet(
                          order: orderDetailsController
                              .orderDetailsModel
                              .value
                              .data!,
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColor.primaryLight,
                    borderRadius: BorderRadius.circular(8.r),
                  ),

                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(SvgIcon.reviewIcon, height: 16.h),
                        SizedBox(width: 4.w),
                        TextWidget(
                          text: "REVIEW".tr,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColor.primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class DeliveryPickupAddressSection extends StatelessWidget {
  const DeliveryPickupAddressSection({
    super.key,
    required this.orderDetailsController,
  });

  final OrderDetailsController orderDetailsController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        orderDetailsController.orderDetailsModel.value.data!.orderType == 5
            ? DeliveryAddressWidget(
                address: orderDetailsController.orderDetailsModel.value.data!,
              )
            : orderDetailsController.orderDetailsModel.value.data!.orderType ==
                  10
            ? RestaurentAddressWidget(
                restaurant:
                    orderDetailsController.orderDetailsModel.value.data!,
              )
            : orderDetailsController.orderDetailsModel.value.data!.orderType ==
                  15
            ? const SizedBox()
            : const SizedBox(),
        SizedBox(height: 16.h),
      ],
    );
  }
}

class PaymentInfoCardSection extends StatelessWidget {
  const PaymentInfoCardSection({
    super.key,
    required this.orderDetailsController,
  });

  final OrderDetailsController orderDetailsController;

  @override
  Widget build(BuildContext context) {
    return Container(
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
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NormalText(
              text: "PAYMENT_INFO".tr,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                NormalText(
                  text: "METHOD:".tr,
                  fontSize: 14.sp,
                  color: AppColor.black80,
                ),
                NormalText(
                  text:
                      orderDetailsController
                                  .orderDetailsModel
                                  .value
                                  .data!
                                  .orderType ==
                              5 &&
                          orderDetailsController
                                  .orderDetailsModel
                                  .value
                                  .data!
                                  .transaction ==
                              null
                      ? "CASH_ON_DELIVEY".tr
                      : orderDetailsController
                                    .orderDetailsModel
                                    .value
                                    .data!
                                    .orderType ==
                                10 &&
                            orderDetailsController
                                    .orderDetailsModel
                                    .value
                                    .data!
                                    .transaction ==
                                null
                      ? "CASH_ON_DELIVEY".tr
                      : orderDetailsController
                                .orderDetailsModel
                                .value
                                .data!
                                .transaction !=
                            null
                      ? orderDetailsController
                                .orderDetailsModel
                                .value
                                .data!
                                .transaction
                                ?.paymentMethod ??
                            ''
                      : '',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                NormalText(
                  text: "STATUS:".tr,
                  fontSize: 14.sp,
                  color: AppColor.black80,
                ),
                NormalText(
                  text:
                      orderDetailsController
                              .orderDetailsModel
                              .value
                              .data!
                              .paymentStatus ==
                          5
                      ? "PAID".tr
                      : orderDetailsController
                                .orderDetailsModel
                                .value
                                .data!
                                .paymentStatus ==
                            10
                      ? "UNPAID".tr
                      : '',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color:
                      orderDetailsController
                              .orderDetailsModel
                              .value
                              .data!
                              .paymentStatus ==
                          5
                      ? AppColor.positiveDark
                      : orderDetailsController
                                .orderDetailsModel
                                .value
                                .data!
                                .paymentStatus ==
                            10
                      ? AppColor.negativeDark
                      : AppColor.negativeDark,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OrderGifAndTimeSection extends StatelessWidget {
  const OrderGifAndTimeSection({
    super.key,
    required this.orderDetailsController,
  });

  final OrderDetailsController orderDetailsController;

  @override
  Widget build(BuildContext context) {
    final status = orderDetailsController.orderDetailsModel.value.data!.status;
    int orderType =
        orderDetailsController.orderDetailsModel.value.data?.orderType ?? 5;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (status == 1 ||
                status == 4 ||
                status == 7 ||
                status == 8 ||
                status == 10)
              NormalText(
                text: "ESTIMATED_DELIVERY_TIME".tr,
                color: AppColor.black100,
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
              ),

            if (status == 13)
              NormalText(
                text: orderType == 10 ? "" : "ENJOY_YOUR_FOOD".tr,
                color: AppColor.black100,
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
              ),
            if (status == 16)
              NormalText(
                text: "YOUR_ORDER_IS_CANCELED".tr,
                color: AppColor.black100,
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
              ),
            if (status == 19)
              NormalText(
                text: "YOUR_ORDER_IS_REJECTED".tr,
                color: AppColor.black100,
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
              ),
            if (status == 22)
              NormalText(
                text: "YOUR_ORDER_IS_RETURNED".tr,
                color: AppColor.black100,
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
              ),
          ],
        ),
        SizedBox(height: 4.h),

        if (status == 1 ||
            status == 4 ||
            status == 7 ||
            status == 8 ||
            status == 10)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NormalText(
                text:
                    '${orderDetailsController.orderDetailsModel.value.data!.preparationTime} Min',
                fontSize: 22.sp,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),

        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              status == 1
                  ? AppImages.orderPlaced
                  : status == 4
                  ? AppImages.orderPlaced
                  : status == 7
                  ? AppImages.preparing
                  : status == 8
                  ? AppImages.prepared
                  : status == 10
                  ? AppImages.onTheWay
                  : status == 13
                  ? orderType == 10
                        ? AppImages.complete
                        : AppImages.delivered
                  : status == 16
                  ? AppImages.canceled
                  : status == 19
                  ? AppImages.rejected
                  : status == 22
                  ? AppImages.returned
                  : AppImages.complete,
              height: 120.h,
              width: 120.w,
              fit: BoxFit.cover,
            ),
          ],
        ),

        SizedBox(height: 32.h),
      ],
    );
  }
}

class OrderTrackingSection extends StatelessWidget {
  const OrderTrackingSection({super.key, required this.orderDetailsController});

  final OrderDetailsController orderDetailsController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        orderDetailsController.orderDetailsModel.value.data!.orderType == 5 ||
                orderDetailsController
                        .orderDetailsModel
                        .value
                        .data!
                        .orderType ==
                    10
            ? Column(
                children: [
                  EasyStepper(
                    disableScroll: true,
                    activeStep: orderDetailsController.activeStep.value,
                    reachedSteps: Set.from(
                      List.generate(
                        orderDetailsController.activeStep.value + 1,
                        (index) => index,
                      ),
                    ),
                    stepRadius: 14.r,
                    padding: EdgeInsets.zero,
                    internalPadding: 0,
                    showStepBorder: false,
                    showLoadingAnimation: false,
                    defaultStepBorderType: BorderType.normal,
                    lineStyle: LineStyle(
                      lineThickness: 4.h,
                      lineSpace: 0,
                      lineLength:
                          orderDetailsController
                                  .orderDetailsModel
                                  .value
                                  .data!
                                  .orderType ==
                              10
                          ? 44.w
                          : 32.w,
                      activeLineColor: AppColor.primaryColor,
                      finishedLineColor: AppColor.primaryColor,
                      defaultLineColor: AppColor.unSelectColor,
                      lineType: LineType.normal,
                    ),
                    steps: [
                      EasyStep(
                        customStep: SvgPicture.asset(
                          orderDetailsController.activeStep.value >= 0
                              ? SvgIcon.like
                              : SvgIcon.like,
                          height: 32.h,
                          width: 32.w,
                        ),
                      ),
                      EasyStep(
                        enabled: true,
                        customStep: SvgPicture.asset(
                          orderDetailsController.activeStep.value >= 1
                              ? SvgIcon.prepare
                              : SvgIcon.unprepare,
                          height: 32.h,
                          width: 32.w,
                        ),
                      ),
                      EasyStep(
                        customStep: SvgPicture.asset(
                          orderDetailsController.activeStep.value >= 2
                              ? SvgIcon.tick
                              : SvgIcon.untick,
                          height: 32.h,
                          width: 32.w,
                        ),
                      ),
                      EasyStep(
                        customStep: SvgPicture.asset(
                          orderDetailsController.activeStep.value >= 3
                              ? SvgIcon.prepared
                              : SvgIcon.unprepared,
                          height: 32.h,
                          width: 32.w,
                        ),
                      ),
                      if (orderDetailsController
                              .orderDetailsModel
                              .value
                              .data!
                              .orderType ==
                          5)
                        EasyStep(
                          customStep: SvgPicture.asset(
                            orderDetailsController.activeStep.value >= 4
                                ? SvgIcon.truckFast
                                : SvgIcon.untruckFast,
                            height: 32.h,
                            width: 32.w,
                          ),
                        ),

                      EasyStep(
                        customStep: SvgPicture.asset(
                          orderDetailsController.activeStep.value >= 5
                              ? SvgIcon.box
                              : SvgIcon.unbox,
                          height: 32.h,
                          width: 32.w,
                        ),
                      ),
                    ],
                  ),
                  OrderStatusSummaryText(
                    status:
                        orderDetailsController
                            .orderDetailsModel
                            .value
                            .data
                            ?.status ??
                        0,
                    orderType:
                        orderDetailsController
                            .orderDetailsModel
                            .value
                            .data
                            ?.orderType ??
                        5,
                  ),
                ],
              )
            : const SizedBox(),
      ],
    );
  }
}

class OrderStatusSummaryText extends StatelessWidget {
  const OrderStatusSummaryText({
    super.key,
    required this.status,
    required this.orderType,
  });

  final int status;
  final int orderType;

  @override
  Widget build(BuildContext context) {
    if (status == 1) {
      return Text(
        'ORDER_STATUS_TEXT'.tr,
        textAlign: TextAlign.center,
        style: TextStyle(fontFamily: 'Rubik'),
      );
    } else if (status == 4) {
      return Text(
        'ACCEPT_TEXT_SUMMARY'.tr,
        textAlign: TextAlign.center,
        style: TextStyle(fontFamily: 'Rubik'),
      );
    } else if (status == 7) {
      return Text(
        'PREPARING_TEXT_SUMMARY'.tr,
        textAlign: TextAlign.center,
        style: TextStyle(fontFamily: 'Rubik'),
      );
    } else if (status == 8) {
      return Text(
        'PREPARED_TEXT_SUMMARY'.tr,
        textAlign: TextAlign.center,
        style: TextStyle(fontFamily: 'Rubik'),
      );
    } else if (status == 10) {
      return Text(
        'OUT_FOR_DELIVERY_TEXT_SUMMARY'.tr,
        textAlign: TextAlign.center,
      );
    } else if (status == 13) {
      return orderType == 5
          ? Text(
              'DELIVERY_TEXT_SUMMARY'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Rubik'),
            )
          : Text(
              'PICKUP_TEXT_SUMMARY'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Rubik'),
            );
    } else {
      return Text("");
    }
  }
}

class SummaryRow extends StatelessWidget {
  const SummaryRow({
    super.key,
    required this.text,
    required this.amount,
    this.texColor,
  });

  final String text;
  final String amount;
  final Color? texColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        NormalText(text: text, fontSize: 14.sp),
        NormalText(text: amount, fontSize: 14.sp, color: texColor),
      ],
    );
  }
}
