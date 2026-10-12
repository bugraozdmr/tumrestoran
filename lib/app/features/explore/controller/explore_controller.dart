import 'package:flutter/widgets.dart';
import 'package:tumrestoran/app/features/home/controller/home_controller.dart';
import 'package:tumrestoran/data/model/restuarant_model.dart';
import 'package:tumrestoran/data/repository/all_restaurant_repo.dart';
import 'package:get/get.dart';

class ExploreController extends GetxController {
  final AllRestuarantRepo _allRestuarantRepo = AllRestuarantRepo();
  final searchResultList = <Restaurant>[].obs;
  final restaurantLoader = false.obs;
  TextEditingController searchController = TextEditingController();

  Future<void> getAllRestuarantBySearch({
    required String lat,
    required String long,
    required String deliveryOrderType,
    required String query,
  }) async {
    restaurantLoader(true);
    final data = await _allRestuarantRepo.getAllRestuarantBySearch(
      lat: lat,
      long: long,
      deliveryOrderType: deliveryOrderType,
      query: query,
    );
    restaurantLoader(false);
    data.fold(
      (error) {
        restaurantLoader(false);
      },
      (data) {
        restaurantLoader(false);
        searchResultList.value = data.data!;
        updateSearchResultWithOfferAmount();
      },
    );
  }

  void updateSearchResultWithOfferAmount() {
    final restaurants = searchResultList;
    final offers = Get.find<HomeController>().findOfferModel.value.data;

    if (restaurants.isEmpty || offers == null) return;

    for (int i = 0; i < restaurants.length; i++) {
      final matchedOffers = offers
          .where((offer) => offer.id.toString() == restaurants[i].id.toString())
          .toList();

      if (matchedOffers.isEmpty) continue;

      final maxAmount = matchedOffers
          .map((e) => num.tryParse(e.amount.toString()) ?? 0)
          .reduce((a, b) => a > b ? a : b);

      restaurants[i] = restaurants[i].copyWith(amount: maxAmount.toInt());
    }

    searchResultList.refresh();
  }
}
