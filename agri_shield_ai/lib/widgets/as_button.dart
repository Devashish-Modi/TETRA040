import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AsButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool outlined;
  final bool danger;
  final bool success;
  final Color? color;
  final bool compact;

  const AsButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.outlined = false,
    this.danger = false,
    this.success = false,
    this.color,
    this.compact = false,
  });

  @override
  State<AsButton> createState() => _AsButtonState();
}

class _AsButtonState extends State<AsButton> {
  bool _down = false;

  Color _base(AppColors c) {
    if (widget.color != null) return widget.color!;
    if (widget.danger) return c.danger;
    if (widget.success) return c.success;
    return c.primary;
  }

  @override
  Widget build(BuildContext context) {
    final c = _base(AppColors.of(context));
    return GestureDetector(
      onTapDown: (_) => setState(() => _down = true),
      onTapUp: (_) => setState(() => _down = false),
      onTapCancel: () => setState(() => _down = false),
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _down ? 0.97 : 1,
        duration: const Duration(milliseconds: 110),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          height: widget.compact ? 44 : 54,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: widget.outlined ? Colors.transparent : c,
            borderRadius: BorderRadius.circular(18),
            border: widget.outlined
                ? Border.all(color: c.withValues(alpha: 0.45), width: 1.4)
                : null,
            boxShadow: widget.outlined
                ? null
                : [
                    BoxShadow(
                      color: c.withValues(alpha: 0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon,
                    size: 20, color: widget.outlined ? c : Colors.white),
                const SizedBox(width: 8),
              ],
              Text(
                widget.label,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: widget.outlined ? c : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
