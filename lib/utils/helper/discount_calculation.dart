double calculateDiscount({
  required bool isCouponApplied,
  required double subTotal,
  required String discountType,
  required double discountValue,
  required double maximumDiscount,
}) {
  if (!isCouponApplied) return 0.0;

  if (discountType == "5") {
    return discountValue;
  }

  if (discountType == "10") {
    final percentageAmount = (subTotal * discountValue) / 100;
    return percentageAmount > maximumDiscount
        ? maximumDiscount
        : percentageAmount;
  }

  return 0.0;
}
