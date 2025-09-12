import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../controller/getx_controllers/parking_controller.dart';
import '../../controller/utils/color.dart';
import '../../controller/utils/text_styles.dart';
import '../custom_widgets/custom_widgets.dart';

class UpdateParkingPopup extends StatefulWidget {
  const UpdateParkingPopup({super.key});

  @override
  State<UpdateParkingPopup> createState() => _UpdateParkingPopupState();
}

class _UpdateParkingPopupState extends State<UpdateParkingPopup> {
  final ParkingController _parkingController = Get.find<ParkingController>();
  final TextEditingController _totalSlotsController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill with current values if available
    final parkingData = _parkingController.parkingLots.value?.data;
    if (parkingData != null && parkingData.isNotEmpty) {
      final parking = parkingData[0];
      _totalSlotsController.text = parking.totalParkingSlots.toString();
      _priceController.text = parking.pricePerSlot.toString();
    }
  }

  @override
  void dispose() {
    _totalSlotsController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _updateParkingInfo() {
    final totalSlots = int.tryParse(_totalSlotsController.text);
    final price = int.tryParse(_priceController.text);

    if (totalSlots == null || totalSlots <= 0) {
      Get.snackbar(
        'Invalid Input',
        'Please enter a valid number for total parking slots',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (price == null || price <= 0) {
      Get.snackbar(
        'Invalid Input',
        'Please enter a valid price per slot',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    _parkingController.setParkingInfo(totalSlots, price);
    Navigator.of(context).pop(); // Close the popup
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: EdgeInsets.all(5.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [AppColor.primaryColor.withOpacity(0.1), AppColor.primaryColor.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.edit,
                  color: AppColor.primaryColor,
                  size: 24.sp,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Update Parking Info',
                  style: AppTextStyles.titleBoldUpper.copyWith(
                    fontSize: 18.sp,
                    color: AppColor.primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),

            // Guidance Text
            Text(
              'Enter the total number of parking slots and the price per slot. These values will be updated for your parking.',
              style: AppTextStyles.bodyRegularUpper.copyWith(
                fontSize: 14.sp,
                color: AppColor.darkGreyColor,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),

            // Total Parking Slots Field
            myCustomTextField(
              hintText: 'Total Parking Slots',
              keyboardType: TextInputType.number,
              controller: _totalSlotsController,
            ),
            SizedBox(height: 2.h),

            // Price per Slot Field
            myCustomTextField(
              hintText: 'Price per Slot (Rs.)',
              keyboardType: TextInputType.number,
              controller: _priceController,
            ),
            SizedBox(height: 4.h),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    text: 'Cancel',
                    onPressed: () => Navigator.of(context).pop(),
                    backgroundColor: AppColor.greyColor,
                    textColor: AppColor.blackColor,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: CustomElevatedButton(
                    text: 'Update',
                    onPressed: _updateParkingInfo,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
