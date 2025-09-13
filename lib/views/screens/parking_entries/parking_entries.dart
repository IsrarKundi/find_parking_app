// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';

// import '../../../controller/getx_controllers/parking_controller.dart';
// import '../../../controller/utils/color.dart';
// import '../../../controller/utils/text_styles.dart';
// import '../../../models/get_parking_enteries_model.dart';

// class ParkingEntriesScreen extends StatefulWidget {
//   const ParkingEntriesScreen({super.key});

//   @override
//   State<ParkingEntriesScreen> createState() => _ParkingEntriesScreenState();
// }

// class _ParkingEntriesScreenState extends State<ParkingEntriesScreen> {
//   final ParkingController _parkingController = Get.find<ParkingController>();

//   @override
//   void initState() {
//     super.initState();
//     _parkingController.getParkingEntries();
//   }

//   String _formatEntryTime(DateTime entryTime) {
//     final now = DateTime.now();
//     final difference = now.difference(entryTime);

//     if (difference.inDays > 0) {
//       return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
//     } else if (difference.inHours > 0) {
//       return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
//     } else if (difference.inMinutes > 0) {
//       return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
//     } else {
//       return 'Just now';
//     }
//   }

//   void _showExitDialog(Entry entry) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(
//           'Exit Vehicle',
//           style: AppTextStyles.titleBoldUpper.copyWith(
//             color: AppColor.blackColor,
//             fontSize: 18.sp,
//           ),
//         ),
//         content: Text(
//           'Is the vehicle with number plate "${entry.carNumber}" leaving the parking?',
//           style: AppTextStyles.bodyRegularUpper.copyWith(
//             color: AppColor.darkGreyColor,
//             fontSize: 14.sp,
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: Text(
//               'Cancel',
//               style: AppTextStyles.bodyRegularUpper.copyWith(
//                 color: AppColor.primaryColor,
//               ),
//             ),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               _parkingController.exitParkingEntry(entry.id);
//             },
//             child: Text(
//               'Yes, Exit',
//               style: AppTextStyles.bodyRegularUpper.copyWith(
//                 color: Colors.red,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Parking Entries',
//           style: AppTextStyles.titleBoldUpper.copyWith(
//             color: AppColor.whiteColor,
//             fontSize: 18.sp,
//           ),
//         ),
//         backgroundColor: AppColor.primaryColor,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back,
//             color: AppColor.whiteColor,
//           ),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ),
//       body: Obx(() {
//         if (_parkingController.isLoadingEntries.value) {
//           return Center(
//             child: CircularProgressIndicator(color: AppColor.primaryColor),
//           );
//         }

//         final entries = _parkingController.parkingEntries.value?.data.entries ?? [];

//         if (entries.isEmpty) {
//           return Center(
//             child: Text(
//               'No parking entries found',
//               style: AppTextStyles.bodyRegularUpper.copyWith(
//                 fontSize: 16.sp,
//                 color: AppColor.darkGreyColor,
//               ),
//             ),
//           );
//         }

//         return ListView.builder(
//           padding: EdgeInsets.all(4.w),
//           itemCount: entries.length,
//           itemBuilder: (context, index) {
//             final entry = entries[index];
//             return Card(
//               elevation: 4,
//               margin: EdgeInsets.only(bottom: 2.h),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: EdgeInsets.all(4.w),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         CircleAvatar(
//                           radius: 20.sp,
//                           backgroundImage: entry.user.image.isNotEmpty
//                               ? NetworkImage(entry.user.image)
//                               : null,
//                           child: entry.user.image.isEmpty
//                               ? Icon(
//                                   Icons.person,
//                                   color: AppColor.primaryColor,
//                                   size: 20.sp,
//                                 )
//                               : null,
//                         ),
//                         SizedBox(width: 3.w),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 entry.user.username,
//                                 style: AppTextStyles.bodyBoldUpper.copyWith(
//                                   fontSize: 16.sp,
//                                   color: AppColor.blackColor,
//                                 ),
//                               ),
//                               Text(
//                                 entry.user.email,
//                                 style: AppTextStyles.bodyRegularUpper.copyWith(
//                                   fontSize: 12.sp,
//                                   color: AppColor.darkGreyColor,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 2.h),
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.directions_car,
//                           color: AppColor.primaryColor,
//                           size: 18.sp,
//                         ),
//                         SizedBox(width: 2.w),
//                         Text(
//                           'Car Number: ${entry.carNumber}',
//                           style: AppTextStyles.bodyRegularUpper.copyWith(
//                             fontSize: 14.sp,
//                             color: AppColor.blackColor,
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 1.h),
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.access_time,
//                           color: AppColor.primaryColor,
//                           size: 18.sp,
//                         ),
//                         SizedBox(width: 2.w),
//                         Text(
//                           'Entry Time: ${_formatEntryTime(entry.entryTime)}',
//                           style: AppTextStyles.bodyRegularUpper.copyWith(
//                             fontSize: 14.sp,
//                             color: AppColor.blackColor,
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 2.h),
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: ElevatedButton(
//                         onPressed: () => _showExitDialog(entry),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.red,
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 4.w,
//                             vertical: 1.h,
//                           ),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                         child: Text(
//                           'Exit Vehicle',
//                           style: AppTextStyles.bodyRegularUpper.copyWith(
//                             color: AppColor.whiteColor,
//                             fontSize: 12.sp,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       }),
//     );
//   }
// }
