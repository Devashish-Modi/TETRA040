import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../l10n/farm_l10n.dart';
import '../models/farm_models.dart';
import '../providers/farm_controller.dart';
import '../theme/farm_theme.dart';
import '../widgets/farm_dialogs.dart';

class ActivateScreen extends StatelessWidget {
  const ActivateScreen({super.key});

  static String _levelTitle(AppLocalizations l10n, int level) {
    switch (level) {
      case 1:
        return l10n.levelSoftWarning;
      case 2:
        return l10n.levelActiveAlert;
      default:
        return l10n.levelCritical;
    }
  }

  static Color _levelTint(int level) {
    switch (level) {
      case 1:
        return FarmColors.softGreen;
      case 2:
        return FarmColors.softAmber;
      default:
        return FarmColors.softRed;
    }
  }

  static Color _levelAccent(int level) {
    switch (level) {
      case 1:
        return FarmColors.forest;
      case 2:
        return FarmColors.terracotta;
      default:
        return FarmColors.danger;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ctrl = context.watch<FarmController>();
    final levels = ctrl.priorityOrder;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.manualAlarm),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Text(
            l10n.alarmLevelsHint,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: FarmColors.muted,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 12),
          if (ctrl.isFiring)
            Card(
              color: FarmColors.softRed,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.warning_rounded, color: FarmColors.danger),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        l10n.alarmActiveStatus(
                          levels.indexOf(ctrl.activeEquipment!) + 1,
                          ctrl.activeEquipment!.shortName(l10n),
                          ctrl.remainingSeconds,
                        ),
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: FarmColors.danger,
                        minimumSize: const Size(88, 48),
                      ),
                      onPressed: () {
                        final name = ctrl.activeEquipment?.shortName(l10n) ??
                            l10n.manualAlarm;
                        ctrl.stopActivation();
                        showFarmSnack(context, l10n.stoppedNamed(name));
                      },
                      child: Text(l10n.stop),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 12),
          for (var i = 0; i < levels.length; i++) ...[
            _LevelHoldCard(
              level: i + 1,
              id: levels[i],
              title: _levelTitle(l10n, i + 1),
              tint: _levelTint(i + 1),
              accent: _levelAccent(i + 1),
              enabled: !ctrl.isFiring || ctrl.activeEquipment == levels[i],
              onActivated: () {
                final id = levels[i];
                if (ctrl.isFiring && ctrl.activeEquipment != id) {
                  showFarmSnack(
                    context,
                    l10n.stopFirst(ctrl.activeEquipment!.shortName(l10n)),
                  );
                  return;
                }
                ctrl.startActivation(id);
                showFarmSnack(
                  context,
                  l10n.levelActivated(i + 1, id.shortName(l10n)),
                );
              },
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _LevelHoldCard extends StatefulWidget {
  final int level;
  final EquipmentId id;
  final String title;
  final Color tint;
  final Color accent;
  final bool enabled;
  final VoidCallback onActivated;

  const _LevelHoldCard({
    required this.level,
    required this.id,
    required this.title,
    required this.tint,
    required this.accent,
    required this.enabled,
    required this.onActivated,
  });

  @override
  State<_LevelHoldCard> createState() => _LevelHoldCardState();
}

class _LevelHoldCardState extends State<_LevelHoldCard>
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
    final l10n = AppLocalizations.of(context);
    final needsCaution =
        widget.id == EquipmentId.laser || widget.id == EquipmentId.water;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: widget.tint,
                  child: Text(
                    '${widget.level}',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: widget.accent,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: widget.accent,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onLongPressStart:
                  widget.enabled ? (_) => _hold.forward(from: 0) : null,
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
                    padding: const EdgeInsets.symmetric(vertical: 22),
                    decoration: BoxDecoration(
                      color: widget.tint,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Color.lerp(
                          FarmColors.border,
                          widget.accent,
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
                            width: 72,
                            height: 72,
                            child: CircularProgressIndicator(
                              value: _hold.value,
                              strokeWidth: 5,
                              color: widget.accent,
                              backgroundColor: FarmColors.border,
                            ),
                          ),
                        Column(
                          children: [
                            SvgPicture.asset(widget.id.asset,
                                width: 40, height: 40),
                            const SizedBox(height: 10),
                            Text(
                              widget.id.fullName(l10n),
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.id.localizedDescription(l10n),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: FarmColors.muted,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.holdToActivate(widget.level),
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: widget.accent,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            if (needsCaution) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.info_outline_rounded,
                      size: 18, color: FarmColors.terracotta),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.keepPeopleAway,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: FarmColors.terracotta,
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
