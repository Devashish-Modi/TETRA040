import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/auth_controller.dart';
import '../providers/locale_controller.dart';
import '../theme/farm_theme.dart';
import '../widgets/farm_dialogs.dart';

enum _LoginMode { phone, username }

/// 0 = welcome · 1 = language · 2 = login
enum _WelcomeStep { welcome, language, login }

class WelcomeScreen extends StatefulWidget {
  final bool startWithForm;
  const WelcomeScreen({super.key, this.startWithForm = false});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late _WelcomeStep _step;
  _LoginMode _mode = _LoginMode.phone;
  bool _register = false;
  bool _obscure = true;
  Locale _selectedLocale = const Locale('en');

  final _phone = TextEditingController(text: '9876543210');
  final _username = TextEditingController(text: 'ramesh');
  final _password = TextEditingController(text: 'farm1234');
  final _name = TextEditingController(text: 'Ramesh Patil');

  @override
  void initState() {
    super.initState();
    _step = widget.startWithForm ? _WelcomeStep.login : _WelcomeStep.welcome;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedLocale = context.read<LocaleController>().locale;
  }

  @override
  void dispose() {
    _phone.dispose();
    _username.dispose();
    _password.dispose();
    _name.dispose();
    super.dispose();
  }

  String _authError(AppLocalizations l10n, String code) {
    switch (code) {
      case 'invalid_phone':
        return l10n.errInvalidPhone;
      case 'password_short':
        return l10n.errPasswordShort;
      case 'wrong_phone_password':
        return l10n.errWrongPhonePassword;
      case 'invalid_username':
        return l10n.errInvalidUsername;
      case 'wrong_username_password':
        return l10n.errWrongUsernamePassword;
      case 'enter_name':
        return l10n.errEnterName;
      case 'phone_registered':
        return l10n.errPhoneRegistered;
      case 'username_short':
        return l10n.errUsernameShort;
      case 'username_taken':
        return l10n.errUsernameTaken;
      default:
        return code;
    }
  }

  void _goAfterAuth() {
    context.go('/home');
  }

  void _submit() {
    final auth = context.read<AuthController>();
    final l10n = AppLocalizations.of(context);
    String? error;

    if (_register) {
      error = auth.register(
        displayName: _name.text,
        password: _password.text,
        phoneRaw: _phone.text,
        usernameRaw: _username.text,
        usePhone: _mode == _LoginMode.phone,
      );
    } else if (_mode == _LoginMode.phone) {
      error = auth.loginWithPhone(_phone.text, _password.text);
    } else {
      error = auth.loginWithUsername(_username.text, _password.text);
    }

    if (error != null) {
      showFarmSnack(context, _authError(l10n, error));
      return;
    }

    showFarmSnack(
      context,
      l10n.welcomeUser(auth.user!.displayName),
    );
    _goAfterAuth();
  }

  void _startApp() {
    setState(() {
      _step = _WelcomeStep.language;
    });
  }

