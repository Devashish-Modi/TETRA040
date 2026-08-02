import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../l10n/farm_l10n.dart';
import '../models/farm_models.dart';
import '../providers/auth_controller.dart';
import '../providers/farm_controller.dart';
import '../theme/farm_theme.dart';
import '../widgets/farm_dialogs.dart';
import '../widgets/farm_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _greeting(AppLocalizations l10n) {
    final h = DateTime.now().hour;
    if (h < 12) return l10n.goodMorning;
    if (h < 17) return l10n.goodAfternoon;
    return l10n.goodEvening;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ctrl = context.watch<FarmController>();
    final auth = context.watch<AuthController>();
    final name =
        auth.user?.displayName.split(' ').first ?? FarmData.farmerName;
    final camsOnline =
        ctrl.devices.where((d) => d.type == 'Camera' && d.online).length;
    final camsTotal = ctrl.devices.where((d) => d.type == 'Camera').length;

    return Scaffold(
      backgroundColor: FarmColors.page,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _HeroHeader(
              greeting: _greeting(l10n),
              name: name,
              alertCount: ctrl.alerts.length,
              urgentCount: ctrl.alerts.where((a) => a.urgent).length,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    _WhiteCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color:
                                      FarmColors.deep.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.pets_rounded,
                                    color: FarmColors.deep, size: 22),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  l10n.animalsToday,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.w800,
                                        color: FarmColors.deep,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              const Text(
                                '${FarmData.animalsToday}',
                                style: TextStyle(
                                  fontSize: 52,
                                  fontWeight: FontWeight.w800,
                                  color: FarmColors.deep,
                                  height: 1,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                l10n.detections,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: FarmColors.sage,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            l10n.detectedAroundFarm,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: FarmColors.sage,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            l10n.byAnimalType,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: FarmColors.deep,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 120,
                            width: double.infinity,
                            child: _AnimalsBarChart(
                              data: FarmData.monthlyAnimals,
                              l10n: l10n,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    _WhiteCard(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(l10n.cameras,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                                const SizedBox(height: 6),
                                Text(
                                  l10n.onlineCount(camsOnline, camsTotal),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: FarmColors.deep,
                                        fontWeight: FontWeight.w800,
                                      ),
                                ),
                                const SizedBox(height: 6),
                                _PillBadge(
                                  label: camsOnline == camsTotal
                                      ? l10n.allOnline
                                      : l10n.needsCheck,
                                  color: camsOnline == camsTotal
                                      ? FarmColors.softGreen
                                      : FarmColors.softRed,
                                  textColor: camsOnline == camsTotal
                                      ? FarmColors.deep
                                      : FarmColors.danger,
                                ),
                              ],
                            ),
                          ),
                          FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: FarmColors.deep,
                              foregroundColor: FarmColors.foam,
                              minimumSize: const Size(110, 44),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: () => context.go('/live'),
                            child: Text(l10n.openLive),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    _WhiteCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                l10n.deterrents,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () => context.push('/activate'),
                                child: Text(l10n.manualAlarm),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              for (final id in EquipmentId.values) ...[
                                if (id != EquipmentId.laser)
                                  const SizedBox(width: 8),
                                Expanded(
                                  child: _EquipMini(
                                    id: id,
                                    status: ctrl.status[id]!,
                                    onTap: () {
                                      if (ctrl.activeEquipment == id) {
                                        showFarmSnack(
                                          context,
                                          l10n.alreadyOn(id.shortName(l10n)),
                                        );
                                        return;
                                      }
                                      ctrl.cycleEquipmentStatus(id);
                                      showFarmSnack(
                                        context,
                                        l10n.statusChanged(
                                          id.shortName(l10n),
                                          statusLabel(ctrl.status[id]!, l10n),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    _AlertsHeroCard(
                      alerts: ctrl.alerts,
                      onOpenAll: () => context.go('/alerts'),
                      onClear: () {
                        ctrl.clearAlerts();
                        showFarmSnack(context, l10n.allAlertsCleared);
                      },
                      onDismiss: (i) {
                        ctrl.dismissAlert(i);
                        showFarmSnack(context, l10n.alertDismissed);
                      },
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  final String greeting;
  final String name;
  final int alertCount;
  final int urgentCount;
  const _HeroHeader({
    required this.greeting,
    required this.name,
    required this.alertCount,
    required this.urgentCount,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 228,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/home_farm.png',
            fit: BoxFit.cover,
            alignment: const Alignment(0, -0.1),
            errorBuilder: (_, __, ___) =>
                const ColoredBox(color: FarmColors.deep),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x990F2A1D),
                  Color(0x440F2A1D),
                  Color(0xF20F2A1D),
                ],
                stops: [0.0, 0.4, 1.0],
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/kavach_logo.png',
                        width: 52,
                        height: 88,
                        fit: BoxFit.contain,
                      ),
                      const Spacer(),
                      _GlassIconButton(
                        icon: Icons.notifications_rounded,
                        badge: alertCount,
                        badgeUrgent: urgentCount > 0,
                        onTap: () => context.go('/alerts'),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => context.go('/profile'),
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: FarmColors.moss,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.45),
                              width: 1.5,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            name.isNotEmpty ? name[0].toUpperCase() : 'F',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: FarmColors.foam,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    AppLocalizations.of(context).hiGreeting(greeting),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded,
                          size: 15, color: FarmColors.mist),
                      const SizedBox(width: 4),
                      Text(
                        AppLocalizations.of(context).farmLocation,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final int badge;
  final bool badgeUrgent;
  final VoidCallback onTap;
  const _GlassIconButton({
    required this.icon,
    required this.badge,
    required this.badgeUrgent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Ink(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.18),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.35),
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 22),
                  if (badge > 0)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: badgeUrgent ? FarmColors.danger : FarmColors.lime,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: FarmColors.deep, width: 1),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      badge > 9 ? '9+' : '$badge',
                      style: TextStyle(
                        color: badgeUrgent ? Colors.white : FarmColors.deep,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        height: 1,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AlertsHeroCard extends StatelessWidget {
  final List<FarmAlert> alerts;
  final VoidCallback onOpenAll;
  final VoidCallback onClear;
  final ValueChanged<int> onDismiss;

  const _AlertsHeroCard({
    required this.alerts,
    required this.onOpenAll,
    required this.onClear,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final preview = alerts.take(3).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: FarmColors.deep.withValues(alpha: 0.10),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: FarmColors.softAmber,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.notifications_active_rounded,
                  color: FarmColors.moss,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.alerts,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    Text(
                      alerts.isEmpty
                          ? l10n.farmProtectionSystem
                          : '${alerts.length} · ${l10n.alertsSubtitle}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: FarmColors.sage,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: FarmColors.deep,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: onOpenAll,
                child: Text(l10n.viewAllAlerts),
              ),
              if (alerts.isNotEmpty)
                IconButton(
                  tooltip: l10n.clear,
                  onPressed: onClear,
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(
                    Icons.done_all_rounded,
                    color: FarmColors.sage,
                    size: 20,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          if (preview.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
              decoration: BoxDecoration(
                color: FarmColors.softGreen,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.verified_rounded,
                      color: FarmColors.moss,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.noAlerts,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: FarmColors.deep,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            ...List.generate(preview.length, (i) {
              final a = preview[i];
              return Padding(
                padding: EdgeInsets.only(bottom: i == preview.length - 1 ? 0 : 8),
                child: Material(
                  color: a.urgent
                      ? FarmColors.softRed.withValues(alpha: 0.65)
                      : FarmColors.page,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: onOpenAll,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 4, 10),
                      child: Row(
                        children: [
                          _AlertGlyph(alert: a),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  localizeAlertMessage(l10n, a.message),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13.5,
                                    color: FarmColors.deep,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Icon(
                                      a.urgent
                                          ? Icons.priority_high_rounded
                                          : Icons.schedule_rounded,
                                      size: 13,
                                      color: a.urgent
                                          ? FarmColors.danger
                                          : FarmColors.sage,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      a.time,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color: a.urgent
                                            ? FarmColors.danger
                                            : FarmColors.sage,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.close_rounded,
                              color: FarmColors.sage,
                              size: 18,
                            ),
                            onPressed: () => onDismiss(i),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}

class _AlertGlyph extends StatelessWidget {
  final FarmAlert alert;
  const _AlertGlyph({required this.alert});

  @override
  Widget build(BuildContext context) {
    final urgent = alert.urgent;
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: urgent
              ? const [Color(0xFFE8C4BC), Color(0xFFD9A79A)]
              : const [Color(0xFFDFF0D2), Color(0xFFBFD9B4)],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        alert.icon,
        color: urgent ? FarmColors.danger : FarmColors.deep,
        size: 22,
      ),
    );
  }
}

class _WhiteCard extends StatelessWidget {
  final Widget child;
  const _WhiteCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
      child: child,
    );
  }
}

class _PillBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  const _PillBadge({
    required this.label,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w800,
          fontSize: 11,
        ),
      ),
    );
  }
}

class _EquipMini extends StatelessWidget {
  final EquipmentId id;
  final EquipmentStatus status;
  final VoidCallback onTap;
  const _EquipMini({
    required this.id,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = statusColor(status);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: FarmColors.page,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: status == EquipmentStatus.on
                ? FarmColors.deep.withValues(alpha: 0.35)
                : Colors.transparent,
          ),
        ),
        child: Column(
          children: [
            SvgPicture.asset(id.asset, width: 28, height: 28),
            const SizedBox(height: 8),
            Text(
              id.shortName(AppLocalizations.of(context)),
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 12,
                color: FarmColors.deep,
              ),
            ),            const SizedBox(height: 4),
            Text(
              statusLabel(status, AppLocalizations.of(context)),
              style: TextStyle(
                color: c,
                fontWeight: FontWeight.w800,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimalsBarChart extends StatelessWidget {
  final Map<String, double> data;
  final AppLocalizations l10n;
  const _AnimalsBarChart({required this.data, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final max = data.values.fold<double>(0, (a, b) => a > b ? a : b);
    final entries = data.entries.toList();
    const barMaxHeight = 78.0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var i = 0; i < entries.length; i++) ...[
          if (i > 0) const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: max == 0
                      ? 12
                      : (barMaxHeight * (entries[i].value / max))
                          .clamp(14.0, barMaxHeight),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: i == entries.length - 1
                        ? FarmColors.deep
                        : FarmColors.moss,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  localizeAnimalChartKey(l10n, entries[i].key),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: FarmColors.deep,
                  ),
                ),
                Text(
                  '${entries[i].value.round()}',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: FarmColors.sage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
