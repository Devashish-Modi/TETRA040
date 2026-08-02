import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AsNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;

  const AsNav({super.key, required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final items = [
      (Icons.grid_view_rounded, 'Overview'),
      (Icons.videocam_rounded, 'Monitor'),
      (Icons.notifications_rounded, 'Alerts'),
      (Icons.insights_rounded, 'Analytics'),
      (Icons.person_rounded, 'Profile'),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            decoration: BoxDecoration(
              color: colors.surface.withValues(alpha: 0.82),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: colors.divider),
              boxShadow: [
                BoxShadow(
                  color: colors.shadow.withValues(alpha: 0.45),
                  blurRadius: 30,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: List.generate(items.length, (i) {
                  final selected = i == index;
                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onTap(i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 240),
                        curve: Curves.easeOutCubic,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: selected
                              ? colors.primary.withValues(alpha: 0.16)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedScale(
                              scale: selected ? 1.1 : 1,
                              duration: const Duration(milliseconds: 240),
                              child: Icon(
                                items[i].$1,
                                size: 22,
                                color: selected
                                    ? colors.primary
                                    : colors.textMuted,
                              ),
                            ),
                            const SizedBox(height: 4),
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 240),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: selected
                                    ? FontWeight.w800
                                    : FontWeight.w500,
                                color: selected
                                    ? colors.primary
                                    : colors.textMuted,
                              ),
                              child: Text(items[i].$2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
