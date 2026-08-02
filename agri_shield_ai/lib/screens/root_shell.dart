import 'package:flutter/material.dart';
import '../widgets/as_nav.dart';
import 'alerts_screen.dart';
import 'analytics_screen.dart';
import 'dashboard_screen.dart';
import 'devices_screen.dart';
import 'live_monitor_screen.dart';
import 'profile_screen.dart';

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardScreen(
        onNavigate: (i) {
          if (i == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DevicesScreen()),
            );
            return;
          }
          setState(() => _index = i);
        },
      ),
      const LiveMonitorScreen(),
      const AlertsScreen(),
      const AnalyticsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      extendBody: true,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 280),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.02, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: KeyedSubtree(
          key: ValueKey(_index),
          child: pages[_index],
        ),
      ),
      bottomNavigationBar: AsNav(
        index: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}
