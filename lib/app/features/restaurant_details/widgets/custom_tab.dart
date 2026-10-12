import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tumrestoran/config/theme/app_color.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/svg_icon.dart';

class CustomTab extends StatelessWidget {
  const CustomTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: TabBar(
        isScrollable: true,
        unselectedLabelColor: AppColor.black80,
        labelColor: AppColor.primaryColor,
        indicatorColor: AppColor.primaryColor,
        tabs: [
          SvgPicture.asset(SvgIcon.searchNormal),
          Tab(
            child: SubTitle(
              text: 'Popular Items',
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          Tab(
            child: SubTitle(
              text: 'Breakfast',
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          Tab(
            child: SubTitle(
              text: 'Burgers',
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          Tab(
            child: SubTitle(
              text: 'Chicken & Fry',
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class SubTitle extends StatelessWidget {
  const SubTitle({
    super.key,
    required this.text,
    this.fontSize,
    this.color = AppColor.black100,
    this.fontWeight = FontWeight.w500,
  });
  final String text;
  final double? fontSize;
  final Color? color;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.rubik(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}
