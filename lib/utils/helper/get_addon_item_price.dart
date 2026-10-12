double getAddonItemPrice({
  required double addonItemPrice,
  required double totalConvertPrice,
  required double variationTotal,

  int singleOfferPercentage = 0,
  bool isSingleOffer = false,
}) {
  if (isSingleOffer) {
    return (addonItemPrice + variationTotal) -
        (addonItemPrice * singleOfferPercentage / 100);
  } else {
    return totalConvertPrice;
  }
}
