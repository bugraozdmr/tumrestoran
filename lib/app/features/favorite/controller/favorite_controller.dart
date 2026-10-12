import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:foodnanny/data/model/restuarant_model.dart';
import 'package:foodnanny/data/server/server.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:foodnanny/utils/api_list.dart';
import 'package:get/get.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../main.dart';
import '../../../../widgets/custom_snackbar.dart';

class FavoriteController extends GetxController {
  final favoriteMap = <int, bool>{}.obs;
  final favoriteRestaurants = <Restaurant>[].obs;
  final page = 1.obs;
  int lastPage = 1;
  final perPage = 12.obs;
  bool isFetching = false;
  final favoriteLoader = false.obs;
  ScrollController scrollController = ScrollController();
  final hasMoreData = false.obs;

  Future<void> toggleFavorite({
    required int restaurantId,
    required bool favorite,
  }) async {
    final token = await box.read('token');
    bool currentStatus = isFavorite(
      restaurantId: restaurantId,
      modelValue: favorite,
    );
    bool newStatus = !currentStatus;

    final response = await http.post(
      Uri.parse(ApiList.favorite),
      body: {
        "restaurant_id": restaurantId.toString(),
        "toggle": newStatus ? "1" : "0",
      },
      headers: {
        "Accept": 'Application/json',
        'Authorization': "Bearer $token",
        "x-api-key": ApiList.licenseKey,
        "x-localization": box.read('languageCode').toString(),
      },
    );

    if (response.statusCode == 202) {
      favoriteMap[restaurantId] = newStatus;
    } else {
      String message =
          jsonDecode(response.body)['message'] ?? 'Something went wrong';
      customSnackbar('ERROR'.tr, message, AppColor.rejectedTextColor);
    }
  }

  bool isFavorite({required int restaurantId, required bool modelValue}) {
    if (favoriteMap.containsKey(restaurantId)) {
      return favoriteMap[restaurantId]!;
    }
    return modelValue;
  }

  Future<void> getFavoriteRestaurants({bool isRefresh = false}) async {
    if (isFetching) return;

    try {
      isFetching = true;
      favoriteLoader.value = true;

      if (isRefresh) {
        page.value = 1;
        favoriteRestaurants.clear();
      }

      favoriteRestaurants.clear();

      final response = await Server().getRequestWithToken(
        endPoint: ApiList.favoriteRestaurants(
          perPage: perPage.value,
          page: page.value,
        ),
      );

      if (response.statusCode == 200) {
        lastPage = response.data['meta']['last_page'];
        final data = response.data['data'] as List<dynamic>;
        final favorites = data.map((e) => Restaurant.fromJson(e)).toList();
        favoriteRestaurants.addAll(favorites);

        if (page.value < lastPage) page.value++;
      }
    } finally {
      isFetching = false;
      favoriteLoader.value = false;
    }
  }

  loadMoreFavorite() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          !isFetching &&
          page.value < lastPage) {
        getFavoriteRestaurants();
      }
    });
  }
}
