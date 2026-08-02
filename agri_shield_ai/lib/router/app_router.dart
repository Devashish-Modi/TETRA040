import 'package:go_router/go_router.dart';
import '../screens/activate_screen.dart';
import '../screens/alerts_screen.dart';
import '../screens/home_screen.dart';
import '../screens/language_onboarding_screen.dart';
import '../screens/language_settings_screen.dart';
import '../screens/live_feed_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/shell_scaffold.dart';
import '../screens/splash_screen.dart';
import '../screens/welcome_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (_, __) => const SplashScreen(),
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) {
        final form = state.uri.queryParameters['form'] == '1';
        return WelcomeScreen(startWithForm: form);
      },
    ),
    GoRoute(
      path: '/choose-language',
      builder: (context, state) {
        final next = state.uri.queryParameters['next'] ?? 'login';
        return LanguageOnboardingScreen(next: next);
      },
    ),
    GoRoute(
      path: '/activate',
      builder: (_, __) => const ActivateScreen(),
    ),
    GoRoute(
      path: '/language',
      builder: (_, __) => const LanguageSettingsScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ShellScaffold(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/live', builder: (_, __) => const LiveFeedScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/alerts', builder: (_, __) => const AlertsScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
              path: '/profile', builder: (_, __) => const ProfileScreen()),
        ]),
      ],
    ),
  ],
);
