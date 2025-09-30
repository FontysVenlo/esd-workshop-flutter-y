import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

void main() {
  runApp(const ClimateApp());
}

class ClimateApp extends StatelessWidget {
  const ClimateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Climate Diagrams',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF1a237e),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1a237e),
          foregroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.white),
          actionsIconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      home: const ClimateHomePage(),
    );
  }
}

class ClimateHomePage extends StatefulWidget {
  const ClimateHomePage({super.key});

  @override
  State<ClimateHomePage> createState() => _ClimateHomePageState();
}

class _ClimateHomePageState extends State<ClimateHomePage> {
  bool isLoading = false;
  ClimateData? climateData;
  String selectedLocation = 'Venlo';

  Map<String, Map<String, double>> locations = {
    'Brocken': {'lat': 51.7992, 'lon': 10.6183},
    'Berlin': {'lat': 52.5200, 'lon': 13.4050},
    'Munich': {'lat': 48.1351, 'lon': 11.5820},
    'Hamburg': {'lat': 53.5511, 'lon': 9.9937},
    'Frankfurt': {'lat': 50.1109, 'lon': 8.6821},
    'Venlo': {'lat': 51.3544, 'lon': 6.154031},
  };

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchClimateData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _latController.dispose();
    _lonController.dispose();
    super.dispose();
  }

  Future<void> fetchClimateData() async {
    if (!locations.containsKey(selectedLocation)) return;

    setState(() {
      isLoading = true;
    });

    final location = locations[selectedLocation]!;
    final now = DateTime.now();
    final startDate = DateTime(now.year - 1, 1, 1);
    final endDate = DateTime(now.year - 1, 12, 31);

    final url = Uri.parse(
      'https://archive-api.open-meteo.com/v1/era5?'
      'latitude=${location['lat']}&'
      'longitude=${location['lon']}&'
      'start_date=${DateFormat('yyyy-MM-dd').format(startDate)}&'
      'end_date=${DateFormat('yyyy-MM-dd').format(endDate)}&'
      'daily=temperature_2m_max,temperature_2m_min,precipitation_sum&'
      'timezone=Europe/Berlin',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          climateData = ClimateData.fromJson(data);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load climate data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading data: $e')));
      }
    }
  }

  void _showAddLocationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Location'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Location Name', hintText: 'e.g., Cologne'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _latController,
                decoration: const InputDecoration(labelText: 'Latitude', hintText: 'e.g., 50.9375'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _lonController,
                decoration: const InputDecoration(labelText: 'Longitude', hintText: 'e.g., 6.9603'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _nameController.clear();
                _latController.clear();
                _lonController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text.trim();
                final lat = double.tryParse(_latController.text);
                final lon = double.tryParse(_lonController.text);

                if (name.isNotEmpty && lat != null && lon != null) {
                  setState(() {
                    locations[name] = {'lat': lat, 'lon': lon};
                    selectedLocation = name;
                  });
                  _nameController.clear();
                  _latController.clear();
                  _lonController.clear();
                  Navigator.of(context).pop();
                  fetchClimateData();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter valid data')));
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showRemoveLocationDialog() {
    if (locations.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cannot remove the last location')));
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Location'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Select location to remove:'),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                width: 300,
                child: ListView(
                  children: locations.keys.map((location) {
                    return ListTile(
                      title: Text(location),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          if (locations.length > 1) {
                            setState(() {
                              locations.remove(location);
                              if (selectedLocation == location) {
                                selectedLocation = locations.keys.first;
                              }
                            });
                            Navigator.of(context).pop();
                            fetchClimateData();
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close'))],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Climate Diagram - $selectedLocation'),
        actions: [
          DropdownButton<String>(
            value: selectedLocation,
            dropdownColor: const Color(0xFF1a237e),
            style: const TextStyle(color: Colors.white),
            iconEnabledColor: Colors.white,
            items: locations.keys.map((String location) {
              return DropdownMenuItem<String>(
                value: location,
                child: Text(location, style: const TextStyle(color: Colors.white)),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedLocation = newValue;
                });
                fetchClimateData();
              }
            },
          ),
          IconButton(icon: const Icon(Icons.add_location), onPressed: _showAddLocationDialog, tooltip: 'Add Location'),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: _showRemoveLocationDialog,
            tooltip: 'Remove Location',
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : climateData == null
          ? const Center(
              child: Text('No data available', style: TextStyle(color: Colors.white)),
            )
          : Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Card(
                    elevation: 8,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 500,
                            width: MediaQuery.of(context).size.width * 0.85,
                            child: CombinedClimateChart(data: climateData!),
                          ),
                          const SizedBox(height: 20),
                          _buildLegend(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildLegendItem(Colors.red.shade600, 'Max Temperature (°C)', Icons.thermostat),
          _buildLegendItem(Colors.grey.shade600, 'Min Temperature(°C)', Icons.ac_unit),
          Row(
            children: [
              Container(
                width: 24,
                height: 3,
                decoration: BoxDecoration(color: Colors.blue.shade600, borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.water_drop, color: Colors.blue, size: 16),
              const SizedBox(width: 4),
              const Text('Precipitation (mm)', style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label, IconData icon) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: Colors.grey.shade300),
          ),
        ),
        const SizedBox(width: 8),
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class ClimateData {
  final List<double> monthlyMaxTemp;
  final List<double> monthlyMinTemp;
  final List<double> monthlyPrecipitation;

  ClimateData({required this.monthlyMaxTemp, required this.monthlyMinTemp, required this.monthlyPrecipitation});

  factory ClimateData.fromJson(Map<String, dynamic> json) {
    final daily = json['daily'];
    final maxTemps = List<double>.from(daily['temperature_2m_max']);
    final minTemps = List<double>.from(daily['temperature_2m_min']);
    final precipitation = List<double>.from(daily['precipitation_sum']);

    final List<double> monthlyMax = [];
    final List<double> monthlyMin = [];
    final List<double> monthlyPrecip = [];

    for (int month = 1; month <= 12; month++) {
      final List<double> maxForMonth = [];
      final List<double> minForMonth = [];
      final List<double> precipForMonth = [];

      for (int i = 0; i < maxTemps.length; i++) {
        final date = DateTime.parse(daily['time'][i]);
        if (date.month == month) {
          maxForMonth.add(maxTemps[i]);
          minForMonth.add(minTemps[i]);
          precipForMonth.add(precipitation[i]);
        }
      }

      monthlyMax.add(maxForMonth.isEmpty ? 0 : maxForMonth.reduce((a, b) => a + b) / maxForMonth.length);
      monthlyMin.add(minForMonth.isEmpty ? 0 : minForMonth.reduce((a, b) => a + b) / minForMonth.length);
      monthlyPrecip.add(precipForMonth.isEmpty ? 0 : precipForMonth.reduce((a, b) => a + b));
    }

    return ClimateData(monthlyMaxTemp: monthlyMax, monthlyMinTemp: monthlyMin, monthlyPrecipitation: monthlyPrecip);
  }
}

class CombinedClimateChart extends StatelessWidget {
  final ClimateData data;

  const CombinedClimateChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    final allTemps = [...data.monthlyMaxTemp, ...data.monthlyMinTemp];
    final maxTemp = allTemps.reduce(math.max);
    final minTemp = allTemps.reduce(math.min);
    final maxPrecip = data.monthlyPrecipitation.reduce(math.max);

    // Ensure 0°C line is visible
    final tempMin = math.min(minTemp - 5, -5).floorToDouble();
    final tempMax = (maxTemp + 5).ceilToDouble();

    // Scale precipitation to fit chart
    final precipScale = maxPrecip > 0 ? math.min(tempMax / maxPrecip, tempMax / 50) : 1.0;

    final List<BarChartGroupData> barGroups = [];
    for (int i = 0; i < 12; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: data.monthlyMaxTemp[i],
              color: Colors.red.shade600,
              width: 16,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(2), topRight: Radius.circular(2)),
            ),
            BarChartRodData(
              toY: data.monthlyMinTemp[i],
              color: Colors.grey.shade600,
              width: 16,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(2), topRight: Radius.circular(2)),
            ),
          ],
          barsSpace: 4,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 65.0, top: 10, bottom: 10),
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceEvenly,
                maxY: tempMax,
                minY: tempMin,
                groupsSpace: 8,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipRoundedRadius: 8,
                    tooltipPadding: const EdgeInsets.all(8),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final month = months[group.x];
                      final temp = rod.toY;
                      final type = rodIndex == 0 ? 'Max' : 'Min';
                      final precip = data.monthlyPrecipitation[group.x];
                      return BarTooltipItem(
                        '$month\n$type: ${temp.toStringAsFixed(1)}°C\nPrecip: ${precip.toStringAsFixed(0)}mm',
                        const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 10,
                      reservedSize: 45,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: Text(
                            '${value.toInt()}',
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 35,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 && value.toInt() < 12) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Text(
                              months[value.toInt()],
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 10,
                  getDrawingHorizontalLine: (value) {
                    // Bold line at 0°C
                    if (value == 0) {
                      return const FlLine(color: Colors.black87, strokeWidth: 2);
                    }
                    return FlLine(color: Colors.grey.shade300, strokeWidth: 0.8, dashArray: [5, 3]);
                  },
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    left: BorderSide(color: Colors.grey.shade400, width: 1),
                    bottom: BorderSide(color: Colors.grey.shade400, width: 1),
                    right: BorderSide.none,
                    top: BorderSide.none,
                  ),
                ),
                barGroups: barGroups,
              ),
            ),
          ),

          // Precipitation line overlay
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(right: 65.0, left: 45, top: 10, bottom: 45),
              child: IgnorePointer(
                child: LineChart(
                  LineChartData(
                    minY: tempMin,
                    maxY: tempMax,
                    minX: -0.5,
                    maxX: 11.5,
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(12, (index) {
                          final precipValue = data.monthlyPrecipitation[index];
                          final scaledValue = math.min(precipValue * precipScale, tempMax - 1);
                          return FlSpot(index.toDouble(), scaledValue);
                        }),
                        isCurved: true,
                        curveSmoothness: 0.35,
                        color: Colors.blue.shade600,
                        barWidth: 3.5,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 4.5,
                              color: Colors.blue.shade600,
                              strokeWidth: 2,
                              strokeColor: Colors.white,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: false, // Set to true to show filled area
                          color: Colors.blue.shade50.withValues(alpha: 0.3),
                          cutOffY: 0,
                          applyCutOffY: true,
                        ),
                      ),
                    ],
                    titlesData: const FlTitlesData(show: false),
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                  ),
                ),
              ),
            ),
          ),

          // Right axis for precipitation scale
          Positioned(
            right: 0,
            top: 10,
            bottom: 45,
            child: Container(
              width: 65,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade50.withValues(alpha: 0.5), Colors.blue.shade50],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: const BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
              ),
              child: CustomPaint(
                painter: PrecipitationAxisPainter(
                  maxPrecip: maxPrecip,
                  tempMin: tempMin,
                  tempMax: tempMax,
                  precipScale: precipScale,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PrecipitationAxisPainter extends CustomPainter {
  final double maxPrecip;
  final double tempMin;
  final double tempMax;
  final double precipScale;

  PrecipitationAxisPainter({
    required this.maxPrecip,
    required this.tempMin,
    required this.tempMax,
    required this.precipScale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final textStyle = TextStyle(fontSize: 10, color: Colors.blue.shade700, fontWeight: FontWeight.w500);

    final linePaint = Paint()
      ..color = Colors.blue.shade300
      ..strokeWidth = 1;

    canvas.drawLine(const Offset(0, 0), Offset(0, size.height), linePaint);

    final zeroY = size.height * (tempMax / (tempMax - tempMin));

    final scaledMax = maxPrecip;
    final interval = _calculateInterval(scaledMax);

    var currentValue = 0.0;
    while (currentValue <= scaledMax) {
      final scaledPrecipValue = currentValue * precipScale;
      final yRatio = 1 - ((scaledPrecipValue + tempMax) / (tempMax - tempMin));
      final y = size.height * yRatio;

      if (y >= 0 && y <= zeroY) {
        final textSpan = TextSpan(text: currentValue.toInt().toString(), style: textStyle);

        final textPainter = TextPainter(text: textSpan, textDirection: ui.TextDirection.ltr);

        textPainter.layout();

        textPainter.paint(canvas, Offset(8, y - textPainter.height / 2));

        canvas.drawLine(Offset(0, y), Offset(4, y), linePaint);
      }

      currentValue += interval;
      if (currentValue > scaledMax && currentValue - interval < scaledMax) {
        currentValue = scaledMax;
      } else if (currentValue > scaledMax) {
        break;
      }
    }
  }

  double _calculateInterval(double maxValue) {
    if (maxValue <= 50) return 10;
    if (maxValue <= 100) return 20;
    if (maxValue <= 200) return 25;
    if (maxValue <= 500) return 50;
    return 100;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
