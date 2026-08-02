import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/locale_controller.dart';
import '../theme/farm_theme.dart';

class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final localeCtrl = context.watch<LocaleController>();
    final current = localeCtrl.locale;

    final options = <({Locale locale, String label, String flag})>[
      (locale: const Locale('en'), label: l10n.english, flag: '🇬🇧'),
      (locale: const Locale('hi'), label: l10n.hindi, flag: '🇮🇳'),
      (locale: const Locale('gu'), label: l10n.gujarati, flag: '🇮🇳'),
    ];

    return Scaffold(
      backgroundColor: FarmColors.page,
      appBar: AppBar(title: Text(l10n.languageSettings)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('🌐', style: TextStyle(fontSize: 22)),
                    const SizedBox(width: 10),
                    Text(
                      l10n.language,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: FarmColors.deep,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...options.map((o) {
                  final selected =
                      current.languageCode == o.locale.languageCode;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Material(
                      color: selected
                          ? FarmColors.mist.withValues(alpha: 0.55)
                          : FarmColors.page,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () =>
                            localeCtrl.setLocale(o.locale, markChosen: true),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                selected
                                    ? Icons.radio_button_checked_rounded
                                    : Icons.radio_button_off_rounded,
                                color: selected
                                    ? FarmColors.deep
                                    : FarmColors.sage,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  '${o.flag}  ${o.label}',
                                  style: TextStyle(
                                    fontWeight: selected
                                        ? FontWeight.w800
                                        : FontWeight.w600,
                                    color: FarmColors.deep,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                const Divider(height: 28),
                Text(
                  l10n.currentLanguage(localeCtrl.displayName(current)),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: FarmColors.sage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
