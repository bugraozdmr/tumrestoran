import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/theme/app_color.dart';

// ignore: must_be_immutable
class PrimaryTextField extends StatefulWidget {
  PrimaryTextField({
    super.key,
    this.controller,
    this.validator,
    this.keyboardType,
    required this.obscureText,
    required this.passwordVisible,
    required this.suffixIcon,
    this.prefix,
    required this.prefixIcon,
  });
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  bool passwordVisible;
  final Widget? prefix;
  final bool suffixIcon;
  final bool prefixIcon;
  final bool obscureText;

  @override
  State<PrimaryTextField> createState() => _PrimaryTextFieldState();
}

class _PrimaryTextFieldState extends State<PrimaryTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      textInputAction: TextInputAction.next,
      obscureText: widget.passwordVisible,
      cursorColor: AppColor.black100,
      validator: widget.validator,
      style: GoogleFonts.urbanist(
        color: AppColor.black100,
        fontWeight: FontWeight.w400,
        fontSize: 14.sp,
      ),
      decoration: InputDecoration(
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(width: 1.w, color: AppColor.primaryColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(width: 1.w, color: AppColor.primaryColor),
        ),
        fillColor: Colors.red,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.r)),
          borderSide: BorderSide(color: AppColor.primaryColor, width: 1.w),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.r)),
          borderSide: BorderSide(width: 1.w, color: AppColor.black20),
        ),
        prefixIcon: widget.prefixIcon ? widget.prefix : null,
        suffixIcon: widget.suffixIcon
            ? IconButton(
                icon: Icon(
                  widget.passwordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: AppColor.black80,
                ),
                onPressed: () {
                  setState(() {
                    widget.passwordVisible = !widget.passwordVisible;
                  });
                },
              )
            : const SizedBox(),
      ),
    );
  }
}
