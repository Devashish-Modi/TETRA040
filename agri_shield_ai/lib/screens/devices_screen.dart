import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../theme/app_colors.dart';
import '../widgets/as_card.dart';
import '../widgets/as_chip.dart';

class DevicesScreen extends StatelessWidget {
  const DevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Connected Devices')),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        itemCount: AppData.devices.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final d = AppData.devices[i];
          final c = d.online ? colors.success : colors.danger;
          return AsCard(
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: c.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(Icons.memory_rounded, color: c),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(d.name,
                          style: Theme.of(context).textTheme.titleMedium),
                      Text(d.type,
                          style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          AsChip(
                            label: d.online ? 'Online' : 'Offline',
                            tone: d.online
                                ? AsChipTone.success
                                : AsChipTone.offline,
                          ),
                          Text('Battery ${d.battery}%',
                              style: Theme.of(context).textTheme.bodyMedium),
                          Text('Signal ${d.signal}%',
                              style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
