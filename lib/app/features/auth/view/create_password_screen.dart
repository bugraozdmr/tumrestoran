// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../utils/svg_icon.dart';
import '../../../../utils/usecase/validation_rules.dart';
import '../../../../widgets/loader/loader.dart';
import '../../../../widgets/primary_button.dart';
import '../../../../widgets/text_widget.dart';
import '../controller/auth_controller.dart';
import '../widgets/primary_textfield.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  CreateNewPasswordScreen({super.key, required this.email});
  final String email;

  @override
  State<CreateNewPasswordScreen> createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  bool passwordVisible = false;
  AuthController authController = Get.put(AuthController());
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    authController.passwordController.clear();
    authController.confirmPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Scaffold(
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
                                  text: 'CREATE_NEW_PASSWORD'.tr,
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
                                        text: 'ENTER_NEW_PASSWORD'.tr,
                                        color: AppColor.black100,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.sp,
                                      ),
                                      SizedBox(height: 4.h),
                                      PrimaryTextField(
                                        controller:
                                            authController.passwordController,
                                        obscureText: true,
                                        prefixIcon: false,
                                        passwordVisible: passwordVisible,
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        suffixIcon: true,
                                        validator: (value) =>
                                            ValidationRules().password(value),
                                      ),
                                      SizedBox(height: 16.h),
                                      TextWidget(
                                        text: 'CONFIRM_PASSWORD'.tr,
                                        color: AppColor.black100,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.sp,
                                      ),
                                      SizedBox(height: 4.h),
                                      PrimaryTextField(
                                        controller: authController
                                            .confirmPasswordController,
                                        obscureText: true,
                                        prefixIcon: false,
                                        passwordVisible: passwordVisible,
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        suffixIcon: true,
                                        validator: (value) =>
                                            ValidationRules().password(value),
                                      ),
                                      SizedBox(height: 24.h),
                                      Center(
                                        child: PrimaryButton(
                                          width: 328.w,
                                          onTap: () async {
                                            if (formKey.currentState!
                                                .validate()) {
                                              await authController.resetPassword(
                                                email: widget.email,
                                                password: authController
                                                    .passwordController
                                                    .text,
                                                confirmPassword: authController
                                                    .confirmPasswordController
                                                    .text,
                                                token: authController
                                                    .otpController
                                                    .text,
                                              );
                                            }
                                          },
                                          text: 'SUBMIT'.tr,
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
          authController.resetPasswordLoader.value
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
