import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../config/theme/app_color.dart';
import '../../../utils/svg_icon.dart';
import '../../../widgets/appbar_widget.dart';
import '../../../widgets/text_widget.dart';
import '../../localization/controller/language_controller.dart';

class ChangeLanguageView extends StatefulWidget {
  const ChangeLanguageView({super.key});

  @override
  State<ChangeLanguageView> createState() => _ChangeLanguageViewState();
}

class _ChangeLanguageViewState extends State<ChangeLanguageView> {
  final box = GetStorage();
  final bool isActive = true;
  LanguageController languageController = Get.put(LanguageController());

  @override
  void initState() {
    super.initState();

    languageController.getLanguage();

    if (box.read('selectedLanguageValue') == null) {
      box.write('langCode', 'en');
    }
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
          text: "CHANGE_LANGUAGE".tr,
        ),

        body: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => languageController.languageList.isEmpty
                    ? const SizedBox()
                    : Obx(
                        () => languageController.selectLanguage.value == -2
                            ? const SizedBox()
                            : RefreshIndicator(
                                color: AppColor.primaryColor,
                                onRefresh: () async {
                                  await languageController.getLanguage();
                                },
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount:
                                      languageController.languageList.length,
                                  itemBuilder: (BuildContext context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        languageController.changeLanguage(
                                          languageController
                                              .languageList[index]
                                              .code!,
                                          languageController
                                              .languageList[index]
                                              .name!,
                                        );
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 16.h),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              8.r,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColor.black20,
                                                blurRadius: 32.r,
                                                offset: const Offset(0, 6),
                                              ),
                                            ],
                                            color:
                                                box.read('langCode') ==
                                                    languageController
                                                        .languageList[index]
                                                        .code!
                                                ? AppColor.primaryColor
                                                      .withAlpha(20)
                                                : Colors.white,
                                            border:
                                                box.read('langCode') ==
                                                    languageController
                                                        .languageList[index]
                                                        .code!
                                                ? Border.all(
                                                    color:
                                                        AppColor.primaryColor,
                                                  )
                                                : Border.all(
                                                    color:
                                                        box.read('langCode') ==
                                                            languageController
                                                                .languageList[index]
                                                                .code!
                                                        ? AppColor.primaryColor
                                                        : Colors.white,
                                                  ),
                                          ),
                                          height: 56.h,
                                          width: 328.w,
                                          child: Row(
                                            children: [
                                              SizedBox(width: 16.w),
                                              SizedBox(
                                                width: 24.w,
                                                height: 24.h,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                        Radius.circular(8.r),
                                                      ),
                                                  child: CachedNetworkImage(
                                                    imageUrl: languageController
                                                        .languageList[index]
                                                        .image!,
                                                    imageBuilder:
                                                        (
                                                          context,
                                                          imageProvider,
                                                        ) => Container(
                                                          decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                              image:
                                                                  imageProvider,
                                                              fit: BoxFit
                                                                  .contain,
                                                            ),
                                                          ),
                                                        ),

                                                    errorWidget:
                                                        (context, url, error) =>
                                                            const Icon(
                                                              Icons.error,
                                                            ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 16.w),
                                              TextWidget(
                                                text: languageController
                                                    .languageList[index]
                                                    .name
                                                    .toString(),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14.sp,
                                                color: AppColor.black100,
                                              ),
                                              const Spacer(),

                                              Padding(
                                                padding: EdgeInsets.only(
                                                  right: 18.w,
                                                  left: 18.w,
                                                ),
                                                child: SizedBox(
                                                  width: 24.w,
                                                  height: 24.h,
                                                  child:
                                                      box.read('langCode') ==
                                                          languageController
                                                              .languageList[index]
                                                              .code!
                                                      ? SvgPicture.asset(
                                                          SvgIcon.tickCircle,
                                                          fit: BoxFit.cover,
                                                          colorFilter:
                                                              ColorFilter.mode(
                                                                AppColor
                                                                    .primaryColor,
                                                                BlendMode.srcIn,
                                                              ),
                                                        )
                                                      : const SizedBox(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
