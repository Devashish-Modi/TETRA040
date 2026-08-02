import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/repellent_models.dart';
import '../providers/repellent_controller.dart';
import '../theme/repellent_theme.dart';
import '../widgets/common_widgets.dart';

class ManualActivationScreen extends StatelessWidget {
  const ManualActivationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<RepellentController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Manual Activation')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          const Text(
            'Hold a button to activate. Prevents accidental taps.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          if (ctrl.isFiring)
            Card(
              color: AppColors.threat.withValues(alpha: 0.12),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    StatusDot(color: AppColors.threat, pulse: true),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${ctrl.activeEquipment!.label} active · ${ctrl.remainingSeconds}s',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.threat,
                      ),
                      onPressed: ctrl.stopActivation,
                      child: const Text('Stop'),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 12),
          for (final id in EquipmentId.values) ...[
            _HoldToActivateButton(
              id: id,
              enabled: !ctrl.isFiring || ctrl.activeEquipment == id,
              showWarning: id == EquipmentId.laser || id == EquipmentId.water,
              onActivated: () => ctrl.startActivation(id),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _HoldToActivateButton extends StatefulWidget {
  final EquipmentId id;
  final bool enabled;
  final bool showWarning;
  final VoidCallback onActivated;

  const _HoldToActivateButton({
    required this.id,
    required this.enabled,
    required this.showWarning,
    required this.onActivated,
  });

  @override
  State<_HoldToActivateButton> createState() => _HoldToActivateButtonState();
}

class _HoldToActivateButtonState extends State<_HoldToActivateButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _hold;

  @override
  void initState() {
    super.initState();
    _hold = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..addStatusListener((s) {
        if (s == AnimationStatus.completed) {
          widget.onActivated();
          _hold.reset();
        }
      });
  }

  @override
  void dispose() {
    _hold.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onLongPressStart: widget.enabled
                  ? (_) => _hold.forward(from: 0)
                  : null,
              onLongPressEnd: (_) {
                if (_hold.status != AnimationStatus.completed) {
                  _hold.reverse();
                }
              },
              onLongPressCancel: () => _hold.reverse(),
              child: AnimatedBuilder(
                animation: _hold,
                builder: (_, __) {
                  return Container(
                    width: double.infinity,
                    height: 96,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: AppColors.surfaceAlt,
                      border: Border.all(
                        color: Color.lerp(
                              AppColors.border,
                              AppColors.threat,
                              _hold.value,
                            )!,
                        width: 2,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (_hold.value > 0)
                          SizedBox(
                            width: 64,
                            height: 64,
                            child: CircularProgressIndicator(
                              value: _hold.value,
                              strokeWidth: 4,
                              color: AppColors.threat,
                            ),
                          ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            EquipmentIcon(widget.id, size: 34),
                            const SizedBox(height: 8),
                            Text(
                              'Hold to activate ${widget.id.label}',
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            if (widget.showWarning) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      size: 16, color: AppColors.alert),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      widget.id == EquipmentId.laser
                          ? 'Safety: avoid aiming laser toward people or eyes.'
                          : 'Safety: keep clear of high-pressure spray path.',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
