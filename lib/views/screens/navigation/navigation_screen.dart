import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../controller/utils/color.dart';
import '../../../controller/utils/text_styles.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Navigation',
          style: AppTextStyles.titleBoldUpper.copyWith(
            color: AppColor.whiteColor,
            fontSize: 18.sp,
          ),
        ),
        backgroundColor: AppColor.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColor.whiteColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColor.primaryColor.withOpacity(0.1),
              AppColor.whiteColor,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Navigation Icon
              Container(
                width: 25.w,
                height: 25.w,
                decoration: BoxDecoration(
                  color: AppColor.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.navigation,
                  color: AppColor.whiteColor,
                  size: 15.w,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Turn-by-turn Directions',
                style: AppTextStyles.titleBoldUpper.copyWith(
                  fontSize: 20.sp,
                  color: AppColor.blackColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 2.h),
              Text(
                'Navigation feature coming soon!',
                style: AppTextStyles.bodyRegularUpper.copyWith(
                  color: AppColor.darkGreyColor,
                  fontSize: 16.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}