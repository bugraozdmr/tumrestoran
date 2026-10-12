import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodnanny/app/features/order_history/widgets/active_orders_widget.dart';
import 'package:foodnanny/main.dart';
import 'package:foodnanny/utils/svg_icon.dart';
import 'package:foodnanny/widgets/appbar_widget.dart';
import 'package:foodnanny/widgets/normal_text.dart';
import 'package:foodnanny/widgets/shimmer/order_shimmer/orders_shimmer.dart';
import 'package:foodnanny/widgets/text_widget.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_color.dart';
import '../controller/order_history_controller.dart';
import '../widgets/previous_orders_widget.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final orderHistoryController = Get.put(OrderHistoryController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isLoggedIn = box.read('isLoggedIn') ?? false;

      if (isLoggedIn) {
        orderHistoryController.getActiveOrderHistory();
        orderHistoryController.getPreviousOrderHistory();
      }
    });
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
        backgroundColor: AppColor.whiteColor,
        appBar: AppBarWidget(isIcon: false, text: 'ORDER_HISTORY'.tr),
        body: RefreshIndicator(
          color: AppColor.primaryColor,
          onRefresh: () async {
            await orderHistoryController.getActiveOrderHistory();
            await orderHistoryController.getPreviousOrderHistory();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w),
              child: Obx(() {
                orderHistoryController.isLoggedIn.value =
                    box.read('isLoggedIn') ?? false;
                final activeData = !orderHistoryController.isLoggedIn.value
                    ? []
                    : orderHistoryController.activeOrdersModel.value.data ?? [];

                final previousData = !orderHistoryController.isLoggedIn.value
                    ? []
                    : orderHistoryController.previousOrderModel.value.data ??
                          [];

                final isActiveLoading =
                    orderHistoryController.activeloader.value;
                final isPreviousLoading =
                    orderHistoryController.previousloader.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NormalText(
                      text: "ACTIVE_ORDERS".tr,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(height: 16.h),

                    if (isActiveLoading)
                      const OrderShimmer()
                    else if (activeData.isEmpty)
                      Center(
                        child: Column(
                          children: [
                            SvgPicture.asset(SvgIcon.noActiveOrder),
                            SizedBox(height: 8.h),
                            TextWidget(text: "NO_ACTIVE_ORDERS_TEXT".tr),
                          ],
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: activeData.length,
                        itemBuilder: (_, index) => Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: ActiveOrdersWidget(orders: activeData[index]),
                        ),
                      ),

                    SizedBox(height: 56.h),

                    NormalText(
                      text: "PREVIOUS_ORDERS".tr,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(height: 16.h),

                    if (isPreviousLoading)
                      const OrderShimmer()
                    else if (previousData.isEmpty)
                      Center(
                        child: Column(
                          children: [
                            SvgPicture.asset(SvgIcon.noPreviousOrder),
                            SizedBox(height: 8.h),
                            TextWidget(text: "NO_PREVIOUS_ORDERS_TEXT".tr),
                            if (activeData.isNotEmpty) SizedBox(height: 200.h),
                          ],
                        ),
                      )
                    else
                      Padding(
                        padding: EdgeInsets.only(bottom: 100.h),
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: previousData.length,
                          itemBuilder: (_, index) => Padding(
                            padding: EdgeInsets.only(bottom: 16.h),
                            child: PreviousOrdersWidget(
                              orders: previousData[index],
                            ),
                          ),
                        ),
                      ),

                    SizedBox(height: 30.h),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
