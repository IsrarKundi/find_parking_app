import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../controller/utils/color.dart';
import '../../controller/utils/text_styles.dart';

Widget getVerticalSpace({required double height}) {
  return SizedBox(
    height: height,
  );
}

Widget getHorizontalSpace({required double width}) {
  return SizedBox(
    width: width,
  );
}

Widget myCustomTextField({
  String? hintText,
  final Color? hintTextColor,
  Widget? prefixIcon,
  Widget? suffixIcon,
  String? labelText,
  TextInputType? keyboardType,
  bool enable = true,
  bool obscureTextInitially = false,
  bool isPasswordField = false,
  bool isCollapsed = false,
  Color? fillColor,
  Color? bgColor,
  Color? borderColor,
  Color? focusBorderColor,
  Color? titleColor,
  double? fontSize,
  int? maxLines,
  TextAlign? textAlign,
  EdgeInsetsGeometry? contentPadding,
  ValueChanged? onChanged,
  dynamic borderRadius,
  dynamic controller,
})
{
  return StatefulBuilder(
    builder: (BuildContext context, StateSetter setState) {
      bool obscureText = obscureTextInitially;
      return TextField(
        textAlign: textAlign??TextAlign.start,
        onChanged: onChanged,
        controller: controller,
        maxLines: maxLines ?? 1,
        enabled: enable,
        keyboardType: keyboardType,
        cursorColor: AppColor.primaryColor,
        cursorWidth: 2,
        cursorHeight: 25,
        obscuringCharacter: '*',
        obscureText: isPasswordField ? obscureText : false,
        style: AppTextStyles.bodyRegularUpper.copyWith(color: AppColor.blackColor),
        decoration: InputDecoration(
          isCollapsed:isCollapsed ,
          labelText: labelText,
          filled: true,
          contentPadding: contentPadding ?? EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          fillColor: fillColor ?? AppColor.greyColor,
          border: OutlineInputBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(40),
            borderSide:
            BorderSide(color: borderColor ?? AppColor.greyColor, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(40),
            borderSide:
            BorderSide(color: focusBorderColor ?? AppColor.primaryColor, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(40),
            borderSide:
            BorderSide(color: borderColor ?? AppColor.greyColor, width: 1),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(40),
            borderSide:
            BorderSide(color: borderColor ?? AppColor.greyColor, width: 1),
          ),
          hintText: hintText,
          hintStyle: AppTextStyles.bodyRegularUpper.copyWith(
            fontSize: fontSize ?? 14,
            color: hintTextColor ?? AppColor.darkGreyColor,
          ),
          prefixIcon: prefixIcon,
          suffixIcon: isPasswordField
              ? IconButton(
            onPressed: () {
              setState(() {
                obscureText = !obscureText;
              });
            },
            icon: Icon(
              obscureText
                  ? Icons.visibility_off
                  : Icons.visibility,
              color: AppColor.darkGreyColor,
              size: 20,
            ),
          )
              : suffixIcon,
        ),
      );
    },
  );
}
//
class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final TextStyle? textStyle;
  final bool? isLoading;
  final Color? backgroundColor;
  final Color? borderColor;

  final Color? textColor;
  final double? horizontalPadding;
  final double? verticalPadding;

  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.horizontalPadding,
    this.verticalPadding,
    this.isLoading,
    this.textStyle,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shadowColor: Colors.transparent, // Removes grey tap shadow
              splashFactory: NoSplash.splashFactory, // No ripple (optional: replace with custom if needed)
              backgroundColor: backgroundColor ?? AppColor.primaryColor,
              padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding ?? 2.h,
                  vertical: verticalPadding ?? 0.h),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: borderColor ?? AppColor.primaryColor, width: 1.px),
                borderRadius: BorderRadius.circular(40.px),
              ),
            ),

            onPressed: onPressed,
            child: isLoading ?? false
                ? SizedBox(
              height: 20,
              // width: 20,
              child: LoadingAnimationWidget.staggeredDotsWave(color: Colors.white, size: 35),
            )
                : Text(
              text,
              style: textStyle ?? AppTextStyles.bodyRegularUpper.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
                color: textColor ?? AppColor.whiteColor
              ),
            ),
          ),
        ),
      ],
    );
  }
}
// class CustomElevatedButton1 extends StatelessWidget {
//   final String text;
//   final VoidCallback? onPressed;
//   final double? height;
//   final double? width;
//   final double horizontalPadding;
//   final double verticalPadding;
//   final BorderRadiusGeometry borderRadius;
//   final Color backgroundColor;
//   final TextStyle? textStyle;
//   const CustomElevatedButton1({super.key, required this.text, this.onPressed, this.height, this.width, required this.horizontalPadding, required this.verticalPadding, required this.borderRadius, required this.backgroundColor, this.textStyle}); // Optional text style for customization
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: height,
//       width: width,
//       child: ElevatedButton(
//         onPressed: onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: backgroundColor,
//           padding: EdgeInsets.symmetric(
//             horizontal: horizontalPadding,
//             vertical: verticalPadding,
//           ),
//           shape: RoundedRectangleBorder(borderRadius: borderRadius),
//           elevation: 0, // Adjust elevation if needed
//         ),
//         child: Text(
//           text,
//           style: textStyle ??  TextStyle(
//             color: Colors.white,
//             fontSize: 13.px,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//     );
//   }
// }