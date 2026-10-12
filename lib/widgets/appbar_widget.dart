import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../config/theme/app_color.dart';
import 'text_widget.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  const AppBarWidget({
    super.key,
    required this.text,
    this.iconButton,
    required this.isIcon,
  });
  final String text;
  final IconButton? iconButton;
  final bool? isIcon;

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppBarWidgetState extends State<AppBarWidget> {
  bool isOnline = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.w),
      child: AppBar(
        elevation: 0,
        toolbarHeight: 48.h,
        surfaceTintColor: AppColor.whiteColor,
        backgroundColor: AppColor.whiteColor,
        leadingWidth: double.infinity,
        leading: Padding(
          padding: EdgeInsets.only(left: widget.isIcon != true ? 16.w : 0),
          child: Row(
            children: [
              widget.iconButton ?? const SizedBox(),
              SizedBox(width: widget.isIcon == true ? 8.w : 0),
              TextWidget(
                text: widget.text,
                fontWeight: FontWeight.w600,
                fontSize: 22.sp,
                color: AppColor.black100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
