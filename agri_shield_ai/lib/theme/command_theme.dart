import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tactical SOC palette — Tesla / DJI / command-center inspired.
class CommandColors {
  static const void_ = Color(0xFF05080D);
  static const panel = Color(0xCC0B1219);
  static const panelEdge = Color(0x33A8C5D8);
  static const hud = Color(0xFF3DDC97);
  static const hudDim = Color(0x663DDC97);
  static const cyan = Color(0xFF2EC4FF);
  static const amber = Color(0xFFFFB020);
  static const threat = Color(0xFFFF4D4D);
  static const text = Color(0xFFE8EEF4);
  static const muted = Color(0xFF8A97A5);
  static const mapDeep = Color(0xFF1A2E1F);
  static const mapField = Color(0xFF2F4A32);
  static const mapCrop = Color(0xFF3D5C38);
  static const mapSoil = Color(0xFF4A3D2E);
  static const mapRoad = Color(0xFF2A2F35);
  static const mapWater = Color(0xFF1A3A4A);
}

TextStyle commandHud({
  double size = 12,
  FontWeight weight = FontWeight.w600,
  Color? color,
  double tracking = 1.2,
}) {
  return GoogleFonts.spaceGrotesk(
    fontSize: size,
    fontWeight: weight,
    color: color ?? CommandColors.text,
    letterSpacing: tracking,
  );
}

class GlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color? tint;

  const GlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.radius = 16,
    this.tint,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: tint ?? CommandColors.panel,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: CommandColors.panelEdge, width: 1),
            boxShadow: const [
              BoxShadow(
                color: Color(0x66000000),
                blurRadius: 24,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
