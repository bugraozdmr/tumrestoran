// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodnanny/widgets/appbar_widget.dart';
import 'package:get/get.dart';
import '../../../config/theme/app_color.dart';
import '../../../utils/svg_icon.dart';
import '../../../widgets/loader/loader.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/text_widget.dart';
import '../auth/widgets/primary_textfield.dart';
import 'controller/profile_controller.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ProfileController profileController = Get.find<ProfileController>();

  bool validate = false;

  @override
  void dispose() {
    super.dispose();

    profileController.oldPassController.clear();
    profileController.newPassController.clear();
    profileController.confirmPassController.clear();
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
              backgroundColor: Colors.white,
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
                text: "CHANGE_PASSWORD".tr,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: 'OLD_PASSWORD'.tr,
                              fontWeight: FontWeight.w400,
                              fontSize: 12.sp,
                              color: AppColor.black100,
                            ),
                            SizedBox(height: 4.h),
                            PrimaryTextField(
                              controller: profileController.oldPassController,
                              validator: (value) => value!.isEmpty
                                  ? 'PLEASE_TYPE_OLD_PASSWORD'.tr
                                  : null,
                              obscureText: true,
                              passwordVisible: true,
                              suffixIcon: true,
                              prefixIcon: false,
                            ),
                            SizedBox(height: 16.h),
                            TextWidget(
                              text: 'NEW_PASSWORD'.tr,
                              fontWeight: FontWeight.w400,
                              fontSize: 12.sp,
                              color: AppColor.black100,
                            ),
                            PrimaryTextField(
                              controller: profileController.newPassController,
                              validator: (value) => value!.isEmpty
                                  ? 'PLEASE_TYPE_NEW_PASSWORD'.tr
                                  : null,
                              obscureText: true,
                              passwordVisible: true,
                              suffixIcon: true,
                              prefixIcon: false,
                            ),
                            SizedBox(height: 16.h),
                            TextWidget(
                              text: 'RETYPE_NEW_PASSWORD'.tr,
                              fontWeight: FontWeight.w400,
                              fontSize: 12.sp,
                              color: AppColor.black100,
                            ),
                            PrimaryTextField(
                              controller:
                                  profileController.confirmPassController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'PLEASE_RETYPE_PASSWORD'.tr;
                                }
                                if (value !=
                                    profileController.newPassController.text) {
                                  return 'PASSWORD_NOT_MATCH'.tr;
                                } else {
                                  return null;
                                }
                              },
                              obscureText: true,
                              passwordVisible: true,
                              suffixIcon: true,
                              prefixIcon: false,
                            ),
                            SizedBox(height: 24.h),
                            PrimaryButton(
                              width: 328.w,
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  await profileController.changePassword(
                                    oldPassword: profileController
                                        .oldPassController
                                        .text,
                                    newPassword: profileController
                                        .newPassController
                                        .text,
                                    confirmPassword: profileController
                                        .confirmPassController
                                        .text,
                                  );
                                }
                              },
                              text: "CHANGE_PASSWORD".tr,
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
          profileController.passChangingLoader.value == true
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
