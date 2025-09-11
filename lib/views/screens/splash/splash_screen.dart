import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../controller/utils/color.dart';
import '../../../controller/utils/text_styles.dart';
import '../onboarding/onboarding_screens.dart';
import '../../../main.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Get.to(() => OnBoardingScreen());
    });

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/pngs/splash_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SVG Logo
              SvgPicture.asset(
                'assets/svgs/logo.svg',
                height: 20.h, // Add size to match design proportions
                width: 20.h,
              ),
              SizedBox(height: 2.h), // Spacing between logo and text
              // "Parking Space Finder" text
              Text(
                'Parking Space Finder',
                style: AppTextStyles.bodyRegularUpper.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                  color: AppColor.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}