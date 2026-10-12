import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../address/controller/address_controller.dart';
import '../../../address/widgets/address_bottom_modal_sheet.dart';
import '../../../address/widgets/edit_address_modal_sheet.dart';
import '../../../cart/controller/cart_controller.dart';
import '../../components/add_edit_button.dart';
import '../../components/address_card.dart';
import '../../controller/checkout_controller.dart';

class DeliveryAddressSection extends StatelessWidget {
  const DeliveryAddressSection({
    super.key,
    required this.addressController,
    required this.checkoutController,
    required this.cartController,
  });

  final AddressController addressController;
  final CheckoutController checkoutController;
  final CartController cartController;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () =>
          addressController.addressModel.value.data == null ||
              checkoutController.selectAddress.value == -2 ||
              cartController.isDeliver.value == false
          ? const SizedBox()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*---------- [ Edit - Add button ] ------------ */
                AddEditButtonWidget(
                  editOnTap: () async {
                    await editAddressModalSheet(
                      context: context,
                      addressController: addressController,
                      address: addressController
                          .addressModel
                          .value
                          .data?[checkoutController.selectAddress.value],
                    );
                  },
                  addOnTap: () async {
                    await addressBottomModalSheet(
                      context: context,
                      addressController: addressController,
                    );
                  },
                ),
                SizedBox(height: 18.h),

                SizedBox(
                  height: addressController.addressModel.value.data!.isEmpty
                      ? 0.h
                      : 140.h,
                  child: AddressCard(
                    checkoutController: checkoutController,
                    addressModel: addressController.addressModel.value,
                  ),
                ),
              ],
            ),
    );
  }
}
