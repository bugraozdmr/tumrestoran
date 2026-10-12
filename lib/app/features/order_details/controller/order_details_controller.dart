import 'package:tumrestoran/app/features/bottom_navbar/controller/navbar_controller.dart';
import 'package:tumrestoran/app/features/bottom_navbar/views/bottom_navigation.dart';
import 'package:tumrestoran/config/theme/app_color.dart';
import 'package:tumrestoran/data/server/server.dart';
import 'package:tumrestoran/utils/api_list.dart';
import 'package:tumrestoran/widgets/custom_snackbar.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../data/model/order_details_model.dart';
import '../../../../data/repository/order_repo.dart';

class OrderDetailsController extends GetxController {
  final navBarController = Get.find<NavbarController>();
  final activeStep = 0.obs;
  final orderDetailsLoader = false.obs;
  final orderDetailsModel = OrderDetailsModel().obs;
  final orderCancelLoader = false.obs;

  getOrderDetails({required String id}) async {
    orderDetailsLoader.value = true;
    var detailsData = await OrderRepo.getOrderDetails(id: id);
    orderDetailsLoader.value = false;

    detailsData.fold((error) => (), (order) {
      orderDetailsModel.value = order;
      final status = orderDetailsModel.value.data?.status ?? 1;
      final orderType = orderDetailsModel.value.data?.orderType ?? 0;

      if (orderType == 5 || orderType == 10) {
        activeStep.value = getStepIndexFromStatus(status);
        orderDetailsLoader.value = false;
      } else {
        activeStep.value = 0;
      }
    });
  }

  int getStepIndexFromStatus(int status) {
    switch (status) {
      case 1:
        return 0;
      case 4:
        return 1;
      case 7:
        return 2;
      case 8:
        return 3;
      case 10:
        return 4;
      case 16:
      case 19:
      case 22:
      case 25:
        return 4;
      case 13:
        return 5;
      default:
        return 0;
    }
  }

  Future<void> orderCancel({required int id}) async {
    try {
      orderCancelLoader(true);
      final response = await Server().postRequestWithToken(
        endpoint: ApiList.cancelOrder(id: id),
        body: {"status": 16},
      );

      if (response.statusCode == 200) {
        orderCancelLoader(false);
        navBarController.changePage(0);
        Get.off(() => const BottomNavigationScreen());
        customSnackbar(
          "SUCCESS".tr,
          "ORDER_HAS_BEEN_CANCELED_SUCCESSFULLY".tr,
          AppColor.positiveDark,
        );
      }
    } catch (e) {
      orderCancelLoader(false);
      customSnackbar("ERROR".tr, "REQUEST_FAILED".tr, AppColor.negativeDark);
    }
  }

  Future<void> launchURL(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }
}
