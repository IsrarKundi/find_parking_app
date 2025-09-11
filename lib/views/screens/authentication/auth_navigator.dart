import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../controller/utils/color.dart';
import '../../../controller/utils/text_styles.dart';
import '../../custom_widgets/custom_widgets.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class AuthNavigator extends StatefulWidget {
  const AuthNavigator({super.key});

  @override
  State<AuthNavigator> createState() => _AuthNavigatorState();
}

class _AuthNavigatorState extends State<AuthNavigator> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/pngs/authentication_pngs/auth_navigator_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 14.h,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height * 0.7,
                child: Row(
                  children: [
                    Expanded(
                      child: Image.asset(
                        'assets/pngs/authentication_pngs/auth_navigator1.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Image.asset(
                        'assets/pngs/authentication_pngs/auth_navigator2.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                )
              ),
            ),
            Positioned(
              top: 38.h,
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.73,
                  // height: MediaQuery.of(context).size.height * 0.2,
                  child: Image.asset(
                    'assets/pngs/authentication_pngs/auth_navigator3.png',
                    fit: BoxFit.cover,
                  )
              ),
            ),
            Positioned(
              top: 64.h,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.33,
                color: Colors.white.withOpacity(0.8),
                padding: EdgeInsets.symmetric(horizontal: 4.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.h),
                      child: Text(
                          'Find Parking with Ease!',
                          style: AppTextStyles.titleBoldUpper.copyWith(
                        fontSize: 19.sp,
                      ),
                      textAlign: TextAlign.center,
                      ),
                    ),
                    getVerticalSpace(height: .5.h),
                    Text(
                      'Sign in to access nearby parking spots, reserve spaces, and navigate effortlessly. Start your parking journey today!',
                      style: AppTextStyles.bodyRegularUpper.copyWith(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 3.h),
                    CustomElevatedButton(text: "Sign In", onPressed: () => Get.to(() => const LoginScreen())),
                    CustomElevatedButton(
                      text: "Sign Up",
                      onPressed: () => Get.to(() => const RegisterScreen()),
                      backgroundColor: Colors.transparent,
                     textColor: AppColor.primaryColor,
                    )

                  ],
                ),
              ),
            ),
          ],
        )
      )
    );
  }
}
