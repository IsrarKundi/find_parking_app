import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking_app/views/screens/home/home_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../controller/utils/color.dart';
import '../../../controller/utils/text_styles.dart';
import '../onboarding/onboarding_screens.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    _scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);

    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();

    // Navigate to OnBoarding after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Get.off(() => OnBoardingScreen());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
  gradient: LinearGradient(
    colors: [
      Color(0xFF00C853), // bright green
      Color(0xFF43A047), // deep green
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Logo
              ScaleTransition(
                scale: _scaleAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Image.asset(
                    'assets/svgs/parking_logo.png',
                    height: 22.h,
                    width: 22.h,
                  ),
                ),
              ),
              SizedBox(height: 0.h),
              // Animated Text
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'Parking Buddy',
                  style: AppTextStyles.bodyBoldLower.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                    color: AppColor.whiteColor,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
