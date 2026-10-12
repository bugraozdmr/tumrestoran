import 'package:tumrestoran/app/features/home/model/find_offer_model.dart';
import 'package:tumrestoran/app/features/home/model/single_offer_model.dart';
import 'package:tumrestoran/data/model/campaign_model.dart';
import 'package:tumrestoran/data/model/quisine_model.dart';
import 'package:tumrestoran/data/model/restuarant_model.dart';
import 'package:tumrestoran/data/repository/all_restaurant_repo.dart';
import 'package:tumrestoran/data/repository/cuisine_repo.dart';
import 'package:get/get.dart';

import '../model/single_check_offer_model.dart';

class HomeController extends GetxController {
  final QuisinRepo _quisinRepo = QuisinRepo();
  final AllRestuarantRepo _allRestuarantRepo = AllRestuarantRepo();
  final restuarantModel = RestaurantModel().obs;
  final restaurantList = <Restaurant>[].obs;
  final allResLoader = false.obs;
  final quisineList = <Quisine>[].obs;
  final campaignModel = CampaingModel().obs;
  final restaurantLoader = false.obs;
  bool isDataFetched = false;
  final selectedMenu = RxInt(-1);
  bool _isLocked = false;
  final showCampaignLoader = false.obs;
  final bannerList = <BannerItem>[].obs;
  final sinlgeOfferRestaurants = <Restaurant>[].obs;
  final singleOfferLoader = false.obs;
  final singleOfferModel = SingleOfferModel().obs;
  final checkSingleOfferModel = CheckSingleOfferModel().obs;
  bool isSingleOfferAvailable = false;
  final findOfferModel = FindOfferModel().obs;
  final campaignInfoModel = Campaign().obs;

  Future<void> getQuisine() async {
    final data = await _quisinRepo.getQuisine();
    data.fold((error) => null, (data) {
      quisineList.value = data.data?.where((q) => q.status == 5).toList() ?? [];
    });
  }

  Future<void> getAllRestuarantByLatLong({
    required String lat,
    required String long,
    required String deliveryOrderType,
  }) async {
    if (_isLocked) {
      return;
    }
    _isLocked = true;
    allResLoader(true);
    isDataFetched = false;

    final data = await _allRestuarantRepo.getAllRestuarantByLatLong(
      lat: lat,
      long: long,
      deliveryOrderType: deliveryOrderType,
    );

    allResLoader(false);

    data.fold(
      (error) {
        isDataFetched = false;
      },
      (res) {
        isDataFetched = true;
        restuarantModel.value = res;

        findOffers(lat: lat, long: long, deliveryOrderType: deliveryOrderType);
      },
    );
    restaurantLoader(false);
    _isLocked = false;
  }

  Future<void> getRestaurantByQuisineId({
    required String lat,
    required String long,
    required String deliveryOrderType,
    required String quisineId,
  }) async {
    final data = await _allRestuarantRepo.getRestuarantByQuisineId(
      lat: lat,
      long: long,
      deliveryOrderType: deliveryOrderType,
      quisineId: quisineId,
    );

    data.fold((error) {}, (data) {
      restuarantModel.value = data;
      updateRestaurantWithOfferAmount();
    });
  }

  Future<void> getCampaignsAndOffer({
    required String lat,
    required String long,
    required String deliveryOrderType,
  }) async {
    restaurantLoader(true);

    bannerList.clear();

    final results = await Future.wait([
      _allRestuarantRepo.getCampaign(
        lat: lat,
        long: long,
        deliveryOrderType: deliveryOrderType,
      ),
      _allRestuarantRepo.getOfferBanner(
        lat: lat,
        long: long,
        deliveryOrderType: deliveryOrderType,
      ),
    ]);

    restaurantLoader(false);

    final campaignResult = results[0];
    final offerResult = results[1];

    bannerList.clear();

    campaignResult.fold((error) {}, (data) {
      for (Campaign item in data.data ?? []) {
        if (item.restaurants != null && item.restaurants!.isNotEmpty) {
          bannerList.add(BannerItem(type: BannerType.campaign, data: item));
        }
      }
    });

    offerResult.fold((error) {}, (data) {
      for (Campaign item in data.data ?? []) {
        if (item.restaurants != null && item.restaurants!.isNotEmpty) {
          bannerList.add(BannerItem(type: BannerType.offer, data: item));
        }
      }
    });
  }

  Future<void> showCampaign({
    required String slug,
    required String lat,
    required String long,
    required String deliveryOrderType,
  }) async {
    showCampaignLoader.value = true;
    final result = await _allRestuarantRepo.showCampaign(
      slug: slug,
      lat: lat,
      long: long,
      deliveryOrderType: deliveryOrderType,
    );

    showCampaignLoader.value = false;
    result.fold((error) {}, (data) {
      campaignInfoModel.value = data;
      restaurantList.value = data.restaurants!
          .where((restaurant) => restaurant.availability == 5)
          .toList();

      updateCampaignOfferRestaurantWithAmount();
    });
  }

