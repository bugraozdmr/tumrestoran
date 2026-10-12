import 'package:flutter/material.dart';
import 'package:tumrestoran/config/theme/app_color.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleText extends StatelessWidget {
  const TitleText({super.key, required this.text, this.fontSize = 18});
  final String text;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.rubik(
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
        color: AppColor.black100,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
