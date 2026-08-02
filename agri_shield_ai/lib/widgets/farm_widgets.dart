import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../l10n/app_localizations.dart';
import '../l10n/farm_l10n.dart';
import '../models/farm_models.dart';
import '../theme/farm_theme.dart';

Color statusColor(EquipmentStatus s) {
  switch (s) {
    case EquipmentStatus.on:
      return FarmColors.danger;
    case EquipmentStatus.standby:
      return FarmColors.caution;
    case EquipmentStatus.off:
      return FarmColors.muted;
  }
}

String statusLabel(EquipmentStatus s, AppLocalizations l10n) {
  switch (s) {
    case EquipmentStatus.on:
      return l10n.statusOn;
    case EquipmentStatus.standby:
      return l10n.statusReady;
    case EquipmentStatus.off:
      return l10n.statusOff;
  }
}

String ordinal(int level) {
  switch (level) {
    case 1:
      return '1st';
    case 2:
      return '2nd';
    default:
      return '3rd';
  }
}

class SoftStatusDot extends StatelessWidget {
  final Color color;
  const SoftStatusDot({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
    );
  }
}

class EquipmentStatusCard extends StatelessWidget {
  final EquipmentId id;
  final EquipmentStatus status;
  final VoidCallback? onTap;
  const EquipmentStatusCard({
    super.key,
    required this.id,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = statusColor(status);
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
          child: Column(
            children: [
              SvgPicture.asset(id.asset, width: 34, height: 34),
              const SizedBox(height: 10),
              Text(
                id.shortName(AppLocalizations.of(context)),
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SoftStatusDot(color: c),
                  const SizedBox(width: 6),
                  Text(
                    statusLabel(status, AppLocalizations.of(context)),
                    style: TextStyle(
                      color: c,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AlertTile extends StatelessWidget {
  final FarmAlert alert;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;
  const AlertTile({super.key, required this.alert, this.onTap, this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final color = alert.urgent ? FarmColors.danger : FarmColors.caution;
    return Card(
      child: ListTile(
        onTap: onTap,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.12),
          child: Icon(alert.icon, color: color),
        ),
        title: Text(
          alert.message,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
        ),
        subtitle: Text(alert.time),
        trailing: onDismiss == null
            ? null
            : IconButton(
                tooltip: 'Dismiss',
                onPressed: onDismiss,
                icon: const Icon(Icons.close_rounded),
              ),
      ),
    );
  }
}

class DetectionHistoryCard extends StatelessWidget {
  final HistoryEvent event;
  const DetectionHistoryCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final ok = event.outcome == EventOutcome.repelled;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: FarmColors.softGreen,
              child: SvgPicture.asset(event.animal.asset, width: 28, height: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.animal.label,
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${event.when} · ${event.weather == WeatherType.clear ? 'Clear' : 'Rain'}',
                    style: const TextStyle(color: FarmColors.muted),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Used: ${event.equipmentUsed}',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: ok ? FarmColors.softGreen : FarmColors.softRed,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                ok ? 'Repelled' : 'Breached fence',
                style: TextStyle(
                  color: ok ? FarmColors.forest : FarmColors.danger,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PrioritySelectorChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Widget? leading;

  const PrioritySelectorChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      selected: selected,
      onSelected: (_) => onTap(),
      avatar: leading,
      label: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w800,
          color: selected ? Colors.white : FarmColors.text,
        ),
      ),
      selectedColor: FarmColors.forest,
      backgroundColor: FarmColors.card,
      checkmarkColor: Colors.white,
      side: BorderSide(
        color: selected ? FarmColors.forest : FarmColors.border,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
    );
  }
}

class BigLabeledButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const BigLabeledButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 28, color: FarmColors.forest),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 12,
                color: FarmColors.forest,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