  void updateCampaignOfferRestaurantWithAmount() {
    final offers = findOfferModel.value.data;

    if (restaurantList.isEmpty || offers == null) return;

    for (int i = 0; i < restaurantList.length; i++) {
      final matchedOffers = offers
          .where(
            (offer) => offer.id.toString() == restaurantList[i].id.toString(),
          )
          .toList();

      if (matchedOffers.isEmpty) continue;

      final maxAmount = matchedOffers
          .map((e) {
            if (e.amount is List && (e.amount as List).isNotEmpty) {
              return (e.amount as List)
                  .map((v) => num.tryParse(v.toString()) ?? 0)
                  .reduce((a, b) => a > b ? a : b);
            } else {
              return num.tryParse(e.amount.toString()) ?? 0;
            }
          })
          .reduce((a, b) => a > b ? a : b);

      restaurantList[i] = restaurantList[i].copyWith(amount: maxAmount.toInt());

      break;
    }

    restaurantList.refresh();
  }

  Future<void> showOffer({
    required String slug,
    required String lat,
    required String long,
    required String deliveryOrderType,
  }) async {
    showCampaignLoader.value = true;
    final result = await _allRestuarantRepo.showOffer(
      slug: slug,
      lat: lat,
      long: long,
      deliveryOrderType: deliveryOrderType,
    );
    showCampaignLoader.value = false;
    result.fold((error) {}, (data) {
      campaignInfoModel.value = data;
      restaurantList.value = data.restaurants!
          .where((restaurant) => restaurant.availability == 5)
          .toList();
      updateCampaignOfferRestaurantWithAmount();
    });
  }

  Future<void> getSingleOfferRestaurants({
    required String lat,
    required String long,
    required String deliveryOrderType,
  }) async {
    singleOfferLoader.value = true;
    final result = await _allRestuarantRepo.getSingleOfferRestaurants(
      lat: lat,
      long: long,
      deliveryOrderType: deliveryOrderType,
    );
    singleOfferLoader.value = false;
    result.fold(
      (error) {
        singleOfferLoader.value = false;
      },
      (dataList) {
        singleOfferModel.value = dataList; // for showing extra offer info
        sinlgeOfferRestaurants.value = dataList.data!.restaurants!
            .where((restaurant) => restaurant.availability.toString() == "5")
            .toList();
      },
    );
    singleOfferLoader.value = false;
  }

  seletectMenu(int index) {
    if (selectedMenu.value == index) {
      selectedMenu.value = -1;
    } else {
      selectedMenu.value = index;
    }
  }

  Future<void> checkSingleOffer({
    required String restaurantId,
    required String lat,
    required String long,
  }) async {
    singleOfferLoader.value = true;
    final result = await _allRestuarantRepo.checkSingleOfferRestaurant(
      restaurantId: restaurantId,
      lat: lat,
      long: long,
    );
    singleOfferLoader.value = false;

    if (result.isLeft()) {
      isSingleOfferAvailable = false;
    } else {
      isSingleOfferAvailable = true;
    }

    result.fold((error) {}, (data) {
      checkSingleOfferModel.value = data;
    });
  }

  Future<void> findOffers({
    required String lat,
    required String long,
    required String deliveryOrderType,
  }) async {
    final result = await _allRestuarantRepo.findOffer(
      lat: lat,
      long: long,
      deliveryOrderType: deliveryOrderType,
    );

    result.fold((error) {}, (data) {
      findOfferModel.value = data;

      updateRestaurantWithOfferAmount();
    });
  }

  void updateRestaurantWithOfferAmount() {
    final restaurants = restuarantModel.value.data;
    final offers = findOfferModel.value.data;

    if (restaurants == null || offers == null) return;

    for (int i = 0; i < restaurants.length; i++) {
      final resId = restaurants[i].id.toString();

      final matchedOffers = offers
          .where((offer) => offer.id.toString() == resId)
          .toList();

      if (matchedOffers.isEmpty) continue;

      final maxAmount = matchedOffers
          .map((e) => num.tryParse(e.amount.toString()) ?? 0)
          .reduce((a, b) => a > b ? a : b);

      restaurants[i] = restaurants[i].copyWith(amount: maxAmount.toInt());
    }

    restuarantModel.refresh();
  }
}

class BannerItem {
  final BannerType type;
  final Campaign data;

  BannerItem({required this.type, required this.data});
}

enum BannerType { campaign, offer }
