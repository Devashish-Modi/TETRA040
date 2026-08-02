import 'package:flutter/material.dart';

/// KAVACH AI — premium dark security palette.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.background,
    required this.secondaryBackground,
    required this.surface,
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.success,
    required this.warning,
    required this.danger,
    required this.info,
    required this.offline,
    required this.divider,
    required this.text,
    required this.textSecondary,
    required this.textMuted,
    required this.successBg,
    required this.warningBg,
    required this.dangerBg,
    required this.primarySoft,
    required this.infoBg,
    required this.shadow,
  });

  final Color background;
  final Color secondaryBackground;
  final Color surface;
  final Color primary;
  final Color secondary;
  final Color accent;
  final Color success;
  final Color warning;
  final Color danger;
  final Color info;
  final Color offline;
  final Color divider;
  final Color text;
  final Color textSecondary;
  final Color textMuted;
  final Color successBg;
  final Color warningBg;
  final Color dangerBg;
  final Color primarySoft;
  final Color infoBg;
  final Color shadow;

  static const Color brand = Color(0xFF4F8CFF);

  /// Single premium dark theme (Tesla / Ring / Linear).
  static const dark = AppColors(
    background: Color(0xFF0A0F1C),
    secondaryBackground: Color(0xFF111827),
    surface: Color(0xFF161F31),
    primary: Color(0xFF4F8CFF),
    secondary: Color(0xFF7B61FF),
    accent: Color(0xFF22D3EE),
    success: Color(0xFF22C55E),
    warning: Color(0xFFF59E0B),
    danger: Color(0xFFEF4444),
    info: Color(0xFF4F8CFF),
    offline: Color(0xFF64748B),
    divider: Color(0x14FFFFFF),
    text: Color(0xFFFFFFFF),
    textSecondary: Color(0xFF94A3B8),
    textMuted: Color(0xFF64748B),
    successBg: Color(0xFF0F2A1A),
    warningBg: Color(0xFF2A2110),
    dangerBg: Color(0xFF2A1215),
    primarySoft: Color(0xFF1A2744),
    infoBg: Color(0xFF1A2744),
    shadow: Color(0xFF000000),
  );

  /// Alias so existing light references still resolve to premium dark.
  static const light = dark;

  static AppColors of(BuildContext context) {
    return Theme.of(context).extension<AppColors>() ?? dark;
  }

  @override
  AppColors copyWith({
    Color? background,
    Color? secondaryBackground,
    Color? surface,
    Color? primary,
    Color? secondary,
    Color? accent,
    Color? success,
    Color? warning,
    Color? danger,
    Color? info,
    Color? offline,
    Color? divider,
    Color? text,
    Color? textSecondary,
    Color? textMuted,
    Color? successBg,
    Color? warningBg,
    Color? dangerBg,
    Color? primarySoft,
    Color? infoBg,
    Color? shadow,
  }) {
    return AppColors(
      background: background ?? this.background,
      secondaryBackground: secondaryBackground ?? this.secondaryBackground,
      surface: surface ?? this.surface,
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      accent: accent ?? this.accent,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      info: info ?? this.info,
      offline: offline ?? this.offline,
      divider: divider ?? this.divider,
      text: text ?? this.text,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      successBg: successBg ?? this.successBg,
      warningBg: warningBg ?? this.warningBg,
      dangerBg: dangerBg ?? this.dangerBg,
      primarySoft: primarySoft ?? this.primarySoft,
      infoBg: infoBg ?? this.infoBg,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      secondaryBackground:
          Color.lerp(secondaryBackground, other.secondaryBackground, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      info: Color.lerp(info, other.info, t)!,
      offline: Color.lerp(offline, other.offline, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      text: Color.lerp(text, other.text, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      successBg: Color.lerp(successBg, other.successBg, t)!,
      warningBg: Color.lerp(warningBg, other.warningBg, t)!,
      dangerBg: Color.lerp(dangerBg, other.dangerBg, t)!,
      primarySoft: Color.lerp(primarySoft, other.primarySoft, t)!,
      infoBg: Color.lerp(infoBg, other.infoBg, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
    );
  }
}
