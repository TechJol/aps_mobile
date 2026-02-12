import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextStyle _style(double size, FontWeight weight) =>
      GoogleFonts.nunito(fontSize: size, fontWeight: weight);
  static TextStyle _titleStyle(double size, FontWeight weight) =>
      GoogleFonts.manrope(
        fontSize: size,
        fontWeight: weight,
      );

  static final f9w400 = _style(9, FontWeight.w400);
  static final f10w500 = _style(10, FontWeight.w500);
  static final f12w400 = _style(12, FontWeight.w400);
  static final f12w500 = _style(12, FontWeight.w500);
  static final f12w600 = _style(12, FontWeight.w600);
  static final f14w400 = _style(14, FontWeight.w400);
  static final f14w500 = _style(14, FontWeight.w500);
  static final f14w600 = _style(14, FontWeight.w600);
  static final f16w400 = _style(16, FontWeight.w400);
  static final f16w500 = _style(16, FontWeight.w500);
  static final f16w600 = _style(16, FontWeight.w600);
  static final f18w400 = _style(18, FontWeight.w400);
  static final f18w500 = _style(18, FontWeight.w500);
  static final f18w600 = _style(18, FontWeight.w600);
  static final f18w700 = _titleStyle(18, FontWeight.w700);
  static final f20w400 = _titleStyle(20, FontWeight.w400);
  static final f20w500 = _titleStyle(20, FontWeight.w500);
  static final f20w600 = _titleStyle(20, FontWeight.w600);
  static final f20w700 = _titleStyle(20, FontWeight.w700);
  static final f22w500 = _titleStyle(22, FontWeight.w500);
  static final f24w400 = _titleStyle(24, FontWeight.w400);
  static final f24w600 = _titleStyle(24, FontWeight.w600);
  static final f24w700 = _titleStyle(24, FontWeight.w700);
  static final f26w600 = _titleStyle(26, FontWeight.w600);
  static final f28w500 = _titleStyle(28, FontWeight.w500);
  static final f34w600 = _titleStyle(34, FontWeight.w600);
}
