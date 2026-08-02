import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/auth_controller.dart';
import '../providers/farm_controller.dart';
import '../providers/locale_controller.dart';
import '../theme/farm_theme.dart';
import '../widgets/farm_dialogs.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _profileFormKey = GlobalKey<FormState>();
  final _emergencyFormKey = GlobalKey<FormState>();

  final _name = TextEditingController(text: 'Ramesh Patil');
  final _farm = TextEditingController(text: 'Green Valley Farm');
  final _village = TextEditingController(text: 'Khedgaon, Nashik');
  final _phone = TextEditingController(text: '+91 98765 43210');
  final _emergency = TextEditingController(text: '+91 91234 56789');

  bool _pushAlerts = true;
  bool _soundAlerts = true;
  bool _vibration = true;
  bool _dailySummary = false;
  bool _equipmentOffline = true;

  bool _autoActivate = true;
  bool _nightModeBoost = true;

  String _units = 'metric';

  @override
  void dispose() {
    _name.dispose();
    _farm.dispose();
    _village.dispose();
    _phone.dispose();
    _emergency.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (!(_profileFormKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    setState(() {});
    showFarmSnack(context, AppLocalizations.of(context).profileSaved);
  }

  void _saveEmergency() {
    if (!(_emergencyFormKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    showFarmSnack(context, AppLocalizations.of(context).emergencySaved);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ctrl = context.watch<FarmController>();
    final auth = context.watch<AuthController>();
    final localeCtrl = context.watch<LocaleController>();
    final shownName = auth.user?.displayName ?? _name.text;
    final accountLine = auth.user == null
        ? l10n.notSignedIn
        : auth.isGuest
            ? l10n.guestMode
            : [
                if (auth.user!.phone != null) '${l10n.phone} · ${auth.user!.phone}',
                if (auth.user!.username != null)
                  '${l10n.username} · ${auth.user!.username}',
              ].where((e) => e.isNotEmpty).join(' · ');

    return Scaffold(
      backgroundColor: FarmColors.page,
      appBar: AppBar(
        title: Text(l10n.profileSettings),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 36),
        children: [
          _ProfileHeader(
            name: shownName,
            accountLine: accountLine,
            farm: _farm.text,
            village: _village.text,
          ),
          const SizedBox(height: 22),

          _SectionTitle(l10n.sectionYourDetails),
          _Panel(
            child: Form(
              key: _profileFormKey,
              child: Column(
                children: [
                  _FormField(
                    label: l10n.yourName,
                    controller: _name,
                    textInputAction: TextInputAction.next,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? l10n.enterYourName : null,
                  ),
                  _FormField(
                    label: l10n.farmName,
                    controller: _farm,
                    textInputAction: TextInputAction.next,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? l10n.enterFarmName
                        : null,
                  ),
                  _FormField(
                    label: l10n.villageArea,
                    controller: _village,
                    textInputAction: TextInputAction.next,
                  ),
                  _FormField(
                    label: l10n.yourPhone,
                    controller: _phone,
                    keyboard: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _saveProfile(),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9+\s-]')),
                    ],
                    validator: (v) {
                      final t = v?.trim() ?? '';
                      if (t.length < 8) return l10n.enterValidPhone;
                      return null;
                    },
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: _saveProfile,
                      style: FilledButton.styleFrom(
                        backgroundColor: FarmColors.deep,
                        foregroundColor: FarmColors.foam,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        l10n.saveProfile,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),

          _SectionTitle(l10n.sectionEmergency),
          _Panel(
            child: Form(
              key: _emergencyFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.emergencyHelp,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: FarmColors.sage,
                      height: 1.4,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _FormField(
                    label: l10n.emergencyPhone,
                    controller: _emergency,
                    keyboard: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _saveEmergency(),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9+\s-]')),
                    ],
                    validator: (v) {
                      final t = v?.trim() ?? '';
                      if (t.length < 8) {
                        return l10n.enterValidEmergency;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: _saveEmergency,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: FarmColors.deep,
                        backgroundColor: FarmColors.foam.withValues(alpha: 0.55),
                        side: BorderSide(
                          color: FarmColors.deep.withValues(alpha: 0.18),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        l10n.saveEmergency,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),

          _SectionTitle(l10n.sectionDevices),
          _Panel(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (var i = 0; i < ctrl.devices.length; i++) ...[
                  if (i > 0)
                    Divider(
                      height: 1,
                      indent: 68,
                      color: FarmColors.border.withValues(alpha: 0.8),
                    ),
                  _DeviceRow(
                    name: ctrl.devices[i].name,
                    type: ctrl.devices[i].type,
                    online: ctrl.devices[i].online,
                    onTap: () {
                      ctrl.toggleDevice(i);
                      final d = ctrl.devices[i];
                      showFarmSnack(
                        context,
                        l10n.deviceNowStatus(
                          d.name,
                          d.online ? l10n.online : l10n.offline,
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
            child: Text(
              l10n.tapDeviceToggle,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: FarmColors.sage,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 22),

          _SectionTitle(l10n.sectionAlertsSounds),
          _Panel(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              children: [
                _SettingSwitch(
                  title: l10n.pushAlerts,
                  subtitle: l10n.pushAlertsSub,
                  value: _pushAlerts,
                  onChanged: (v) => setState(() => _pushAlerts = v),
                ),
                _SettingSwitch(
                  title: l10n.alertSounds,
                  subtitle: l10n.alertSoundsSub,
                  value: _soundAlerts,
                  onChanged: (v) => setState(() => _soundAlerts = v),
                ),
                _SettingSwitch(
                  title: l10n.vibration,
                  subtitle: l10n.vibrationSub,
                  value: _vibration,
                  onChanged: (v) => setState(() => _vibration = v),
                ),
                _SettingSwitch(
                  title: l10n.equipmentOfflineAlerts,
                  subtitle: l10n.equipmentOfflineSub,
                  value: _equipmentOffline,
                  onChanged: (v) => setState(() => _equipmentOffline = v),
                ),
                _SettingSwitch(
                  title: l10n.dailySummary,
                  subtitle: l10n.dailySummarySub,
                  value: _dailySummary,
                  onChanged: (v) => setState(() => _dailySummary = v),
                  showDivider: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          _SectionTitle(l10n.sectionDetection),
          _Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SettingSwitch(
                  title: l10n.autoActivate,
                  subtitle: l10n.autoActivateSub,
                  value: _autoActivate,
                  onChanged: (v) => setState(() => _autoActivate = v),
                  dense: true,
                ),
                _SettingSwitch(
                  title: l10n.nightWatch,
                  subtitle: l10n.nightWatchSub,
                  value: _nightModeBoost,
                  onChanged: (v) => setState(() => _nightModeBoost = v),
                  dense: true,
                  showDivider: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          _SectionTitle(l10n.sectionPreferences),
          _Panel(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  leading: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: FarmColors.foam,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.language_rounded,
                        color: FarmColors.moss),
                  ),
                  title: Text(
                    l10n.language,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  subtitle: Text(
                    localeCtrl.displayName(localeCtrl.locale),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: FarmColors.sage,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded,
                      color: FarmColors.sage),
                  onTap: () => context.push('/language'),
                ),
                Divider(
                  height: 1,
                  indent: 74,
                  color: FarmColors.border.withValues(alpha: 0.8),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.units,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: FarmColors.deep,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _UnitChip(
                              label: l10n.metric,
                              hint: l10n.metricHint,
                              selected: _units == 'metric',
                              onTap: () => setState(() => _units = 'metric'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _UnitChip(
                              label: l10n.imperial,
                              hint: l10n.imperialHint,
                              selected: _units == 'imperial',
                              onTap: () => setState(() => _units = 'imperial'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          _SectionTitle(l10n.sectionHelp),
          _Panel(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _LinkTile(
                  icon: Icons.menu_book_rounded,
                  title: l10n.howToUse,
                  subtitle: l10n.howToUseSub,
                  onTap: () => showFarmDialog(
                    context,
                    title: l10n.howToUseTitle,
                    body: l10n.howToUseBody,
                  ),
                ),
                _LinkTile(
                  icon: Icons.chat_bubble_outline_rounded,
                  title: l10n.chatSupport,
                  subtitle: 'help@kavach.app',
                  onTap: () => showFarmDialog(
                    context,
                    title: l10n.supportChatTitle,
                    body: l10n.supportChatBody,
                    confirmLabel: l10n.sendMessage,
                    onConfirm: () =>
                        showFarmSnack(context, l10n.supportMessageSent),
                  ),
                ),
                _LinkTile(
                  icon: Icons.phone_in_talk_rounded,
                  title: l10n.callHelpline,
                  subtitle: '1800-123-4567',
                  showDivider: false,
                  onTap: () => showFarmDialog(
                    context,
                    title: l10n.callHelpline,
                    body: l10n.callHelplineBody,
                    confirmLabel: l10n.copyNumber,
                    onConfirm: () => showFarmSnack(
                      context,
                      l10n.callHelplineBody.split('\n').first,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          _SectionTitle(l10n.sectionAbout),
          _Panel(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: Image.asset(
                    'assets/images/kavach_logo.png',
                    width: 44,
                    height: 72,
                    fit: BoxFit.contain,
                  ),
                  title: Text(
                    l10n.appName,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  subtitle: Text(
                    l10n.versionFarmProtection,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: FarmColors.sage,
                    ),
                  ),
                ),
                Divider(
                  height: 1,
                  indent: 74,
                  color: FarmColors.border.withValues(alpha: 0.8),
                ),
                _LinkTile(
                  icon: Icons.privacy_tip_outlined,
                  title: l10n.privacy,
                  mutedIcon: true,
                  onTap: () => showFarmDialog(
                    context,
                    title: l10n.privacy,
                    body: l10n.privacyBody,
                  ),
                ),
                _LinkTile(
                  icon: Icons.description_outlined,
                  title: l10n.termsOfUse,
                  mutedIcon: true,
                  showDivider: false,
                  onTap: () => showFarmDialog(
                    context,
                    title: l10n.termsOfUse,
                    body: l10n.termsBody,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: FarmColors.danger,
                side: const BorderSide(color: FarmColors.danger, width: 1.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                showFarmDialog(
                  context,
                  title: l10n.signOutConfirm,
                  body: l10n.signOutBody,
                  confirmLabel: l10n.signOut,
                  onConfirm: () {
                    context.read<AuthController>().signOut();
                    context.go('/welcome');
                  },
                );
              },
              icon: const Icon(Icons.logout_rounded),
              label: Text(
                l10n.signOut,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final String name;
  final String accountLine;
  final String farm;
  final String village;

  const _ProfileHeader({
    required this.name,
    required this.accountLine,
    required this.farm,
    required this.village,
  });

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: FarmColors.softGreen,
              shape: BoxShape.circle,
              border: Border.all(
                color: FarmColors.mist.withValues(alpha: 0.6),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 30,
                color: FarmColors.deep,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 19,
                    color: FarmColors.deep,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  accountLine,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: FarmColors.moss,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.agriculture_rounded,
                        size: 15, color: FarmColors.sage),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        farm,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: FarmColors.sage,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded,
                        size: 15, color: FarmColors.sage),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        village,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: FarmColors.sage,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 16,
          color: FarmColors.deep,
        ),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  const _Panel({required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: FarmColors.deep.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _FormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboard;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onSubmitted;

  const _FormField({
    required this.label,
    required this.controller,
    this.keyboard,
    this.textInputAction,
    this.validator,
    this.inputFormatters,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: FarmColors.moss,
            ),
          ),
          const SizedBox(height: 7),
          TextFormField(
            controller: controller,
            keyboardType: keyboard,
            textInputAction: textInputAction,
            inputFormatters: inputFormatters,
            validator: validator,
            onFieldSubmitted: onSubmitted,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: FarmColors.deep,
              fontSize: 15,
            ),
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: FarmColors.foam.withValues(alpha: 0.65),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: FarmColors.border.withValues(alpha: 0.7),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: FarmColors.moss,
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: FarmColors.danger),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: FarmColors.danger,
                  width: 1.5,
                ),
              ),
              errorStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingSwitch extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool showDivider;
  final bool dense;

  const _SettingSwitch({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.showDivider = true,
    this.dense = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          contentPadding: dense
              ? EdgeInsets.zero
              : const EdgeInsets.symmetric(horizontal: 12),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
              color: FarmColors.deep,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: FarmColors.sage,
              fontSize: 12.5,
            ),
          ),
          value: value,
          activeThumbColor: FarmColors.deep,
          activeTrackColor: FarmColors.mist,
          onChanged: onChanged,
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: dense ? 0 : 12,
            endIndent: dense ? 0 : 12,
            color: FarmColors.border.withValues(alpha: 0.75),
          ),
      ],
    );
  }
}

class _UnitChip extends StatelessWidget {
  final String label;
  final String hint;
  final bool selected;
  final VoidCallback onTap;

  const _UnitChip({
    required this.label,
    required this.hint,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? FarmColors.softGreen : FarmColors.page,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? FarmColors.moss.withValues(alpha: 0.45)
                  : FarmColors.border,
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Column(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: FarmColors.deep,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                hint,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: FarmColors.sage,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LinkTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool showDivider;
  final bool mutedIcon;

  const _LinkTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.showDivider = true,
    this.mutedIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          leading: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: FarmColors.foam,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: mutedIcon ? FarmColors.sage : FarmColors.moss,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          subtitle: subtitle == null
              ? null
              : Text(
                  subtitle!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: FarmColors.sage,
                  ),
                ),
          trailing: const Icon(Icons.chevron_right_rounded,
              color: FarmColors.sage),
          onTap: onTap,
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: 74,
            color: FarmColors.border.withValues(alpha: 0.8),
          ),
      ],
    );
  }
}

class _DeviceRow extends StatelessWidget {
  final String name;
  final String type;
  final bool online;
  final VoidCallback onTap;

  const _DeviceRow({
    required this.name,
    required this.type,
    required this.online,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: online ? FarmColors.softGreen : FarmColors.softRed,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.memory_rounded,
          color: online ? FarmColors.deep : FarmColors.danger,
        ),
      ),
      title: Text(
        name,
        style: const TextStyle(fontWeight: FontWeight.w800),
      ),
      subtitle: Text(
        type,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: FarmColors.sage,
        ),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: online ? FarmColors.softGreen : FarmColors.softRed,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          online ? l10n.online : l10n.offline,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 12,
            color: online ? FarmColors.deep : FarmColors.danger,
          ),
        ),
      ),
    );
  }
}
