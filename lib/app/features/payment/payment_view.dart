import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tumrestoran/app/features/bottom_navbar/views/bottom_navigation.dart';
import 'package:tumrestoran/app/features/checkout/controller/checkout_controller.dart';
import 'package:tumrestoran/app/features/order_details/view/order_details_screen.dart';
import 'package:get/get.dart';
import '../../../config/theme/app_color.dart';
import '../../../utils/api_list.dart';
import '../../../utils/images.dart';
import '../../../utils/svg_icon.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/text_widget.dart';
import '../bottom_navbar/controller/navbar_controller.dart';
import '../cart/controller/cart_controller.dart';
import 'payment_failed.dart';

class PaymentView extends StatefulWidget {
  final int orderId;
  final String slug;
  const PaymentView({super.key, required this.orderId, required this.slug});
  @override
  // ignore: library_private_types_in_public_api
  _PaymentViewState createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  String? selectedUrl;
  double value = 0.0;
  bool isLoading = true;
  PullToRefreshController pullToRefreshController = PullToRefreshController();
  MyInAppBrowser? browser;

  @override
  void initState() {
    super.initState();
    selectedUrl =
        "${ApiList.baseUrl}/payment/${widget.slug}/pay/${widget.orderId}";

    _initData();
  }

  void _initData() async {
    browser = MyInAppBrowser(orderId: widget.orderId.toString());
    if (Platform.isAndroid) {
      await InAppWebViewController.setWebContentsDebuggingEnabled(true);

      bool swAvailable = await WebViewFeature.isFeatureSupported(
        WebViewFeature.SERVICE_WORKER_BASIC_USAGE,
      );
      bool swInterceptAvailable = await WebViewFeature.isFeatureSupported(
        WebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST,
      );

      if (swAvailable && swInterceptAvailable) {
        ServiceWorkerController serviceWorkerController =
            ServiceWorkerController.instance();
        await serviceWorkerController.setServiceWorkerClient(
          ServiceWorkerClient(
            shouldInterceptRequest: (request) async {
              return null;
            },
          ),
        );
      }
    }

    pullToRefreshController = PullToRefreshController(
      settings: PullToRefreshSettings(color: AppColor.primaryColor),
      onRefresh: () async {
        if (Platform.isAndroid) {
          browser?.webViewController?.reload();
        } else if (Platform.isIOS) {
          browser?.webViewController?.loadUrl(
            urlRequest: URLRequest(
              url: await browser?.webViewController?.getUrl(),
            ),
          );
        }
      },
    );

    await browser?.openUrlRequest(
      urlRequest: URLRequest(url: WebUri(selectedUrl!)),
      settings: InAppBrowserClassSettings(
        browserSettings: InAppBrowserSettings(
          hideUrlBar: true,
          hideToolbarTop: true,
        ),
        webViewSettings: InAppWebViewSettings(
          useShouldOverrideUrlLoading: true,
          useOnLoadResource: true,
        ),
      ),
    );
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
          child: SizedBox(
            child: Stack(
              children: [
                isLoading
                    ?  Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColor.primaryColor,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyInAppBrowser extends InAppBrowser {
  bool _canRedirect = true;
  final String orderId;

  MyInAppBrowser({required this.orderId});

  @override
  Future onBrowserCreated() async {}

  @override
  Future onLoadStart(url) async {
    _pageRedirect(url.toString());
  }

  @override
  Future onLoadStop(url) async {
    pullToRefreshController?.endRefreshing();
    _pageRedirect(url.toString());
  }

  @override
  void onLoadError(url, code, message) {
    pullToRefreshController?.endRefreshing();
  }

  @override
  void onProgressChanged(progress) {
    if (progress == 100) {
      pullToRefreshController?.endRefreshing();
    }
  }

  @override
  void onExit() {
    if (_canRedirect) {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          bool canPop = false;
          return PopScope(
            canPop: canPop,
            onPopInvokedWithResult: (didPop, result) => (didPop) {
              if (didPop == false) {
                Get.dialog(
                  AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextWidget(
                          text: "DO_YOU_WANT_TO_EXIT?".tr,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Container(
                                width: 50.w,
                                decoration: BoxDecoration(
                                  color: AppColor.negativeDark,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(4.r),
                                    child: TextWidget(
                                      text: "NO".tr,
                                      color: AppColor.whiteColor,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                SystemNavigator.pop();
                              },
                              child: Container(
                                width: 60.w,
                                decoration: BoxDecoration(
                                  color: AppColor.positiveDark,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(4.r),
                                    child: TextWidget(
                                      text: "YES".tr,
                                      fontSize: 12.sp,
                                      color: AppColor.whiteColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
            child: AlertDialog(
              contentPadding: EdgeInsets.all(10.r),
              content: const PaymentFailedView(),
            ),
          );
        },
      );
    }
  }

  @override
  Future<NavigationActionPolicy> shouldOverrideUrlLoading(
    navigationAction,
  ) async {
    return NavigationActionPolicy.ALLOW;
  }

  @override
  @override
  void onConsoleMessage(consoleMessage) {}

  Timer? _redirectTimer;
  void _pageRedirect(String url) async {
    _redirectTimer?.cancel();

    Future.delayed(const Duration(seconds: 2), () {
      if (_canRedirect) {
        bool isSuccess =
            url.contains('success') && url.contains(ApiList.baseUrl);
        bool isFailed = url.contains('fail') && url.contains(ApiList.baseUrl);
        bool isCancel = url.contains('cancel') && url.contains(ApiList.baseUrl);
        bool isBack = url.contains('checkout') && url.contains(ApiList.baseUrl);
        bool isLogin = url.contains('login') && url.contains(ApiList.baseUrl);
        bool isHome =
            url.contains('home') && url.contains(ApiList.baseUrl) ||
            url.contains('restaurant') && url.contains(ApiList.baseUrl);

        if (isSuccess || isFailed || isCancel || isBack || isLogin || isHome) {
          _canRedirect = false;
          close();
        }
        if (isBack) {
          Get.dialog(const PaymentFailedView(), barrierDismissible: false);
        }
        if (isSuccess) {
          final cartController = Get.find<CartController>();
          final checkoutController = Get.find<CheckoutController>();
          _canRedirect = false;
          cartController.cartItems.clear();
          cartController.addonCartList.clear();
          cartController.isDeliver.value = true;
          cartController.extraDeliveryFee.value = 0.0;
          checkoutController.allResetAfterPlacedOrder();
          close();

          final navController = Get.put(NavbarController());
          navController.changePage(0);
          Get.off(() => const BottomNavigationScreen());

          Get.dialog(
            barrierDismissible: false,
            Dialog(
              insetPadding: EdgeInsets.all(10.r),
              backgroundColor: Colors.transparent,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColor.whiteColor,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.r),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 16.h),
                          TextWidget(
                            text: 'THANK_YOU_FOR_YOUR_ORDER!'.tr,
                            color: AppColor.black100,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          SizedBox(height: 20.h),
                          Image.asset(
                            AppImages.orderPlaced,
                            height: 120.h,
                            width: 120.w,
                          ),
                          SizedBox(height: 20.h),
                          TextWidget(
                            text: 'YOUR_ORDER_IS_CONFIRMED.'.tr,
                            color: AppColor.black100,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          SizedBox(height: 16.h),
                          PrimaryButton(
                            text: 'GO_TO_ORDER_DETAILS'.tr,
                            width: 328.w,
                            onTap: () {
                              Get.off(
                                () => OrderDetailScreen(
                                  orderId: orderId,
                                  fromHome: true,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16.h,
                    right: 16.w,
                    child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: SvgPicture.asset(
                        SvgIcon.closeCircle,
                        height: 24.h,
                        width: 24.w,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );

          bool cashOnDelivery =
              checkoutController.paymentMethodSlug == "cashondelivery";

          if (cashOnDelivery) {
            customSnackbar(
              "SUCCESS".tr,
              "YOUR_ORDER_HAS_BEEN_CONFIRMED".tr,
              AppColor.positiveDark,
            );
          } else {
            customSnackbar(
              "SUCCESS".tr,
              "YOUR_PAYMENT_HAS_BEEN_CONFIRMED".tr,
              AppColor.positiveDark,
            );
          }

          checkoutController.paymentMethodSlug = "";
        } else if (isFailed || isCancel || isLogin || isHome) {
          Get.back();
          customSnackbar(
            "ERROR".tr,
            "PAYMENT_FAILED".tr,
            AppColor.negativeDark,
          );
        }
      }
    });
  }
}
