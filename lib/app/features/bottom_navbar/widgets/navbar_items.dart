import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../widgets/normal_text.dart';

class NavBarItem extends StatelessWidget {
  const NavBarItem({
    super.key,
    required this.svgIcon,
    required this.text,
    this.color,
    this.iconColor,
  });

  final String svgIcon;
  final String text;
  final Color? color;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          svgIcon,
          height: 16.h,
          width: 16.w,
          colorFilter: ColorFilter.mode(iconColor!, BlendMode.srcIn),
        ),
        NormalText(text: text, fontSize: 12.sp, color: color),
      ],
    );
  }
}
