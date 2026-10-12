import 'package:flutter/material.dart';
import 'package:foodnanny/config/theme/app_color.dart';
import 'package:google_fonts/google_fonts.dart';

class NormalText extends StatelessWidget {
  const NormalText({
    super.key,
    required this.text,
    this.fontSize = 14,
    this.color = AppColor.black100,
    this.fontWeight = FontWeight.w400,
    this.textDecoration,
    this.textAlign,
  });

  final String text;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final TextDecoration? textDecoration;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.rubik(
        fontSize: fontSize,
        fontStyle: FontStyle.normal,
        fontWeight: fontWeight,
        color: color,
        decoration: textDecoration,
      ),
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
      maxLines: 2,
    );
  }
}
