import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum AsChipTone { success, warning, danger, info, offline, custom }

class AsChip extends StatelessWidget {
  final String label;
  final Color? color;
  final bool pulse;
  final AsChipTone? tone;

  const AsChip({
    super.key,
    required this.label,
    this.color,
    this.pulse = false,
    this.tone,
  });

  Color _resolve(AppColors c) {
    switch (tone) {
      case AsChipTone.success:
        return c.success;
      case AsChipTone.warning:
        return c.warning;
      case AsChipTone.danger:
        return c.danger;
      case AsChipTone.info:
        return c.info;
      case AsChipTone.offline:
        return c.offline;
      case AsChipTone.custom:
      case null:
        return color ?? c.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = _resolve(AppColors.of(context));
    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: c.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: c,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: c.withValues(alpha: 0.55), blurRadius: 8),
              ],
            ),
          ),
          const SizedBox(width: 7),
          Text(
            label,
            style: TextStyle(
              color: c,
              fontWeight: FontWeight.w700,
              fontSize: 12,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
    if (!pulse) return chip;
    return _Pulse(child: chip);
  }
}

class _Pulse extends StatefulWidget {
  final Widget child;
  const _Pulse({required this.child});
  @override
  State<_Pulse> createState() => _PulseState();
}

class _PulseState extends State<_Pulse> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween(begin: 0.7, end: 1.0).animate(_c),
      child: widget.child,
    );
  }
}
