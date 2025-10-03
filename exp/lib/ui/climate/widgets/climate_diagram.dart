import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import '../view_model/climate_view_model.dart';

class ClimateDiagram extends StatelessWidget with WatchItMixin {
  const ClimateDiagram({super.key});

  @override
  Widget build(BuildContext context) {
    final climateData = sl<ClimateViewModel>().climateData;
    if (climateData == null) return const SizedBox.shrink();

    final data = climateData.daily;
    final maxTemp = data.temperature2mMax;
    final minTemp = data.temperature2mMin;
    final precip = data.precipitationSum;
    final dates = data.time;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(show: true),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    if (value % 30 != 0) return const Text('');
                    final index = value.toInt();
                    if (index >= 0 && index < dates.length) {
                      return Text(dates[index].substring(5)); // Show MM-DD
                    }
                    return const Text('');
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: true),
            lineBarsData: [
              // Max Temperature
              LineChartBarData(
                spots: maxTemp.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
                isCurved: true,
                color: Colors.red,
                dotData: const FlDotData(show: false),
              ),
              // Min Temperature
              LineChartBarData(
                spots: minTemp.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
                isCurved: true,
                color: Colors.blue,
                dotData: const FlDotData(show: false),
              ),
              // Precipitation
              LineChartBarData(
                spots: precip.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
                isCurved: true,
                color: Colors.green,
                dotData: const FlDotData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
