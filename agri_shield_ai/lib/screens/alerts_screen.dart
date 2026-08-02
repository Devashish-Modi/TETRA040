import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../l10n/farm_l10n.dart';
import '../providers/farm_controller.dart';
import '../theme/farm_theme.dart';
import '../widgets/farm_dialogs.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ctrl = context.watch<FarmController>();

    return Scaffold(
      backgroundColor: FarmColors.page,
      appBar: AppBar(
        title: Text(l10n.alertsTitle),
        actions: [
          if (ctrl.alerts.isNotEmpty)
            TextButton(
              onPressed: () {
                ctrl.clearAlerts();
                showFarmSnack(context, l10n.allAlertsCleared);
              },
              child: Text(l10n.clear),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          Text(
            l10n.alertsSubtitle,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: FarmColors.sage,
            ),
          ),
          const SizedBox(height: 16),
          if (ctrl.alerts.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: FarmColors.deep.withValues(alpha: 0.06),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.verified_outlined,
                    size: 48,
                    color: FarmColors.moss.withValues(alpha: 0.9),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.noAlerts,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: FarmColors.deep,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            )
          else
            ...List.generate(ctrl.alerts.length, (i) {
              final a = ctrl.alerts[i];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  elevation: 0,
                  shadowColor: FarmColors.deep.withValues(alpha: 0.08),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: a.urgent
                          ? FarmColors.softRed
                          : FarmColors.mist.withValues(alpha: 0.5),
                      child: Icon(
                        a.icon,
                        color: a.urgent ? FarmColors.danger : FarmColors.deep,
                      ),
                    ),
                    title: Text(
                      localizeAlertMessage(l10n, a.message),
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    subtitle: Text(a.time),
                    trailing: IconButton(
                      icon: const Icon(Icons.close_rounded,
                          color: FarmColors.sage),
                      onPressed: () {
                        ctrl.dismissAlert(i);
                        showFarmSnack(context, l10n.alertDismissed);
                      },
                    ),
                    onTap: () => context.go('/live'),
                  ),
                ),
              );
            }),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => context.push('/activate'),
            icon: const Icon(Icons.touch_app_rounded),
            label: Text(l10n.manualAlarm),
            style: OutlinedButton.styleFrom(
              foregroundColor: FarmColors.deep,
              side: BorderSide(color: FarmColors.deep.withValues(alpha: 0.25)),
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
