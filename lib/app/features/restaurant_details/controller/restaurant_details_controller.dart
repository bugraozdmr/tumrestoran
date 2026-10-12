import 'package:foodnanny/app/features/cart/controller/cart_controller.dart';
import 'package:foodnanny/data/model/item_details_model.dart';
import 'package:foodnanny/data/model/restaurant_details.dart';
import 'package:foodnanny/data/model/restaurant_offer_model.dart';
import 'package:foodnanny/data/repository/restaurant_details_repo.dart';
import 'package:foodnanny/main.dart';
import 'package:get/get.dart';
import '../../../../data/model/item_category_model.dart';

class RestaurantDetailsController extends GetxController {
  final RestuarantDetailsRepo _detailsRepo = RestuarantDetailsRepo();
  final restaurantDetails = RestaurantDetailsModel().obs;
  var itemCategoryDetails = ItemCategoryDetailsModel().obs;
  final itemDetails = ItemDetailsModel().obs;
  final restaurantOfferModel = RestaurantOfferModel().obs;
  final isInfo = true.obs;
  final fakeResDetailsInt = RxInt(-1);
  final minimumOrderLimit = 0.obs;
  final showSearch = false.obs;
  final filteredItemCategoryList = <ItemCategoryDetails>[].obs;
  final filterItemModel = <ItemCategoryDetails>[].obs;
  final searchQueryText = "".obs;
  final isModalOpen = false.obs;
  final restDetailsLoader = false.obs;
  final vegPress = false.obs;
  final nonVegPress = false.obs;

  Future<RestaurantDetailsModel?> getRestaurantDetails({
    required String slug,
  }) async {
    restDetailsLoader.value = true;
    box.remove("minimumOrder");
    final data = await _detailsRepo.getRestuarantDetails(slug: slug);
    restDetailsLoader.value = false;

    data.fold((error) => null, (data) async {
      restaurantDetails.value = data;

      if (restaurantDetails.value.data != null) {
        minimumOrderLimit.value =
            restaurantDetails.value.data!.orderSetup!.minimumOrderLimit!;
        await box.write("minimumOrder", minimumOrderLimit.value);
        await box.write(
          'restaurantLat',
          restaurantDetails.value.data!.latitude,
        );
        await box.write(
          'restaurantLong',
          restaurantDetails.value.data!.longitude,
        );
        Get.find<CartController>().deliveryStatus.value =
            restaurantDetails.value.data?.orderSetup?.delivery ?? 0;
        Get.find<CartController>().takewayStatus.value =
            restaurantDetails.value.data?.orderSetup?.takeaway ?? 0;
      }

      return restaurantDetails.value;
    });
    return null;
  }

  Future<ItemCategoryDetailsModel?> getItemCategoryDetails({
    required String slug,
  }) async {
    final data = await _detailsRepo.getItemCategoryDetails(slug: slug);
    data.fold((error) => null, (data) {
      itemCategoryDetails.value = data;
      filterItemModel.value = data.data!;
      return data.data;
    });
    return null;
  }

  Future<void> getItemDetails({required String slug}) async {
    final data = await _detailsRepo.getItemDetails(slug: slug);
    data.fold((error) => null, (data) {
      itemDetails.value = data;
    });
  }

  Future<void> getOfferForRestaurant({
    required String restaurantId,
    required String lat,
    required String long,
  }) async {
    final data = await _detailsRepo.getOfferForRestaurant(
      restaurantId: restaurantId,
      lat: lat,
      long: long,
    );
    data.fold((error) => null, (data) {
      restaurantOfferModel.value = data;
    });
  }

  void searchMenuByName(String query) {
    query = query.toLowerCase();
    filteredItemCategoryList.clear();

    for (var itemMenu in filterItemModel) {
      final matchingItems = (itemMenu.items ?? [])
          .where((item) => item.name?.toLowerCase().contains(query) ?? false)
          .toList();

      if (matchingItems.isNotEmpty) {
        final filteredCategory = ItemCategoryDetails(
          id: itemMenu.id,
          name: itemMenu.name,
          items: matchingItems,
        );

        filteredItemCategoryList.add(filteredCategory);
      }
    }
  }

  void filterByItemVegNonVeg(int type) {
    filteredItemCategoryList.clear();

    for (var itemMenu in filterItemModel) {
      final matchingItems = (itemMenu.items ?? [])
          .where((item) => item.itemType == type)
          .toList();

      if (matchingItems.isNotEmpty) {
        final filteredCategory = ItemCategoryDetails(
          id: itemMenu.id,
          name: itemMenu.name,
          items: matchingItems,
        );

        filteredItemCategoryList.add(filteredCategory);
      }
    }
  }

  void resetFilters() {
    filteredItemCategoryList.clear();
    searchQueryText.value = "";
    showSearch.value = false;
    vegPress.value = false;
    nonVegPress.value = false;
  }
}
