import 'package:flutter/material.dart';
import 'package:foodnanny/app/features/cart/model/cart_model.dart';
import 'package:foodnanny/app/features/checkout/controller/checkout_controller.dart';
import 'package:foodnanny/config/theme/app_color.dart';
import 'package:foodnanny/data/model/item_details_model.dart';
import 'package:foodnanny/data/server/server.dart';
import 'package:foodnanny/main.dart';
import 'package:foodnanny/utils/api_list.dart';
import 'package:foodnanny/widgets/custom_snackbar.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final checkoutController = Get.put(CheckoutController());
  final selectedVariationList = <Variation>[].obs;
  final selectedExtrasList = <Extra>[].obs;
  final isDeliver = true.obs;
  final cartItems = <CartModel>[].obs;
  final addonCartList = <AddonCartModel>[].obs;
  final selectedAddonList = <AddonCartModel>[].obs;
  final numOfItems = 1.obs;
  final restaurantName = "".obs;
  final restId = 0.obs;
  final foodPreparationTime = 0.obs;
  final taxAmount = 0.0.obs;

  final finalTotalAmount = 0.0.obs;
  final extraDeliveryFee = 0.0.obs;

  final deliveryStatus = 5.obs;
  final takewayStatus = 5.obs;

  final instructorTextController = TextEditingController();
  String extrasText = "";
  final itemsTotalPrice = 0.0.obs;
  final addonTotalPrice = 0.0.obs;
  int variationId = 0;
  List<Extra> extrasList = [];

  void addToCart({
    required MainItem product,
    double? itemPrice,
    List<Variation>? variationObject,
    List<Extra>? extrasObject,
    dynamic addonObject,
    int? restaurantId,
    int? variationId,
    List<int>? extrasId,
    String? extrasText,
    String? instructionText,
    double? variationTotalPrice,
    double? extrasTotalPrice,
    double? selectedAddonPrice,
    double? itemPriceForTax,
    double? taxRate,
    double? subtotal,
    double? total,
    double? addonTotalprice,
  }) {
    final maxQty = double.parse(product.maximumPurchaseQnty ?? '100');

    final clearCart =
        cartItems.isNotEmpty &&
        cartItems.any((item) => item.restaurantId != restaurantId);

    if (clearCart) {
      cartItems.clear();
      addonCartList.clear();
    }

    final existingItem = cartItems.firstWhereOrNull(
      (item) =>
          item.product.id == product.id &&
          _compareLists(item.variationObject, variationObject) &&
          _compareExtras(item.extrasObject, extrasObject),
    );

    final int finalQty = existingItem != null
        ? existingItem.quantity.value + numOfItems.value
        : numOfItems.value;

    if (finalQty > maxQty) {
      customSnackbar(
        "ERROR".tr,
        "MAXIMUM_PURCHASE_QUANTITY_LIMIT_EXCEEDED".tr,
        AppColor.rejectedTextColor,
      );
      return;
    }

    if (existingItem != null) {
      existingItem.quantity.value = finalQty;
      return;
    }

    cartItems.add(
      CartModel(
        product: product,
        itemPrice: itemPrice,
        quantity: numOfItems.value,
        restaurantId: restaurantId,
        variationId: variationId,
        extrasId: extrasId,
        extrasText: extrasText,
        instructionText: instructionText,
        variationObject: variationObject,
        extrasObject: extrasObject,
        itemPriceForTax: itemPriceForTax,
        taxRate: taxRate,
        variationTotalPrice: variationTotalPrice,
        extrasTotalPrice: extrasTotalPrice,
        addonTotalPrice: selectedAddonPrice,
        subtotal: subtotal,
        total: total,
      ),
    );
  }

  void addToCartAddon() {
    for (final selectedAddon in selectedAddonList) {
      final maxQty = double.parse(
        selectedAddon.addon.addonMaximumPurchaseQnty ?? '100',
      );

      final index = addonCartList.indexWhere(
        (e) => e.addon.id == selectedAddon.addon.id,
      );

      final int finalQty = index != -1
          ? addonCartList[index].quantity.value + selectedAddon.quantity.value
          : selectedAddon.quantity.value;

      if (finalQty > maxQty) {
        customSnackbar(
          "ERROR".tr,
          "MAXIMUM_PURCHASE_QUANTITY_LIMIT_EXCEEDED".tr,
          AppColor.rejectedTextColor,
        );
        return;
      }

      if (index != -1) {
        addonCartList[index].quantity.value = finalQty;
      } else {
        addonCartList.add(
          AddonCartModel(
            addon: selectedAddon.addon,
            quantity: selectedAddon.quantity.value,
            addonCurrentPrice: selectedAddon.addonCurrentPrice,
          ),
        );
      }
    }
  }

  void incrementAddon(Addon addon) {
    final item = selectedAddonList.firstWhere((e) => e.addon.id == addon.id);

    final maxQnty = double.parse(item.addon.addonMaximumPurchaseQnty ?? '100');
    if (item.quantity.value < maxQnty) {
      item.quantity.value++;
    } else {
      customSnackbar(
        "ERROR".tr,
        "MAXIMUM_PURCHASE_QUANTITY_LIMIT_EXCEEDED".tr,
        AppColor.rejectedTextColor,
      );
    }
  }

  void decrementAddon(Addon addon) {
    final index = selectedAddonList.indexWhere((e) => e.addon.id == addon.id);

    if (index != -1) {
      final item = selectedAddonList[index];

      if (item.quantity.value > 1) {
        item.quantity.value--;
      }
    }
  }

  void removeAddon(Addon addon) {
    final index = selectedAddonList.indexWhere((e) => e.addon.id == addon.id);
    if (index != -1) {
      selectedAddonList.removeAt(index);
    }
  }

  void selectedAddon(AddonCartModel addonCartModel) {
    selectedAddonList.add(
      AddonCartModel(
        addon: addonCartModel.addon,
        quantity: 1,
        addonCurrentPrice: addonCartModel.addonCurrentPrice,
      ),
    );
  }

  bool isAddonSelected(Addon addon) {
    return selectedAddonList.any((e) => e.addon.id == addon.id);
  }

  double get selectedAddonTotal {
    double total = 0.0;
    for (var addon in selectedAddonList) {
      total += (addon.addonCurrentPrice) * addon.quantity.value;
    }
    return total;
  }

  double get addonCartTotal {
    double total = 0.0;
    for (var addon in addonCartList) {
      total += addon.addonCurrentPrice * addon.quantity.value;
    }
    return total;
  }

  AddonCartModel? getAddonCartItem(Addon addon) {
    try {
      return selectedAddonList.firstWhere((e) => e.addon.id == addon.id);
    } catch (_) {
      return null;
    }
  }

  void incrementItem(CartModel cartItem) {
    final maxPurchaseQnty = double.parse(
      cartItem.product.maximumPurchaseQnty ?? "100",
    );
    if (cartItem.quantity.value < maxPurchaseQnty) {
      cartItem.quantity.value++;
    } else {
      customSnackbar(
        "ERROR".tr,
        "MAXIMUM_PURCHASE_QUANTITY_LIMIT_EXCEEDED".tr,
        AppColor.rejectedTextColor,
      );
    }
  }

  void decrementItem(CartModel cartItem) {
    if (cartItem.quantity > 1) {
      cartItem.quantity.value--;
    }
  }

  double get totalPrice {
    final totalPrice = 0.0.obs;
    for (var item in cartItems) {
      totalPrice.value +=
          item.quantity * double.parse(item.itemPrice.toString());
    }
    return totalPrice.value;
  }

  void selectVariation(Variation variation, selectedVariationPrice) {
    bool found = false;

    for (int i = 0; i < selectedVariationList.length; i++) {
      if (selectedVariationList[i].itemAttributeId ==
              variation.itemAttributeId &&
          selectedVariationList[i].id == variation.id) {
        found = true;
        break;
      } else if (selectedVariationList[i].itemAttributeId ==
          variation.itemAttributeId) {
        selectedVariationList.removeAt(i);
        selectedVariationList.add(variation);
        found = true;
        break;
      }
    }

    if (!found) {
      selectedVariationList.add(variation);
    }
  }

  void selectExtras(Extra extras) {
    if (selectedExtrasList.contains(extras)) {
      selectedExtrasList.remove(extras);
    } else {
      selectedExtrasList.add(extras);
    }
  }

  Future<bool> placeOrder({
    required addressId,
    required int? couponId,
    required double cutlery,
    required deliveryFee,
    required deliveryTime,
    required double discount,
    required isAdvancedOrder,
    required items,
    required orderType,
    required paymentMethod,
    required restaurantId,
    required double riderTip,
    required double serviceFee,
    required source,
    required double subtotal,
    required double tax,
    required double total,
    double? extraDeliveryFee,
  }) async {
    try {
      final response = await Server().postRequestWithToken(
        endpoint: ApiList.placeOrder,
        body: {
          "address_id": addressId,
          "coupon_id": couponId,
          "cutlery": cutlery,
          "delivery_fee": deliveryFee,
          'extra_delivery_fee': extraDeliveryFee,
          "delivery_time": deliveryTime,
          "discount": discount,
          "is_advance_order": isAdvancedOrder,
          "items": items,
          "order_type": orderType,
          "payment_method": paymentMethod,
          "restaurant_id": restaurantId,
          "rider_tip": riderTip,
          "service_fee": serviceFee,
          "source": source,
          "subtotal": subtotal,
          "tax": tax,
          "total": total,
        },
      );

      if (response.statusCode == 201) {
        box.write("orderId", response.data["data"]["id"]);
        return true;
      } else if (response.statusCode == 422) {
        customSnackbar(
          "ERROR".tr,
          response.data['message'],
          AppColor.negativeDark,
        );

        return false;
      }
    } catch (e) {
      customSnackbar("ERROR".tr, e.toString(), AppColor.negativeDark);
      return false;
    }

    return false;
  }

  getItemQuantityInCheckout(int index) {
    return cartItems[index].quantity.toString();
  }

  bool _compareLists<T>(List<T>? list1, List<T>? list2) {
    if (list1 == null && list2 == null) {
      return true;
    } else if (list1 == null || list2 == null) {
      return false;
    } else {
      if (list1.length != list2.length) {
        return false;
      }

      Set<T> set1 = Set.from(list1);
      Set<T> set2 = Set.from(list2);

      return set1.containsAll(set2) && set2.containsAll(set1);
    }
  }

  bool _compareExtras(List<Extra>? list1, List<Extra>? list2) {
    if (list1 == null && list2 == null) {
      return true;
    } else if (list1 == null || list2 == null) {
      return false;
    } else {
      if (list1.length != list2.length) {
        return false;
      }

      Set<Extra> set1 = Set.from(list1);
      Set<Extra> set2 = Set.from(list2);

      return set1.containsAll(set2) && set2.containsAll(set1);
    }
  }
}
