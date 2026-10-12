import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodnanny/app/features/auth/controller/auth_controller.dart';
import 'package:foodnanny/app/features/auth/view/login_screen.dart';
import 'package:foodnanny/app/features/favorite/view/my_favorite_screen.dart';
import 'package:foodnanny/app/features/order_history/view/order_history_screen.dart';
import 'package:foodnanny/app/features/address/view/address_view.dart';
import 'package:foodnanny/app/features/profile/change_language.dart';
import 'package:foodnanny/app/features/profile/change_password.dart';
import 'package:foodnanny/app/features/profile/controller/profile_controller.dart';
import 'package:foodnanny/app/features/profile/edit_profile.dart';
import 'package:foodnanny/app/features/profile/view/show_pages.dart';
import 'package:foodnanny/main.dart';
import 'package:foodnanny/utils/images.dart';
import 'package:foodnanny/utils/svg_icon.dart';
import 'package:foodnanny/widgets/normal_text.dart';
import 'package:foodnanny/widgets/primary_button.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../widgets/loader/loader.dart';
import '../../../../widgets/text_widget.dart';
import '../widgets/menu_item_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final authController = Get.put(AuthController());
  final profileController = Get.put(ProfileController());

  @override
  void initState() {
    profileController.getProfile();
    profileController.getPageData();
    profileController.getSettings();
    super.initState();
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
              appBar: AppBar(
                surfaceTintColor: Colors.white,
                automaticallyImplyLeading: false,
                title: Text(
                  "MY_PROFILE".tr,
                  style: GoogleFonts.urbanist(
                    color: AppColor.fontColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
                centerTitle: true,
                elevation: 0,
                backgroundColor: Colors.white,
              ),
              body: RefreshIndicator(
                color: AppColor.primaryColor,
                onRefresh: () async {
                  await profileController.getSettings();
                  await profileController.getProfile();
                  await profileController.getPageData();
                },
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Obx(
                        () => profileController.fakeInt.value == -5
                            ? const SizedBox()
                            : Column(
                                children: [
                                  const Column(children: []),
                                  Stack(
                                    clipBehavior: Clip.none,
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      SizedBox(
                                        width: 98.r,
                                        height: 98.r,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(50.r),
                                          ),
                                          child: Container(
                                            alignment: Alignment.center,
                                            decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                  AppImages.profileBorder,
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(4.r),
                                              child: Center(
                                                child: SizedBox(
                                                  width: 90.w,
                                                  height: 90.h,
                                                  child:
                                                      box.read("isLoggedIn") ==
                                                              true &&
                                                          profileController
                                                                  .profileModel
                                                                  .value
                                                                  .data
                                                                  ?.image !=
                                                              null
                                                      ? ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                50.r,
                                                              ),
                                                          child: Image.network(
                                                            profileController
                                                                .profileModel
                                                                .value
                                                                .data!
                                                                .image!,
                                                            fit: BoxFit.fill,
                                                          ),
                                                        )
                                                      : ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                50.r,
                                                              ),
                                                          child: Image.asset(
                                                            AppImages
                                                                .defaultImg,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      box.read("isLoggedIn") == false
                                          ? const SizedBox()
                                          : Positioned(
                                              width: 100.w,
                                              bottom: -15.h,
                                              child: GestureDetector(
                                                onTap: () async {
                                                  await profileController
                                                      .pickImageFromGallery();
                                                },
                                                child: SizedBox(
                                                  width: 40.w,
                                                  height: 40.h,
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        Colors.white,
                                                    child: SizedBox(
                                                      width: 36.w,
                                                      height: 36.h,
                                                      child: CircleAvatar(
                                                        backgroundColor:
                                                            AppColor.black100,
                                                        child: SvgPicture.asset(
                                                          SvgIcon.edit,
                                                          fit: BoxFit.cover,
                                                          width: 16.w,
                                                          height: 16.h,
                                                          colorFilter:
                                                              const ColorFilter.mode(
                                                                AppColor
                                                                    .whiteColor,
                                                                BlendMode.srcIn,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                  SizedBox(height: 16.h),
                                  box.read("isLoggedIn") == false
                                      ? Column(
                                          children: [
                                            NormalText(
                                              text: "LOGIN_TO_SEE_YOUR_INFO".tr,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            SizedBox(height: 16.h),
                                            PrimaryButton(
                                              width: 328.w,
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        LoginScreen(),
                                                  ),
                                                );
                                              },
                                              text: "LOGIN".tr,
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),

                                  box.read("isLoggedIn") == true &&
                                          profileController
                                                  .profileModel
                                                  .value
                                                  .data !=
                                              null
                                      ? Column(
                                          children: [
                                            TextWidget(
                                              text: profileController
                                                  .profileModel
                                                  .value
                                                  .data!
                                                  .name!,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16.sp,
                                              color: AppColor.black100,
                                            ),
                                            profileController
                                                        .profileModel
                                                        .value
                                                        .data
                                                        ?.email !=
                                                    null
                                                ? SizedBox(height: 5.h)
                                                : const SizedBox(),
                                            profileController
                                                        .profileModel
                                                        .value
                                                        .data
                                                        ?.email !=
                                                    null
                                                ? TextWidget(
                                                    text:
                                                        profileController
                                                            .profileModel
                                                            .value
                                                            .data
                                                            ?.email ??
                                                        "",
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12.sp,
                                                    color: AppColor.black80,
                                                  )
                                                : const SizedBox(),
                                            SizedBox(height: 2.h),
                                            profileController
                                                        .profileModel
                                                        .value
                                                        .data
                                                        ?.phone ==
                                                    null
                                                ? SizedBox.shrink()
                                                : Padding(
                                                    padding: EdgeInsets.only(
                                                      bottom: 2.h,
                                                    ),
                                                    child: TextWidget(
                                                      text:
                                                          profileController
                                                              .profileModel
                                                              .value
                                                              .data
                                                              ?.phone ??
                                                          "",
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12.sp,
                                                      color: AppColor.black80,
                                                    ),
                                                  ),
                                            TextWidget(
                                              text:
                                                  profileController
                                                      .profileModel
                                                      .value
                                                      .data
                                                      ?.currencyBalance ??
                                                  "",
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12.sp,
                                              color: AppColor.black80,
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                      ),
                      SizedBox(height: 32.h),
                      box.read("isLoggedIn") == false
                          ? const SizedBox()
                          : MenuItemWidget(
                              onTap: () {
                                Get.to(() => const OrderHistoryScreen());
                              },
                              svgIcon: SvgIcon.reserveLight,
                              title: "MY_ORDERS".tr,
                            ),
                      box.read("isLoggedIn") == false
                          ? const SizedBox()
                          : MenuItemWidget(
                              onTap: () {
                                Get.to(
                                  () => EditProfileView(
                                    profileModel:
                                        profileController.profileModel.value,
                                  ),
                                );
                              },
                              svgIcon: SvgIcon.edit2,
                              title: "EDIT_PROFILE".tr,
                            ),
                      box.read("isLoggedIn") == false
                          ? const SizedBox()
                          : MenuItemWidget(
                              onTap: () {
                                Get.to(() => MyFavoriteScreen());
                              },
                              svgIcon: SvgIcon.lovely,
                              title: "MY_FAVORITE".tr,
                            ),
                      box.read("isLoggedIn") == false
                          ? const SizedBox()
                          : MenuItemWidget(
                              onTap: () {
                                Get.to(() => const AddressView());
                              },
                              svgIcon: SvgIcon.map,
                              title: "ADDRESS".tr,
                            ),
                      box.read("isLoggedIn") == true
                          ? MenuItemWidget(
                              onTap: () {
                                Get.to(() => ChangePasswordView());
                              },
                              svgIcon: SvgIcon.key,
                              title: "CHANGE_PASSWORD".tr,
                            )
                          : const SizedBox(),
                      MenuItemWidget(
                        onTap: () {
                          Get.to(() => const ChangeLanguageView());
                        },
                        svgIcon: SvgIcon.globalEdit,
                        title: "CHANGE_LANGUAGE".tr,
                      ),

                      GetBuilder<ProfileController>(
                        builder: (profileController) => ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: profileController.pageDataList.length,
                          itemBuilder: (BuildContext context, index) {
                            return MenuItemWidget(
                              onTap: () {
                                Get.to(
                                  () => ShowPages(
                                    pageData:
                                        profileController.pageDataList[index],
                                  ),
                                );
                              },
                              svgIcon: SvgIcon.documentText,
                              title: profileController.pageDataList[index].title
                                  .toString(),
                            );
                          },
                        ),
                      ),
                      box.read("isLoggedIn") == true
                          ? MenuItemWidget(
                              onTap: () async {
                                await authController.logout();
                                setState(() {
                                  box.remove("token");
                                  box.write("isLoggedIn", false);
                                });
                              },
                              svgIcon: SvgIcon.logout,
                              title: "LOGOUT".tr,
                            )
                          : const SizedBox(),

                      SizedBox(height: 20.h),
                      if (box.read('isLoggedIn') == true &&
                          profileController.profileModel.value.data?.roleId ==
                              4)
                        SizedBox(
                          width: Get.width - 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Get.dialog(
                                AlertDialog(
                                  content: SizedBox(
                                    height: 160,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "ARE_YOU_SURE_To_DELETE_THIS_ACCOUNT?"
                                                .tr
                                                .tr,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'Rubik',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16.sp,
                                            ),
                                          ),
                                          SizedBox(height: 20.h),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    elevation: 1,
                                                    backgroundColor:
                                                        AppColor.whiteColor,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            24.r,
                                                          ),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "CLOSE".tr,
                                                    style: TextStyle(
                                                      fontFamily: 'Rubik',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          AppColor.primaryColor,
                                                      fontSize: 14.sp,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 20.w),
                                              Expanded(
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    await profileController
                                                        .deleteAccount();
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    elevation: 1,
                                                    backgroundColor:
                                                        AppColor.primaryColor,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            24.r,
                                                          ),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "DELETE".tr,
                                                    style: TextStyle(
                                                      fontFamily: 'Rubik',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          AppColor.whiteColor,
                                                      fontSize: 14.sp,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                barrierDismissible: false,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.primaryColor,
                              minimumSize: Size(156.w, 48.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.r),
                              ),
                            ),
                            child: Text(
                              "DELETE_ACCOUNT".tr,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 16.sp,
                                color: AppColor.whiteColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
          authController.logoutLoader.value == true
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
