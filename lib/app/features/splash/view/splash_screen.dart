import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodnanny/app/features/address/controller/address_controller.dart';
import 'package:foodnanny/app/features/bottom_navbar/views/bottom_navigation.dart';
import 'package:foodnanny/app/features/search_location/view/initial_location_view.dart';
import 'package:foodnanny/config/theme/app_color.dart';
import 'package:foodnanny/main.dart';
import 'package:get/get.dart';

import '../../../../utils/images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Get.put(AddressController());

    // addressController.getCurrentLocation();
    if (box.read('pickedLat') == null || box.read('pickedLat') == '') {
      box.write('pickedLat', '41.0082');
      box.write('pickedLong', '28.9784');
      box.write('pickAddress', 'İstanbul, Türkiye');
    }

    Timer(const Duration(seconds: 2), () {
      Get.offAll(() => const BottomNavigationScreen());
    });

    super.initState();
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
        body: Center(
          child: Image.asset(AppImages.logo, height: 57.h, width: 238.w),
        ),
      ),
    );
  }
}
