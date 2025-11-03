import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import '../view_model/climate_view_model.dart';
import 'dart:math' as math;

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

    // Calculate scaling for precipitation to prevent overflow
    final maxPrecipitation = precip.reduce(math.max);
    final maxTemperature = maxTemp.reduce(math.max);
    final minTemperature = minTemp.reduce(math.min);

    // Dynamic scaling factor for precipitation
    final tempRange = maxTemperature - minTemperature;
    final precipScale = maxPrecipitation > 0
        ? (tempRange * 0.8) / maxPrecipitation
        : 1.0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Legend
          Container(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem('Max Temperature', Colors.red),
                const SizedBox(width: 24),
                _buildLegendItem('Min Temperature', Colors.blue),
                const SizedBox(width: 24),
                _buildLegendItem('Precipitation', Colors.green.withOpacity(0.7)),
              ],
            ),
          ),
          // Chart
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 48, top: 8),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 10,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: value == 0
                            ? Colors.black54
                            : Colors.grey.withOpacity(0.3),
                        strokeWidth: value == 0 ? 1 : 0.5,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: maxPrecipitation > 50 ? 20 : 10,
                        reservedSize: 48,
                        getTitlesWidget: (value, meta) {
                          if (value < 0) return const Text('');
                          final precipValue = value / precipScale;

                          return Text(
                            '${precipValue.toInt()} mm',
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 10,
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 10,
                        reservedSize: 42,
                        getTitlesWidget: (value, meta) {

                          return Text(
                            '${value.toInt()}°C',
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 10,
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 30,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 &&
                              index < data.time.length &&
                              index % 30 == 0) {
                            final date = data.time[index];
                            final parts = date.split('-');

                            return Text(
                              '${parts[2]}/${parts[1]}',
                              style: const TextStyle(fontSize: 10),
                            );
                          }

                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey.withOpacity(0.5)),
                  ),
                  minY: minTemperature - 5,
                  maxY: maxTemperature + 5,
                  lineBarsData: [
                    // Precipitation as bars (using stepped line to simulate bars)
                    LineChartBarData(
                      spots: List.generate(
                        precip.length,
                            (i) => FlSpot(i.toDouble(), precip[i] * precipScale),
                      ),
                      isCurved: false,
                      isStepLineChart: true,
                      lineChartStepData: const LineChartStepData(
                        stepDirection: LineChartStepData.stepDirectionMiddle,
                      ),
                      color: Colors.green.withOpacity(0.7),
                      barWidth: 0,
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.green.withOpacity(0.3),
                      ),
                      dotData: const FlDotData(show: false),
                    ),
                    // Max Temperature
                    LineChartBarData(
                      spots: List.generate(
                        maxTemp.length,
                            (i) => FlSpot(i.toDouble(), maxTemp[i]),
                      ),
                      isCurved: true,
                      curveSmoothness: 0.3,
                      color: Colors.red,
                      barWidth: 2,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                    // Min Temperature
                    LineChartBarData(
                      spots: List.generate(
                        minTemp.length,
                            (i) => FlSpot(i.toDouble(), minTemp[i]),
                      ),
                      isCurved: true,
                      curveSmoothness: 0.3,
                      color: Colors.blue,
                      barWidth: 2,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      tooltipPadding: const EdgeInsets.all(8),
                      tooltipMargin: 8,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((LineBarSpot touchedSpot) {
                          final index = touchedSpot.x.toInt();
                          if (index >= 0 && index < data.time.length) {
                            String label;
                            String value;
                            Color color;

                            if (touchedSpot.barIndex == 0) {
                              // Precipitation
                              label = 'Precipitation';
                              value = '${precip[index].toStringAsFixed(1)} mm';
                              color = Colors.green;
                            } else if (touchedSpot.barIndex == 1) {
                              // Max temp
                              label = 'Max Temp';
                              value = '${maxTemp[index].toStringAsFixed(1)}°C';
                              color = Colors.red;
                            } else {
                              // Min temp
                              label = 'Min Temp';
                              value = '${minTemp[index].toStringAsFixed(1)}°C';
                              color = Colors.blue;
                            }

                            return LineTooltipItem(
                              '$label: $value\n${data.time[index]}',
                              TextStyle(
                                color: color,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            );
                          }

                          return null;
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 3,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}