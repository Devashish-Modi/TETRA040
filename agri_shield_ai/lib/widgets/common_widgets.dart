import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/repellent_models.dart';
import '../theme/repellent_theme.dart';

class StatusDot extends StatelessWidget {
  final Color color;
  final bool pulse;
  const StatusDot({super.key, required this.color, this.pulse = false});

  @override
  Widget build(BuildContext context) {
    final dot = Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.55), blurRadius: 8),
        ],
      ),
    );
    if (!pulse) return dot;
    return _Pulse(child: dot);
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
        vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween(begin: 0.45, end: 1.0).animate(_c),
      child: widget.child,
    );
  }
}

class EquipmentIcon extends StatelessWidget {
  final EquipmentId id;
  final double size;
  const EquipmentIcon(this.id, {super.key, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(id.asset, width: size, height: size);
  }
}

class AnimalIcon extends StatelessWidget {
  final AnimalType type;
  final double size;
  const AnimalIcon(this.type, {super.key, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(type.asset, width: size, height: size);
  }
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

Color statusColor(EquipmentStatus s) {
  switch (s) {
    case EquipmentStatus.on:
      return AppColors.threat;
    case EquipmentStatus.standby:
      return AppColors.alert;
    case EquipmentStatus.off:
      return AppColors.textSecondary;
  }
}

String statusLabel(EquipmentStatus s) {
  switch (s) {
    case EquipmentStatus.on:
      return 'ON';
    case EquipmentStatus.standby:
      return 'Standby';
    case EquipmentStatus.off:
      return 'OFF';
  }
}
