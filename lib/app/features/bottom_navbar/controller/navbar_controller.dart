import 'package:foodnanny/app/features/auth/view/login_screen.dart';
import 'package:foodnanny/app/features/explore/view/explore_screen.dart';
import 'package:foodnanny/app/features/order_history/view/order_history_screen.dart';
import 'package:foodnanny/app/features/profile/view/profile_screen.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../cart/views/cart_screen.dart';
import '../../home/view/home_screen.dart';

class NavbarController extends GetxController {
  final currentPage = 0.obs;
  final canExit = false.obs;

  final pages = [
    const HomeScreen(),
    const ExploreScreen(),
    const CartScreen(),
    const OrderHistoryScreen(),
    const ProfileScreen(),
  ];

  void changePage(int index) {
    currentPage.value = index;
    if (box.read('isLoggedIn') != true && index == 3) {
      Get.to(() => LoginScreen(fromOrderHistory: true));
    }
  }
}
