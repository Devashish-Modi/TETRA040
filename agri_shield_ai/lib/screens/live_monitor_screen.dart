import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../theme/app_colors.dart';
import '../widgets/as_card.dart';
import '../widgets/as_chip.dart';

class LiveMonitorScreen extends StatefulWidget {
  const LiveMonitorScreen({super.key});

  @override
  State<LiveMonitorScreen> createState() => _LiveMonitorScreenState();
}

class _LiveMonitorScreenState extends State<LiveMonitorScreen> {
  bool _recording = false;

  void _toast(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Monitor',
                            style: Theme.of(context).textTheme.headlineMedium),
                        Text('Cam-01 · North Fence',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  const AsChip(
                      label: 'LIVE', tone: AsChipTone.danger, pulse: true),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF1A2438),
                              Color(0xFF0D1424),
                              Color(0xFF121A2C),
                            ],
                          ),
                        ),
                      ),
                      // subtle scan lines feel
                      Positioned.fill(
                        child: CustomPaint(painter: _GridPainter()),
                      ),
                      Positioned(
                        left: 48,
                        top: 100,
                        width: 190,
                        height: 150,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: colors.warning, width: 2.5),
                          ),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: colors.warning,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${AppData.liveAnimal}  ${AppData.liveConfidence}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 14,
                        right: 14,
                        bottom: 14,
                        child: AsCard(
                          padding: const EdgeInsets.all(16),
                          radius: 22,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(AppData.liveAnimal,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge),
                                  const Spacer(),
                                  AsChip(
                                    label: 'LEVEL ${AppData.liveAlarmLevel}',
                                    tone: AsChipTone.warning,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 16,
                                runSpacing: 8,
                                children: [
                                  _Meta(Icons.speed_rounded,
                                      '${AppData.liveConfidence}%'),
                                  _Meta(Icons.straighten_rounded,
                                      AppData.liveDistance),
                                  _Meta(Icons.explore_rounded,
                                      AppData.liveDirection),
                                  _Meta(Icons.schedule_rounded,
                                      AppData.liveTime),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_recording)
                        Positioned(
                          top: 14,
                          left: 14,
                          child: AsChip(
                            label: 'REC',
                            tone: AsChipTone.danger,
                            pulse: true,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 110),
              child: AsCard(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                radius: 26,
                child: Row(
                  children: [
                    _Ctrl(Icons.volume_up_rounded, 'Speaker',
                        () => _toast('Speaker on')),
                    _Ctrl(Icons.flashlight_on_rounded, 'Flash',
                        () => _toast('Flash on')),
                    _Ctrl(Icons.campaign_rounded, 'Alarm',
                        () => _toast('Alarm Level 2'),
                        danger: true),
                    _Ctrl(Icons.photo_camera_rounded, 'Capture',
                        () => _toast('Captured')),
                    _Ctrl(
                      _recording
                          ? Icons.stop_circle_rounded
                          : Icons.fiber_manual_record_rounded,
                      _recording ? 'Stop' : 'Record',
                      () {
                        setState(() => _recording = !_recording);
                        _toast(_recording ? 'Recording' : 'Stopped');
                      },
                      danger: _recording,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Meta(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: colors.textMuted),
        const SizedBox(width: 5),
        Text(text,
            style: TextStyle(
                color: colors.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 12)),
      ],
    );
  }
}

class _Ctrl extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;
  const _Ctrl(this.icon, this.label, this.onTap, {this.danger = false});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final c = danger ? colors.danger : colors.text;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: c.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: c.withValues(alpha: 0.2)),
                ),
                child: Icon(icon, color: c, size: 20),
              ),
              const SizedBox(height: 6),
              Text(label,
                  style: TextStyle(
                      color: c, fontSize: 10, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x14FFFFFF)
      ..strokeWidth = 1;
    const step = 36.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
