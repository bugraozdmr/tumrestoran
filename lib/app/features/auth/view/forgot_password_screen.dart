// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodnanny/app/features/auth/view/login_screen.dart';
import 'package:foodnanny/config/theme/app_color.dart';
import 'package:foodnanny/utils/svg_icon.dart';

import 'package:get/get.dart';

import '../../../../utils/usecase/validation_rules.dart';
import '../../../../widgets/appbar_widget.dart';
import '../../../../widgets/loader/loader.dart';
import '../../../../widgets/primary_button.dart';
import '../../../../widgets/text_widget.dart';
import '../controller/auth_controller.dart';
import '../widgets/primary_textfield.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  AuthController authController = Get.put(AuthController());
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    authController.forgotEmailTextController.clear();
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
                                  text: 'FORGOT_PASSWORD'.tr,
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
                                      TextWidget(
                                        text: 'EMAIL'.tr,
                                        color: AppColor.black100,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.sp,
                                      ),
                                      SizedBox(height: 4.h),
                                      PrimaryTextField(
                                        controller: authController
                                            .forgotEmailTextController,
                                        obscureText: false,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: (value) =>
                                            ValidationRules().email(value),
                                        passwordVisible: false,
                                        suffixIcon: false,
                                        prefixIcon: false,
                                      ),
                                      SizedBox(height: 24.h),
                                      Center(
                                        child: PrimaryButton(
                                          width: 328.w,
                                          onTap: () async {
                                            if (formKey.currentState!
                                                .validate()) {
                                              await authController.forgotPassword(
                                                email: authController
                                                    .forgotEmailTextController
                                                    .text,
                                              );
                                            }
                                          },
                                          text: 'NEXT'.tr,
                                        ),
                                      ),
                                      SizedBox(height: 24.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextWidget(
                                            text: 'ALREADY_HAVE_AN_ACCOUNT?'.tr,
                                            color: AppColor.black80,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12.sp,
                                          ),
                                          SizedBox(width: 8.w),
                                          GestureDetector(
                                            onTap: () => Get.off(LoginScreen()),
                                            child: TextWidget(
                                              text: 'LOGIN'.tr,
                                              color: AppColor.primaryColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        ],
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
