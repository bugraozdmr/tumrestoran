// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodnanny/utils/svg_icon.dart';

import 'package:get/get.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../widgets/appbar_widget.dart';
import '../../../../widgets/loader/loader.dart';
import '../../../../widgets/primary_button.dart';
import '../../../../widgets/text_widget.dart';
import '../controller/auth_controller.dart';
import '../widgets/primary_textfield.dart';

class ForgotVerifyScreen extends StatefulWidget {
  ForgotVerifyScreen({super.key, required this.email});
  final String email;

  @override
  State<ForgotVerifyScreen> createState() => _ForgotVerifyScreenState();
}

class _ForgotVerifyScreenState extends State<ForgotVerifyScreen> {
  AuthController authController = Get.put(AuthController());
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    authController.otpController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Scaffold(
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

            backgroundColor: AppColor.whiteColor,
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
                                  text: 'VERIFY_EMAIL'.tr,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      FittedBox(
                                        child: Row(
                                          children: [
                                            TextWidget(
                                              text: 'ENTER_THE_CODE_SEND_TO'.tr,
                                              color: AppColor.black100,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12.sp,
                                            ),
                                            TextWidget(
                                              text: ' ${widget.email}',
                                              color: AppColor.black100,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12.sp,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      PrimaryTextField(
                                        controller:
                                            authController.otpController,
                                        obscureText: false,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "OTP_IS_REQUIRED".tr;
                                          } else {
                                            return null;
                                          }
                                        },
                                        passwordVisible: false,
                                        suffixIcon: false,
                                        prefixIcon: false,
                                        keyboardType: TextInputType.number,
                                      ),
                                      SizedBox(height: 16.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              await authController
                                                  .forgotPassword(
                                                    email: widget.email,
                                                  );
                                            },
                                            child: TextWidget(
                                              text: 'RESEND_CODE'.tr,
                                              color: AppColor.primaryColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 24.h),
                                      Center(
                                        child: PrimaryButton(
                                          width: 328.w,
                                          onTap: () async {
                                            if (formKey.currentState!
                                                .validate()) {
                                              await authController
                                                  .verifyForgotPasswordOTP(
                                                    email: widget.email,
                                                    code: authController
                                                        .otpController
                                                        .text,
                                                  );
                                            }
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          authController.forgotLoader.value
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
}
