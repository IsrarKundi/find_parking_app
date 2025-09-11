import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../controller/getx_controllers/auth_controller.dart';
import '../../../controller/utils/color.dart';
import '../../../controller/utils/text_styles.dart';
import '../../custom_widgets/custom_widgets.dart';
import 'location_selection_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthController _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Logo/Icon
                SizedBox(height: 3.h),
                Container(
                  height: 12.h,
                  width: 12.h,
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.person_add_alt_1,
                      size: 6.h, color: AppColor.primaryColor),
                ),

                SizedBox(height: 3.h),

                /// Title
                Text(
                  'Create Account',
                  style: AppTextStyles.titleBoldUpper.copyWith(
                    fontSize: 22.sp,
                    color: AppColor.primaryColor,
                  ),
                ),
                SizedBox(height: 0.8.h),
                Text(
                  'Register to start using Parking Buddy',
                  style: AppTextStyles.bodyRegularUpper.copyWith(
                    fontSize: 16.sp,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 5.h),

                /// Name
                myCustomTextField(
                  hintText: 'Name',
                  controller: _authController.nameController,
                ),
                SizedBox(height: 2.5.h),

                /// Email
                myCustomTextField(
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  controller: _authController.emailController,
                ),
                SizedBox(height: 2.5.h),

                /// Password
                myCustomTextField(
                  hintText: 'Password',
                  isPasswordField: true,
                  controller: _authController.passwordController,
                ),
                SizedBox(height: 2.5.h),

                /// Confirm Password
                myCustomTextField(
                  hintText: 'Confirm Password',
                  isPasswordField: true,
                  controller: _authController.confirmPasswordController,
                ),
                SizedBox(height: 2.5.h),

                /// Role Dropdown
                Obx(() => Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.h),
                      decoration: BoxDecoration(
                        color: AppColor.greyColor,
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(color: AppColor.greyColor),
                      ),
                      child: DropdownButton<String>(
                        value: _authController.selectedRole.value,
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: _authController.roles.map((String role) {
                          return DropdownMenuItem<String>(
                            value: role,
                            child: Text(
                              role == 'user' ? 'User' : 'Parking Owner',
                              style: AppTextStyles.bodyRegularUpper.copyWith(
                                color: AppColor.blackColor,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            _authController.selectedRole.value = newValue;
                          }
                        },
                      ),
                    )),

                SizedBox(height: 2.5.h),

                /// Location (if Parking Owner)
                Obx(() {
                  if (_authController.selectedRole.value == 'parking owner') {
                    return Column(
                      children: [
                        CustomElevatedButton(
                          text: 'Choose Location',
                          onPressed: () {
                            Get.to(() => const LocationSelectionScreen());
                          },
                          backgroundColor: AppColor.greyColor,
                          textColor: AppColor.blackColor,
                        ),
                        SizedBox(height: 1.5.h),
                        Obx(() => Text(
                              _authController.selectedLocation.value != null
                                  ? 'Location selected: ${_authController.selectedLocation.value!.latitude.toStringAsFixed(4)}, ${_authController.selectedLocation.value!.longitude.toStringAsFixed(4)}'
                                  : 'No location selected',
                              style:
                                  AppTextStyles.bodyRegularUpper.copyWith(
                                color: AppColor.darkGreyColor,
                                fontSize: 12.sp,
                              ),
                              textAlign: TextAlign.center,
                            )),
                        SizedBox(height: 2.h),
                      ],
                    );
                  }
                  return const SizedBox();
                }),

                /// Register Button
                Obx(() => CustomElevatedButton(
                      text: 'Register',
                      onPressed: _authController.register,
                      isLoading: _authController.isLoading.value,
                    )),

                SizedBox(height: 3.h),

                /// Login Redirect
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: AppTextStyles.bodyRegularUpper.copyWith(
                        color: Colors.grey.shade700,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Text(
                        'Login',
                        style: AppTextStyles.bodyRegularUpper.copyWith(
                          color: AppColor.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 3.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
