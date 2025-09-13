import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../controller/getx_controllers/user_home_controller.dart';
import '../custom_widgets/custom_widgets.dart';
import '../../controller/utils/color.dart';
import '../../controller/utils/text_styles.dart';

class PaymentBottomSheet extends StatefulWidget {
  final double parkingPrice;

  const PaymentBottomSheet({super.key, required this.parkingPrice});

  @override
  State<PaymentBottomSheet> createState() => _PaymentBottomSheetState();
}

class _PaymentBottomSheetState extends State<PaymentBottomSheet> {
  final UserHomeController _controller = Get.find<UserHomeController>();
  final TextEditingController _carNumberController = TextEditingController();

  @override
  void dispose() {
    _carNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            height: 5,
            width: 50,
            margin: EdgeInsets.only(bottom: 2.h),
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(12),
            ),
          ),

          // Title
          Text(
            'Confirm Your Payment',
            style: AppTextStyles.titleBoldUpper.copyWith(
              fontSize: 18.sp,
              color: AppColor.blackColor,
            ),
          ),
          SizedBox(height: 1.h),

          // Amount summary card
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 3,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Row(
                children: [
                  Icon(Icons.attach_money,
                      color: AppColor.primaryColor, size: 22.sp),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Parking Fee',
                          style: AppTextStyles.bodyRegularUpper.copyWith(
                            fontSize: 15.sp,
                            color: AppColor.darkGreyColor,
                          ),
                        ),
                        Text(
                          'Rs. ${widget.parkingPrice}',
                          style: AppTextStyles.titleBoldUpper.copyWith(
                            fontSize: 17.sp,
                            color: AppColor.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 2.h),

          // Vehicle number input
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Vehicle Number Plate",
              style: AppTextStyles.bodyBoldUpper.copyWith(
                fontSize: 14.sp,
                color: AppColor.darkGreyColor,
              ),
            ),
          ),
          SizedBox(height: 0.5.h),
          myCustomTextField(
            controller: _carNumberController,
            hintText: 'e.g., ABC123',
            // bgColor: AppColor.blackColor,
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: 2.h),

          // Payment methods row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _paymentMethodIcon(Icons.credit_card, "Card"),
              _paymentMethodIcon(Icons.account_balance_wallet, "Wallet"),
              _paymentMethodIcon(Icons.money, "Cash"),
            ],
          ),
          SizedBox(height: 3.h),

          // Payment button
          Obx(() => CustomElevatedButton(
                text: 'Pay & Confirm',
                isLoading: _controller.isMakingPayment.value,
                onPressed: () async {
                  if (_carNumberController.text.isNotEmpty) {
                    await _controller
                        .makeEntryToParking(_carNumberController.text);
                    if (_controller.isMakingPayment.value == false) {
                      Navigator.of(context).pop();
                    }
                  } else {
                    Get.snackbar(
                      'Error',
                      'Please enter vehicle number plate',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                },
              )),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  // Small reusable widget for payment methods
  Widget _paymentMethodIcon(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: AppColor.primaryColor.withOpacity(0.1),
          radius: 25,
          child: Icon(icon, color: AppColor.primaryColor, size: 22.sp),
        ),
        SizedBox(height: 1.h),
        Text(
          label,
          style: AppTextStyles.bodyRegularUpper.copyWith(
            fontSize: 13.sp,
            color: AppColor.darkGreyColor,
          ),
        ),
      ],
    );
  }
}
