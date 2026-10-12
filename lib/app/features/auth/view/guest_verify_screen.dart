// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodnanny/utils/svg_icon.dart';

import 'package:get/get.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../widgets/loader/loader.dart';
import '../../../../widgets/primary_button.dart';
import '../../../../widgets/text_widget.dart';
import '../controller/auth_controller.dart';
import '../widgets/primary_textfield.dart';

class GuestVerifyScreen extends StatefulWidget {
  GuestVerifyScreen({
    super.key,
    required this.phoneNumber,
    required this.callingCode,
  });
  final String phoneNumber;
  final String callingCode;

  @override
  State<GuestVerifyScreen> createState() => _GuestVerifyScreenState();
}

class _GuestVerifyScreenState extends State<GuestVerifyScreen> {
  AuthController authController = Get.put(AuthController());
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    authController.guestOTPTextController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Scaffold(
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
                                  text: 'VERIFY_PHONE'.tr,
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
                                              text:
                                                  ' +${widget.callingCode}${widget.phoneNumber}',
                                              color: AppColor.black100,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12.sp,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      PrimaryTextField(
                                        controller: authController
                                            .guestOTPTextController,
                                        obscureText: false,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "ENTER_VALID_OTP".tr;
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
                                              await authController.resendOTP(
                                                widget.phoneNumber,
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
                                            setState(() {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                authController.guestVerifyOTP(
                                                  widget.phoneNumber,
                                                  authController
                                                      .guestOTPTextController
                                                      .text,
                                                );
                                              }
                                            });
                                          },
                                          text: 'CONTINUE'.tr,
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
          authController.verifyOTPLoader.value
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