  Future<void> _continueAfterLanguage() async {
    await context.read<LocaleController>().chooseLanguage(_selectedLocale);
    if (!mounted) return;
    setState(() => _step = _WelcomeStep.login);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 480),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        final fade = CurvedAnimation(parent: animation, curve: Curves.easeOut);
        final slide = Tween<Offset>(
          begin: const Offset(0.06, 0),
          end: Offset.zero,
        ).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
        return FadeTransition(
          opacity: fade,
          child: SlideTransition(position: slide, child: child),
        );
      },
      child: switch (_step) {
        _WelcomeStep.welcome => _buildWelcome(),
        _WelcomeStep.language => _buildLanguage(),
        _WelcomeStep.login => _buildLogin(),
      },
    );
  }

  Widget _buildLanguage() {
    final l10n = AppLocalizations.of(context);
    final options = <({Locale locale, String native, String flag})>[
      (locale: const Locale('en'), native: 'English', flag: '🇬🇧'),
      (locale: const Locale('hi'), native: 'हिन्दी', flag: '🇮🇳'),
      (locale: const Locale('gu'), native: 'ગુજરાતી', flag: '🇮🇳'),
    ];

    return Scaffold(
      key: const ValueKey('language'),
      backgroundColor: FarmColors.page,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () =>
                      setState(() => _step = _WelcomeStep.welcome),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.arrow_back_rounded,
                      color: FarmColors.deep),
                ),
              ),
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
                    final selected =
                        _selectedLocale.languageCode == o.locale.languageCode;
                    return Material(
                      color: selected ? FarmColors.softGreen : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () async {
                          setState(() => _selectedLocale = o.locale);
                          await context
                              .read<LocaleController>()
                              .setLocale(o.locale);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 18,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: selected
                                  ? FarmColors.moss.withValues(alpha: 0.5)
                                  : FarmColors.border,
                              width: selected ? 1.6 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(o.flag,
                                  style: const TextStyle(fontSize: 28)),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  o.native,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18,
                                    color: FarmColors.deep,
                                  ),
                                ),
                              ),
                              Icon(
                                selected
                                    ? Icons.check_circle_rounded
                                    : Icons.circle_outlined,
                                color: selected
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
              SizedBox(
                height: 56,
                child: FilledButton(
                  onPressed: _continueAfterLanguage,
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
    );
  }

  Widget _buildWelcome() {
    return Scaffold(
      key: const ValueKey('welcome'),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/welcome_farm.png',
            fit: BoxFit.cover,
            alignment: const Alignment(0, -0.15),
          ),
          // Soft top fade + stronger bottom for text
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x330F2A1D),
                  Color(0x00000000),
                  Color(0xCC0F2A1D),
                  Color(0xF20F2A1D),
                ],
                stops: [0.0, 0.35, 0.7, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  Text(
                    'KAVACH',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: FarmColors.lime,
                          fontSize: 18,
                          letterSpacing: 2.4,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context).welcomeTitle,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Colors.white,
                          height: 1.12,
                          fontSize: 36,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppLocalizations.of(context).welcomeBody,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.88),
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 28),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: FarmColors.lime,
                      foregroundColor: FarmColors.deep,
                      minimumSize: const Size.fromHeight(56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: _startApp,
                    child: Text(AppLocalizations.of(context).getStarted),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogin() {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      key: const ValueKey('login'),
      backgroundColor: FarmColors.page,
      body: Stack(
        children: [
          // Soft photo header strip
          SizedBox(
            height: 220,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/welcome_farm.png',
                  fit: BoxFit.cover,
                  alignment: const Alignment(0, 0.2),
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0x660F2A1D),
                        Color(0xEEF3F6F0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 16, 0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () =>
                            setState(() => _step = _WelcomeStep.language),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.9),
                        ),
                        icon: const Icon(Icons.arrow_back_rounded,
                            color: FarmColors.deep),
                      ),
                      const Spacer(),
                      Text(
                        _register ? l10n.joinKavach : l10n.signIn,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: FarmColors.deep.withValues(alpha: 0.08),
                              blurRadius: 28,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _register ? l10n.createAccount : l10n.welcomeBack,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(fontSize: 26),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _register
                                  ? l10n.setupFarmLogin
                                  : l10n.loginWithPhoneOrUsername,
                              style: const TextStyle(
                                color: FarmColors.sage,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: FarmColors.page,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  _ModeChip(
                                    label: l10n.phone,
                                    selected: _mode == _LoginMode.phone,
                                    onTap: () => setState(
                                        () => _mode = _LoginMode.phone),
                                  ),
                                  _ModeChip(
                                    label: l10n.username,
                                    selected: _mode == _LoginMode.username,
                                    onTap: () => setState(
                                        () => _mode = _LoginMode.username),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 18),
                            if (_register) ...[
                              _LabeledField(
                                label: l10n.yourName,
                                child: TextField(
                                  controller: _name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700),
                                  decoration: _dec(l10n.farmerNameHint),
                                ),
                              ),
                              const SizedBox(height: 14),
                            ],
                            _LabeledField(
                              label: _mode == _LoginMode.phone
                                  ? l10n.phoneNumber
                                  : l10n.username,
                              child: TextField(
                                controller: _mode == _LoginMode.phone
                                    ? _phone
                                    : _username,
                                keyboardType: _mode == _LoginMode.phone
                                    ? TextInputType.phone
                                    : TextInputType.text,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700),
                                decoration: _dec(
                                  _mode == _LoginMode.phone
                                      ? l10n.tenDigitMobile
                                      : l10n.yourUsername,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            _LabeledField(
                              label: l10n.password,
                              child: TextField(
                                controller: _password,
                                obscureText: _obscure,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700),
                                decoration: _dec(l10n.enterPassword).copyWith(
                                  suffixIcon: IconButton(
                                    onPressed: () =>
                                        setState(() => _obscure = !_obscure),
                                    icon: Icon(
                                      _obscure
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: FarmColors.sage,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 22),
                            FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: FarmColors.lime,
                                foregroundColor: FarmColors.deep,
                                minimumSize: const Size.fromHeight(54),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: _submit,
                              child: Text(
                                _register ? l10n.createAccount : l10n.login,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: TextButton(
                                onPressed: () =>
                                    setState(() => _register = !_register),
                                child: Text(
                                  _register
                                      ? l10n.alreadyHaveAccount
                                      : l10n.newHere,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: FarmColors.moss,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: FarmColors.moss.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: FarmColors.border),
                            ),
                            child: Text(
                              l10n.demoLogin,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: FarmColors.sage,
                                height: 1.45,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _dec(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        color: FarmColors.sage,
      ),
      filled: true,
      fillColor: FarmColors.page,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: FarmColors.moss, width: 1.5),
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _ModeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: FarmColors.deep.withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: selected ? FarmColors.deep : FarmColors.sage,
            ),
          ),
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final Widget child;
  const _LabeledField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 13,
            color: FarmColors.moss,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
