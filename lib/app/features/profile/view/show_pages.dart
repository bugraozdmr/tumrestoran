import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../data/model/pages_model.dart';
import '../../../../utils/svg_icon.dart';

class ShowPages extends StatelessWidget {
  const ShowPages({super.key, required this.pageData});

  final PageData pageData;

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
        appBar: AppBar(
          backgroundColor: AppColor.whiteColor,
          surfaceTintColor: AppColor.whiteColor,
          elevation: 0,
          leading: IconButton(
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
              Get.back();
            },
          ),
          title: Text(
            pageData.title.toString().tr,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              fontFamily: 'Rubik',
            ),
          ),
        ),

        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (pageData.image != null && pageData.image!.isNotEmpty)
                  Image.network(
                    pageData.image!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                Html(data: pageData.description),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
