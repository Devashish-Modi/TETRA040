import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/as_button.dart';
import 'root_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phone = TextEditingController(text: '9876543210');
  final _pin = TextEditingController(text: '1234');

  @override
  void dispose() {
    _phone.dispose();
    _pin.dispose();
    super.dispose();
  }

  void _enter() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const RootShell(),
        transitionsBuilder: (_, a, __, c) =>
            FadeTransition(opacity: a, child: c),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 36, 24, 28),
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [colors.primary, colors.secondary],
                ),
              ),
              child: const Icon(Icons.shield_rounded,
                  color: Colors.white, size: 30),
            ),
            const SizedBox(height: 28),
            Text('Welcome to\nKAVACH',
                style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 10),
            Text(
              'Sign in to monitor perimeter, alerts, and AI deterrents.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: colors.textSecondary,
                  ),
            ),
            const SizedBox(height: 36),
            Text('Phone number',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              style: TextStyle(color: colors.text),
              decoration: _dec(context, 'Enter phone'),
            ),
            const SizedBox(height: 16),
            Text('PIN', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _pin,
              obscureText: true,
              keyboardType: TextInputType.number,
              style: TextStyle(color: colors.text),
              decoration: _dec(context, '4-digit PIN'),
            ),
            const SizedBox(height: 28),
            AsButton(
              label: 'Continue',
              icon: Icons.arrow_forward_rounded,
              onPressed: _enter,
            ),
            const SizedBox(height: 12),
            AsButton(
              label: 'Continue as Guest',
              outlined: true,
              onPressed: _enter,
            ),
            const SizedBox(height: 24),
            Text(
              'UI prototype — any credentials work.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _dec(BuildContext context, String hint) {
    final colors = AppColors.of(context);
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: colors.textMuted),
      filled: true,
      fillColor: colors.surface,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colors.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colors.primary, width: 1.5),
      ),
    );
  }
}
