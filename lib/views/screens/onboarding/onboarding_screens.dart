import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../controller/utils/color.dart';
import '../../../controller/utils/text_styles.dart';
import '../../custom_widgets/custom_widgets.dart';
import '../authentication/auth_navigator.dart';
import '../authentication/login_screen.dart';

class OnBoardingController extends GetxController {
  final PageController pageController = PageController();
  RxInt currentIndex = 0.obs;
  final List<Map<String, String>> onboardingData = [
    {
      'image': 'assets/pngs/onboarding_pngs/onboarding1.png',
      'title': 'Welcome to Parking Space Finder!',
      'description':
      'Find the perfect parking spot near you with ease and convenience!',
    },
    {
      'image': 'assets/pngs/onboarding_pngs/onboarding2.png',
      'title': 'Explore Nearby Parking',
      'description':
      'Discover available parking spaces, check prices, and reserve your spot in advance.',
    },
    {
      'image': 'assets/pngs/onboarding_pngs/onboarding3.png',
      'title': 'Navigate with Confidence',
      'description':
      'Get turn-by-turn directions to your parking spot and enjoy a hassle-free parking experience.',
    },
  ];

  // Navigate to the next page or to AuthNavigator if at the last page
  void goToNextOrLogin() {
    if (currentIndex.value < onboardingData.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Get.off(() => const AuthNavigator()); // Replace OnBoardingScreen with AuthNavigator
    }
  }

  // Skip directly to AuthNavigator
  void skipToMain() {
    Get.off(() => const AuthNavigator()); // Replace OnBoardingScreen with AuthNavigator
  }
}

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller, but check if it already exists to avoid reinitialization on hot reload
    final OnBoardingController onBoardingController = Get.put(OnBoardingController());

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          _buildPageView(onBoardingController),
          _buildBottomContainer(context, onBoardingController),
        ],
      ),
    );
  }

  // Build the PageView for onboarding images
  Widget _buildPageView(OnBoardingController controller) {
    return PageView.builder(
      controller: controller.pageController,
      onPageChanged: (index) => controller.currentIndex.value = index,
      itemCount: controller.onboardingData.length,
      itemBuilder: (context, index) {
        final data = controller.onboardingData[index];
        return Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            Positioned(
              top: 0,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.7,
                child: Image.asset(
                  data['image']!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Build the bottom container with title, description, indicators, and buttons
  Widget _buildBottomContainer(BuildContext context, OnBoardingController controller) {
    return Positioned(
      bottom: 0,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.32,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(1),
              blurRadius: 30,
              spreadRadius: 20,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        child: Column(
          children: [
            getVerticalSpace(height: 3.h),
            _buildTitle(controller),
            getVerticalSpace(height: 1.h),
            _buildDescription(controller),
            getVerticalSpace(height: 2.5.h),
            _buildPageIndicators(controller),
            const Spacer(),
            _buildNavigationButtons(controller),
            getVerticalSpace(height: 4.h),
          ],
        ),
      ),
    );
  }

  // Build the page indicators (dots) for the onboarding pages
  Widget _buildPageIndicators(OnBoardingController controller) {
    return Obx(
          () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          controller.onboardingData.length,
              (index) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.w),
            child: Container(
              height: 1.2.h,
              width: controller.currentIndex.value == index ? 9.w : 1.2.h,
              decoration: BoxDecoration(
                color: controller.currentIndex.value == index
                    ? AppColor.yellowColor
                    : AppColor.greyColor,
                borderRadius: controller.currentIndex.value == index
                    ? BorderRadius.circular(9)
                    : BorderRadius.circular(50),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Build the title text for the current onboarding page
  Widget _buildTitle(OnBoardingController controller) {
    return Obx(
          () => Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Text(
          controller.onboardingData[controller.currentIndex.value]['title']!,
          style: AppTextStyles.titleBoldUpper.copyWith(
            fontSize: 19.sp,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // Build the description text for the current onboarding page
  Widget _buildDescription(OnBoardingController controller) {
    return Container(
      height: 7.5.h,
      padding: EdgeInsets.symmetric(horizontal: 7.4.w),
      child: Obx(
            () => Text(
          controller.onboardingData[controller.currentIndex.value]['description']!,
          style: AppTextStyles.headerRegularUpper.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  // Build the navigation buttons (Skip, Next/Get Started)
  Widget _buildNavigationButtons(OnBoardingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Obx(
            () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (controller.currentIndex.value != controller.onboardingData.length - 1)
              InkWell(
                onTap: controller.skipToMain,
                child: Text(
                  'Skip',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            else
              const SizedBox.shrink(),
            controller.currentIndex.value == controller.onboardingData.length - 1
                ? _buildGetStartedButton(controller)
                : _buildNextButton(controller),
          ],
        ),
      ),
    );
  }

  // Build the "Get Started" button for the last onboarding page
  Widget _buildGetStartedButton(OnBoardingController controller) {
    return Container(
      width: 30.w,
      height: 5.5.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(4.h),
          bottomLeft: Radius.circular(4.h),
        ),
        color: AppColor.primaryColor,
      ),
      child: Center(
        child: TextButton(
          onPressed: controller.goToNextOrLogin,
          child: Text(
            'Get Started',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  // Build the "Next" button for onboarding pages
  Widget _buildNextButton(OnBoardingController controller) {
    return Container(
      width: 30.w,
      height: 5.5.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(4.h),
          bottomLeft: Radius.circular(4.h),
        ),
        color: AppColor.primaryColor,
      ),
      child: Center(
        child: TextButton(
          onPressed: controller.goToNextOrLogin,
          child: Text(
            'Next',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}