import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodnanny/app/features/bottom_navbar/controller/navbar_controller.dart';
import 'package:foodnanny/app/features/cart/controller/cart_controller.dart';
import 'package:foodnanny/app/features/favorite/controller/favorite_controller.dart';
import 'package:foodnanny/app/helper/device_token.dart';
import 'package:foodnanny/app/helper/notification_helper.dart';
import 'package:foodnanny/widgets/text_widget.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../main.dart';
import '../../../../utils/svg_icon.dart';
import '../../profile/controller/profile_controller.dart';
import '../widgets/navbar_items.dart';
import 'package:badges/badges.dart' as badges;

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  final navController = Get.put(NavbarController());
  final cartController = Get.find<CartController>();
  final profileController = Get.put(ProfileController());

  @override
  void initState() {
    NotificationHelper().notificationPermission();
    profileController.getSettings();
    if (box.read('isLoggedIn') == true) {
      DeviceToken().getDeviceToken();
    }
    Get.put(FavoriteController());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool canPop = false;

    return Obx(
      () => PopScope(
        canPop: canPop,
        // ignore: deprecated_member_use
        onPopInvoked: (didPop) {
          if (didPop == false) {
            Get.dialog(
              AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextWidget(
                      text: "DO_YOU_WANT_TO_EXIT?".tr,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            width: 50.w,
                            decoration: BoxDecoration(
                              color: AppColor.negativeDark,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(4.r),
                                child: TextWidget(
                                  text: "NO".tr,
                                  color: AppColor.whiteColor,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            SystemNavigator.pop();
                          },
                          child: Container(
                            width: 60.w,
                            decoration: BoxDecoration(
                              color: AppColor.positiveDark,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(4.r),
                                child: TextWidget(
                                  text: "YES".tr,
                                  fontSize: 12.sp,
                                  color: AppColor.whiteColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        },
        child: Scaffold(
          extendBody: false,
          resizeToAvoidBottomInset: false,
          body: navController.pages[navController.currentPage.value],
          floatingActionButton: Obx(
            () => badges.Badge(
              showBadge: cartController.cartItems.isEmpty ? false : true,
              position: badges.BadgePosition.topEnd(top: 10.h, end: 10.h),
              badgeStyle: const badges.BadgeStyle(
                badgeColor: Colors.amberAccent,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50.r)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.primaryColor.withValues(alpha: 0.3),
                      offset: const Offset(0.0, 5.0),
                      blurRadius: 10.r,
                      spreadRadius: 2.r,
                    ),
                  ],
                ),
                child: GestureDetector(
                  onTap: () {
                    navController.changePage(2);
                  },
                  child: Container(
                    height: 56.r,
                    width: 56.r,
                    decoration: BoxDecoration(
                      color: AppColor.primaryColor,
                      borderRadius: BorderRadius.circular(56.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.primaryColor.withValues(alpha: 0.34),
                          blurRadius: 10.r,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      height: 60.h,
                      width: 60.w,
                      child: CircleAvatar(
                        backgroundColor: AppColor.primaryColor,
                        child: SvgPicture.asset(SvgIcon.cart, height: 24.h),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            height: 64.h,
            elevation: 10,
            notchMargin: 5,
            clipBehavior: Clip.antiAlias,
            shape: const CircularNotchedRectangle(),
            color: Colors.white,
            child: Container(
              height: 64.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.r),
                  topRight: Radius.circular(15.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.blackColor.withValues(alpha: 0.06),
                    offset: Offset(0, 4),
                    blurRadius: 32.r,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      navController.changePage(0);
                    },
                    child: NavBarItem(
                      svgIcon: SvgIcon.home,
                      iconColor: navController.currentPage.value == 0
                          ? AppColor.primaryColor
                          : AppColor.black80,
                      text: "HOME".tr,
                      color: navController.currentPage.value == 0
                          ? AppColor.primaryColor
                          : AppColor.black80,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      navController.changePage(1);
                    },
                    child: NavBarItem(
                      svgIcon: SvgIcon.search,
                      text: "EXPLORE".tr,
                      iconColor: navController.currentPage.value == 1
                          ? AppColor.primaryColor
                          : AppColor.black80,
                      color: navController.currentPage.value == 1
                          ? AppColor.primaryColor
                          : AppColor.black80,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  GestureDetector(
                    onTap: () {
                      navController.changePage(3);
                    },
                    child: NavBarItem(
                      svgIcon: SvgIcon.orderOff,
                      text: "ORDERS".tr,
                      iconColor: navController.currentPage.value == 3
                          ? AppColor.primaryColor
                          : AppColor.black80,
                      color: navController.currentPage.value == 3
                          ? AppColor.primaryColor
                          : AppColor.black80,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      navController.changePage(4);
                    },
                    child: NavBarItem(
                      svgIcon: SvgIcon.profile,
                      text: "PROFILE".tr,
                      iconColor: navController.currentPage.value == 4
                          ? AppColor.primaryColor
                          : AppColor.black80,
                      color: navController.currentPage.value == 4
                          ? AppColor.primaryColor
                          : AppColor.black80,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
