import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Brand greens + Neofarm-style lime accent for CTAs.
/// Core: #0F2A1D · #375534 · #6B9071 · #AEC3B0 · #E3EED4
class FarmColors {
  static const deep = Color(0xFF0F2A1D);
  static const moss = Color(0xFF375534);
  static const sage = Color(0xFF6B9071);
  static const mist = Color(0xFFAEC3B0);
  static const foam = Color(0xFFE3EED4);
  static const lime = Color(0xFFB6E87A);
  static const limeDeep = Color(0xFF9AD45F);

  static const cream = foam;
  static const card = Color(0xFFFFFFFF);
  static const forest = moss;
  static const terracotta = sage;
  static const safe = limeDeep;
  static const caution = Color(0xFFC4A35A);
  static const danger = Color(0xFF9B4A3C);
  static const text = deep;
  static const muted = sage;
  static const border = Color(0xFFD7E3D4);
  static const softGreen = Color(0xFFDFF0D2);
  static const softAmber = Color(0xFFF0EBDA);
  static const softRed = Color(0xFFF0E0DC);
  static const page = Color(0xFFF3F6F0);
}

ThemeData buildFarmTheme() {
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: FarmColors.page,
    colorScheme: ColorScheme.light(
      primary: FarmColors.moss,
      secondary: FarmColors.lime,
      tertiary: FarmColors.sage,
      error: FarmColors.danger,
      surface: FarmColors.card,
      onPrimary: FarmColors.foam,
      onSecondary: FarmColors.deep,
      onSurface: FarmColors.deep,
      onError: FarmColors.foam,
    ),
  );

  final text = GoogleFonts.plusJakartaSansTextTheme(base.textTheme).apply(
    bodyColor: FarmColors.deep,
    displayColor: FarmColors.deep,
  );

  return base.copyWith(
    textTheme: text.copyWith(
      headlineLarge: GoogleFonts.plusJakartaSans(
        fontSize: 30,
        fontWeight: FontWeight.w800,
        color: FarmColors.deep,
      ),
      headlineMedium: GoogleFonts.plusJakartaSans(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: FarmColors.deep,
      ),
      titleLarge: GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: FarmColors.deep,
      ),
      titleMedium: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: FarmColors.deep,
      ),
      bodyLarge: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: FarmColors.deep,
        height: 1.35,
      ),
      bodyMedium: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: FarmColors.sage,
        height: 1.35,
      ),
      labelLarge: GoogleFonts.plusJakartaSans(
        fontSize: 15,
        fontWeight: FontWeight.w800,
        color: FarmColors.deep,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: FarmColors.page,
      foregroundColor: FarmColors.moss,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.plusJakartaSans(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: FarmColors.moss,
      ),
    ),
    cardTheme: CardThemeData(
      color: FarmColors.card,
      elevation: 0,
      shadowColor: FarmColors.deep.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      margin: EdgeInsets.zero,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: FarmColors.softGreen,
      selectedColor: FarmColors.moss,
      labelStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
      secondaryLabelStyle: GoogleFonts.plusJakartaSans(
        fontWeight: FontWeight.w700,
        color: FarmColors.deep,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: FarmColors.mist.withValues(alpha: 0.7),
      labelTextStyle: WidgetStateProperty.resolveWith((s) {
        final selected = s.contains(WidgetState.selected);
        return GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: selected ? FarmColors.deep : FarmColors.sage,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((s) {
        final selected = s.contains(WidgetState.selected);
        return IconThemeData(
          color: selected ? FarmColors.deep : FarmColors.sage,
          size: 24,
        );
      }),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: FarmColors.moss,
        foregroundColor: FarmColors.foam,
        minimumSize: const Size.fromHeight(54),
        textStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w800, fontSize: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: FarmColors.moss,
      inactiveTrackColor: FarmColors.mist,
      thumbColor: FarmColors.limeDeep,
    ),
  );
}
