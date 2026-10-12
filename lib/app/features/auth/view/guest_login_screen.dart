// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tumrestoran/app/features/auth/view/singup_phone_screen.dart';
import 'package:tumrestoran/app/features/auth/widgets/phone_search_form_field.dart';
import 'package:tumrestoran/utils/svg_icon.dart';
import 'package:tumrestoran/widgets/normal_text.dart';
import 'package:get/get.dart';
import 'package:phone_form_field/phone_form_field.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../widgets/appbar_widget.dart';
import '../../../../widgets/primary_button.dart';
import '../../../../widgets/text_widget.dart';
import '../../profile/controller/profile_controller.dart';
import '../controller/auth_controller.dart';

class GuestLoginScreen extends StatefulWidget {
  GuestLoginScreen({super.key});

  @override
  State<GuestLoginScreen> createState() => _GuestLoginScreenState();
}

class _GuestLoginScreenState extends State<GuestLoginScreen> {
  AuthController authController = Get.put(AuthController());
  ProfileController profileController = Get.put(ProfileController());
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    authController.guestphoneTextController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
                Get.back();
              },
            ),
            text: "",
          ),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            SvgIcon.logo,
                            height: 32.h,
                            width: 133.w,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              child: TextWidget(
                                text: 'GEUST_LOGIN'.tr,
                                color: AppColor.black100,
                                fontWeight: FontWeight.w600,
                                fontSize: 22.sp,
                              ),
                            ),
                            Form(
                              key: formKey,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: 32.h,
                                  left: 16.w,
                                  right: 16.w,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FittedBox(
                                      child: Row(
                                        children: [
                                          TextWidget(
                                            text: 'PHONE'.tr,
                                            color: AppColor.black100,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12.sp,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    PhoneSearchFormField(
                                      onPhoneChanged: (nsn, countryCode) {
                                        authController
                                                .guestphoneTextController
                                                .text =
                                            nsn;
                                        Get.find<ProfileController>()
                                                .callingCode
                                                .value =
                                            countryCode;
                                      },
                                      phoneController: PhoneController(
                                        initialValue: PhoneNumber(
                                          isoCode: IsoCode.BD,
                                          nsn: "",
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 24.h),
                                    Center(
                                      child: PrimaryButton(
                                        width: 328.w,
                                        onTap: () async {
                                          setState(() {
                                            if (formKey.currentState!
                                                .validate()) {
                                              authController.guestPhoneVerify(
                                                authController
                                                    .guestphoneTextController
                                                    .text,
                                              );
                                            }
                                          });
                                        },
                                        text: 'NEXT'.tr,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          NormalText(
                            text: "WANT_TO_CREATE_AN_ACCOUNT?".tr,
                            fontSize: 12.sp,
                            color: AppColor.black80,
                          ),
                          SizedBox(width: 4.w),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => SingupPhoneScreen());
                            },
                            child: NormalText(
                              text: "SIGN_UP".tr,
                              fontSize: 12.sp,
                              color: AppColor.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
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
