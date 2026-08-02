import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../theme/app_colors.dart';
import '../widgets/as_card.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final weekly = AppData.weekly;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
          children: [
            Text('Analytics',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 4),
            Text('Protection intelligence',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _Kpi('94%', 'Protection', colors.success)),
                const SizedBox(width: 12),
                Expanded(child: _Kpi('4.2s', 'Response', colors.warning)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _Kpi('49', 'Events', colors.primary)),
                const SizedBox(width: 12),
                Expanded(child: _Kpi('7', 'Animals', colors.accent)),
              ],
            ),
            const SizedBox(height: 28),
            const AsSectionHeader(
              title: 'Detection trend',
              subtitle: 'Weekly activity',
            ),
            AsCard(
              child: SizedBox(
                height: 210,
                child: LineChart(
                  LineChartData(
                    minY: 0,
                    maxY: 14,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (v) => FlLine(
                        color: colors.divider,
                        strokeWidth: 1,
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (v, _) {
                            final i = v.toInt();
                            if (i < 0 || i >= AppData.days.length) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                AppData.days[i],
                                style: TextStyle(
                                  color: colors.textSecondary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        color: colors.primary,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              colors.primary.withValues(alpha: 0.28),
                              colors.primary.withValues(alpha: 0.01),
                            ],
                          ),
                        ),
                        spots: [
                          for (var i = 0; i < weekly.length; i++)
                            FlSpot(i.toDouble(), weekly[i]),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            const AsSectionHeader(
              title: 'Animal distribution',
              subtitle: 'Relative frequency',
            ),
            const AsCard(
              child: Column(
                children: [
                  _Bar('Cow', 0.38),
                  SizedBox(height: 16),
                  _Bar('Buffalo', 0.24),
                  SizedBox(height: 16),
                  _Bar('Wild Pig', 0.20),
                  SizedBox(height: 16),
                  _Bar('Goat', 0.18),
                ],
              ),
            ),
            const SizedBox(height: 28),
            const AsSectionHeader(
              title: 'Zone heatmap',
              subtitle: 'Intrusion density',
            ),
            AsCard(
              child: Column(
                children: [
                  Row(
                    children: [
                      _Heat('North', 0.9, colors.danger),
                      const SizedBox(width: 10),
                      _Heat('East', 0.55, colors.warning),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _Heat('West', 0.35, colors.primary),
                      const SizedBox(width: 10),
                      _Heat('South', 0.2, colors.success),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Kpi extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _Kpi(this.value, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return AsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: color)),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final String label;
  final double value;
  const _Bar(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Text(label)),
            Text('${(value * 100).toInt()}%',
                style: const TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 10,
            backgroundColor: colors.divider,
            color: colors.primary,
          ),
        ),
      ],
    );
  }
}

class _Heat extends StatelessWidget {
  final String label;
  final double intensity;
  final Color color;
  const _Heat(this.label, this.intensity, this.color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 72,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12 + intensity * 0.25),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
