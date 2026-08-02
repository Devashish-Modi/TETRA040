import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/locale_controller.dart';
import '../theme/farm_theme.dart';

/// Shown after Welcome so users pick a language before using the app.
class LanguageOnboardingScreen extends StatefulWidget {
  final String next;
  const LanguageOnboardingScreen({super.key, this.next = 'login'});

  @override
  State<LanguageOnboardingScreen> createState() =>
      _LanguageOnboardingScreenState();
}

class _LanguageOnboardingScreenState extends State<LanguageOnboardingScreen>
    with SingleTickerProviderStateMixin {
  Locale? _selected;
  late final AnimationController _anim;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selected ??= context.read<LocaleController>().locale;
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    final selected = _selected ?? const Locale('en');
    await context.read<LocaleController>().chooseLanguage(selected);
    if (!mounted) return;
    if (widget.next == 'home') {
      context.go('/home');
    } else {
      context.go('/welcome?form=1');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final selected = _selected ?? const Locale('en');
    final options = <({Locale locale, String label, String native, String flag})>[
      (
        locale: const Locale('en'),
        label: l10n.english,
        native: 'English',
        flag: '🇬🇧',
      ),
      (
        locale: const Locale('hi'),
        label: l10n.hindi,
        native: 'हिन्दी',
        flag: '🇮🇳',
      ),
      (
        locale: const Locale('gu'),
        label: l10n.gujarati,
        native: 'ગુજરાતી',
        flag: '🇮🇳',
      ),
    ];

    return Scaffold(
      backgroundColor: FarmColors.page,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fade,
          child: SlideTransition(
            position: _slide,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 4),
                  Center(
                    child: Image.asset(
                      'assets/images/kavach_logo.png',
                      width: 200,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.chooseLanguageTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: FarmColors.deep,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.chooseLanguageBody,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: FarmColors.sage,
                      height: 1.35,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      itemCount: options.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final o = options[i];
                        final isSelected =
                            selected.languageCode == o.locale.languageCode;
                        return Material(
                          color: isSelected
                              ? FarmColors.softGreen
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () async {
                              setState(() => _selected = o.locale);
                              await context
                                  .read<LocaleController>()
                                  .setLocale(o.locale);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 280),
                              curve: Curves.easeOutCubic,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 18,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? FarmColors.moss.withValues(alpha: 0.5)
                                      : FarmColors.border,
                                  width: isSelected ? 1.6 : 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: FarmColors.deep
                                        .withValues(alpha: 0.04),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Text(o.flag,
                                      style: const TextStyle(fontSize: 28)),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          o.native,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 18,
                                            color: FarmColors.deep,
                                          ),
                                        ),
                                        Text(
                                          o.label,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: FarmColors.sage,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    isSelected
                                        ? Icons.check_circle_rounded
                                        : Icons.circle_outlined,
                                    color: isSelected
                                        ? FarmColors.deep
                                        : FarmColors.sage,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 56,
                    child: FilledButton(
                      onPressed: _continue,
                      style: FilledButton.styleFrom(
                        backgroundColor: FarmColors.deep,
                        foregroundColor: FarmColors.foam,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Text(
                        l10n.continueLabel,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
