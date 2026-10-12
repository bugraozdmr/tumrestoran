import 'package:flutter/material.dart';
import 'package:foodnanny/data/model/active_order_history_model.dart';
import 'package:foodnanny/data/model/order_details_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../data/model/previous_order_history_model.dart';
import '../../../../data/repository/order_repo.dart';
import '../../../../data/server/server.dart';

class OrderHistoryController extends GetxController {
  final box = GetStorage();
  static Server server = Server();
  final activeOrdersModel = ActiveOrderHistoryModel().obs;
  final previousOrderModel = PreviousOrderHistoryModel().obs;
  final currentlyActiveOrder = <ActiveOrderHistory>[].obs;
  final orderDetailsModel = OrderDetailsModel().obs;
  final activeloader = false.obs;
  final previousloader = false.obs;
  final orderDetailsLoader = false.obs;

  final previousOrders = <PreviousOrderHistory>[].obs;

  bool isPreviousFetching = false;

  ScrollController scrollController = ScrollController();
  final isLoggedIn = false.obs;

  int paginate = 1;
  final page = 1.obs;
  final itemPerPage = 5.obs;
  final lastPage = 1.obs;
  bool hasMoreData = false;

  Future<void> getActiveOrderHistory() async {
    activeloader.value = true;
    try {
      final result = await OrderRepo.getActiveOrders();
      activeloader.value = false;
      result.fold(
        (l) {
          activeloader.value = false;
        },
        (data) {
          activeloader.value = false;

          activeOrdersModel.value = data;
        },
      );
    } finally {
      isPreviousFetching = true;
    }
  }

  Future<void> getCurrentlyActiveOrder() async {
    activeloader.value = true;
    try {
      final result = await OrderRepo.getCurrentlyActiveOrder();
      activeloader.value = false;
      result.fold((l) {}, (data) {
        currentlyActiveOrder.value = data.data!;
      });
    } finally {
      isPreviousFetching = true;
    }
  }

  Future<void> getPreviousOrderHistory() async {
    previousloader.value = true;
    try {
      final result = await OrderRepo.getPreviousOrders();
      previousloader.value = false;
      result.fold(
        (l) {
          previousloader.value = false;
        },
        (data) async {
          previousloader.value = false;

          previousOrderModel.value = data;
        },
      );
    } finally {
      isPreviousFetching = true;
    }
  }

  void resetState() {
    previousOrders.clear();
    page.value = 1;
    lastPage.value = 1;
    hasMoreData = false;
  }
}
