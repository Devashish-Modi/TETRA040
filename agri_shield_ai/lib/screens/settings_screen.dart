import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/as_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _push = true;
  bool _sound = true;
  double _sensitivity = 0.7;
  String _lang = 'English';

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Preferences')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Text('Detection', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          AsCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                        child: Text('Detection Sensitivity',
                            style: TextStyle(fontWeight: FontWeight.w700))),
                    Text('${(_sensitivity * 100).toInt()}%',
                        style: TextStyle(
                          color: colors.primary,
                          fontWeight: FontWeight.w800,
                        )),
                  ],
                ),
                Slider(
                  value: _sensitivity,
                  onChanged: (v) => setState(() => _sensitivity = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AsCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Push Notifications'),
                  value: _push,
                  onChanged: (v) => setState(() => _push = v),
                ),
                Divider(height: 1, color: colors.divider),
                SwitchListTile(
                  title: const Text('Alert Sounds'),
                  value: _sound,
                  onChanged: (v) => setState(() => _sound = v),
                ),
                Divider(height: 1, color: colors.divider),
                ListTile(
                  title: const Text('Language'),
                  trailing: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _lang,
                      dropdownColor: colors.surface,
                      items: const [
                        DropdownMenuItem(
                            value: 'English', child: Text('English')),
                        DropdownMenuItem(value: 'Hindi', child: Text('Hindi')),
                        DropdownMenuItem(
                            value: 'Marathi', child: Text('Marathi')),
                      ],
                      onChanged: (v) {
                        if (v != null) setState(() => _lang = v);
                      },
                    ),
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
