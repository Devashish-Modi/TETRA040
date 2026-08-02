import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/repellent_models.dart';
import '../providers/repellent_controller.dart';
import '../theme/repellent_theme.dart';
import '../widgets/common_widgets.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _count;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _count = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _anim = CurvedAnimation(parent: _count, curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _count.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<RepellentController>();
    final now = DateTime.now();
    final time = DateFormat('HH:mm').format(now);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Farm Repellent'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                const Icon(Icons.wb_sunny_outlined, size: 18),
                const SizedBox(width: 6),
                Text(
                  '${DemoData.weather} · $time',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Animals Detected Today',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 10),
                  AnimatedBuilder(
                    animation: _anim,
                    builder: (_, __) {
                      final n =
                          (_anim.value * DemoData.animalsToday).round();
                      return Text(
                        '$n',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppColors.safe,
                            ),
                      );
                    },
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      StatusDot(color: AppColors.safe, pulse: true),
                      const SizedBox(width: 8),
                      const Text(
                        'System idle · perimeter clear',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SectionTitle('Equipment Status'),
          Row(
            children: [
              for (final id in EquipmentId.values) ...[
                if (id != EquipmentId.laser) const SizedBox(width: 10),
                Expanded(child: _EquipCard(id: id, status: ctrl.status[id]!)),
              ],
            ],
          ),
          const SectionTitle('Other Alerts'),
          ...DemoData.otherAlerts.map((a) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: (a.critical
                            ? AppColors.threat
                            : AppColors.alert)
                        .withValues(alpha: 0.15),
                    child: Icon(
                      a.icon,
                      color: a.critical ? AppColors.threat : AppColors.alert,
                    ),
                  ),
                  title: Text(a.title,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(a.time),
                  trailing: a.critical
                      ? StatusDot(color: AppColors.threat, pulse: true)
                      : null,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _EquipCard extends StatelessWidget {
  final EquipmentId id;
  final EquipmentStatus status;
  const _EquipCard({required this.id, required this.status});

  @override
  Widget build(BuildContext context) {
    final c = statusColor(status);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        child: Column(
          children: [
            EquipmentIcon(id, size: 32),
            const SizedBox(height: 10),
            Text(id.label,
                style:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StatusDot(color: c, pulse: status == EquipmentStatus.on),
                const SizedBox(width: 6),
                Text(
                  statusLabel(status),
                  style: TextStyle(
                    color: c,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
