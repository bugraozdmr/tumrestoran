double getItemPrice({
  required double price,
  required double? discountedPrice,
  required String? discountedOption,
  int singleOfferPercentage = 0,
  bool isSingleOffer = false,
}) {
  if (isSingleOffer) {
    return price - (price * singleOfferPercentage / 100);
  }
  if ((discountedOption ?? '').isNotEmpty &&
      discountedPrice != null &&
      discountedPrice > 0) {
    return discountedPrice;
  } else {
    return price;
  }
}
