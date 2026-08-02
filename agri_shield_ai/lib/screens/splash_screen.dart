import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../l10n/app_localizations.dart';
import '../theme/farm_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();
    _fade = CurvedAnimation(parent: _c, curve: Curves.easeInOutCubic);
    _scale = Tween(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(parent: _c, curve: Curves.easeOutCubic),
    );

    Future.delayed(const Duration(milliseconds: 2600), () {
      if (!mounted) return;
      context.go('/welcome');
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FarmColors.foam,
      body: FadeTransition(
        opacity: _fade,
        child: ScaleTransition(
          scale: _scale,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/kavach_logo.png',
                  width: 160,
                  height: 280,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context).farmProtectionSystem,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: FarmColors.sage,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 32),
                const SizedBox(
                  width: 26,
                  height: 26,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.6,
                    color: FarmColors.deep,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
