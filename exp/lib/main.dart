// main.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

void main() {
  runApp(const ClimateApp());
}

class ClimateApp extends StatelessWidget {
  const ClimateApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Climate Diagrams',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF1a237e), // Dark blue background
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1a237e), // Dark blue header
          foregroundColor: Colors.white, // White text
          iconTheme: IconThemeData(color: Colors.white),
          actionsIconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      home: const ClimateHomePage(),
    );
  }
}

class ClimateHomePage extends StatefulWidget {
  const ClimateHomePage({Key? key}) : super(key: key);

  @override
  State<ClimateHomePage> createState() => _ClimateHomePageState();
}

class _ClimateHomePageState extends State<ClimateHomePage> {
  bool isLoading = false;
  ClimateData? climateData;
  String selectedLocation = 'Brocken';

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
            'timezone=Europe/Berlin'
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
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
                decoration: const InputDecoration(
                  labelText: 'Location Name',
                  hintText: 'e.g., Cologne',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _latController,
                decoration: const InputDecoration(
                  labelText: 'Latitude',
                  hintText: 'e.g., 50.9375',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _lonController,
                decoration: const InputDecoration(
                  labelText: 'Longitude',
                  hintText: 'e.g., 6.9603',
                ),
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter valid data')),
                  );
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot remove the last location')),
      );
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
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Climate Diagram for $selectedLocation'),
        actions: [
          DropdownButton<String>(
            value: selectedLocation,
            dropdownColor: const Color(0xFF1a237e), // Dark blue dropdown
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
          IconButton(
            icon: const Icon(Icons.add_location),
            onPressed: _showAddLocationDialog,
            tooltip: 'Add Location',
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: _showRemoveLocationDialog,
            tooltip: 'Remove Location',
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : climateData == null
          ? const Center(child: Text('No data available', style: TextStyle(color: Colors.white)))
          : Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 4,
              color: Colors.white, // Keep card background white
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 500,
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: CombinedClimateChart(
                        data: climateData!,
                      ),
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
          _buildLegendItem(Colors.red.shade600, 'Maximum Temperature', Icons.thermostat),
          _buildLegendItem(Colors.grey.shade600, 'Minimum Temperature', Icons.ac_unit),
          Row(
            children: [
              Container(
                width: 24,
                height: 3,
                decoration: BoxDecoration(
                  color: Colors.blue.shade600,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.water_drop, color: Colors.blue, size: 16),
              const SizedBox(width: 4),
              const Text('Precipitation', style: TextStyle(fontWeight: FontWeight.w500)),
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

  ClimateData({
    required this.monthlyMaxTemp,
    required this.monthlyMinTemp,
    required this.monthlyPrecipitation,
  });

  factory ClimateData.fromJson(Map<String, dynamic> json) {
    final daily = json['daily'];
    final maxTemps = List<double>.from(daily['temperature_2m_max']);
    final minTemps = List<double>.from(daily['temperature_2m_min']);
    final precipitation = List<double>.from(daily['precipitation_sum']);

    List<double> monthlyMax = [];
    List<double> monthlyMin = [];
    List<double> monthlyPrecip = [];

    for (int month = 1; month <= 12; month++) {
      List<double> maxForMonth = [];
      List<double> minForMonth = [];
      List<double> precipForMonth = [];

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

    return ClimateData(
      monthlyMaxTemp: monthlyMax,
      monthlyMinTemp: monthlyMin,
      monthlyPrecipitation: monthlyPrecip,
    );
  }
}

class CombinedClimateChart extends StatelessWidget {
  final ClimateData data;

  const CombinedClimateChart({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    // Calculate min/max values for proper scaling
    final allTemps = [...data.monthlyMaxTemp, ...data.monthlyMinTemp];
    final maxTemp = allTemps.reduce(math.max);
    final minTemp = allTemps.reduce(math.min);
    final maxPrecip = data.monthlyPrecipitation.reduce(math.max);

    // Calculate temperature range for axis - ensure it includes 0
    final tempMin = math.min(minTemp - 5, -15).floorToDouble();
    final tempMax = math.max(maxTemp + 5, 35).ceilToDouble();

    // Dynamic precipitation scaling
    final precipToTempRatio = maxPrecip > 0 ? maxPrecip / tempMax : 1.0;

    // Create side-by-side bar groups
    final List<BarChartGroupData> barGroups = [];
    for (int i = 0; i < 12; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            // Red bar for max temperature
            BarChartRodData(
              toY: data.monthlyMaxTemp[i],
              color: Colors.red.shade600,
              width: 16,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(2),
                topRight: Radius.circular(2),
              ),
            ),
            // Gray bar for min temperature
            BarChartRodData(
              toY: data.monthlyMinTemp[i],
              color: Colors.grey.shade600,
              width: 16,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(2),
                topRight: Radius.circular(2),
              ),
            ),
          ],
          barsSpace: 4, // Space between max/min bars
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          // Main chart with temperature bars
          Padding(
            padding: const EdgeInsets.only(right: 60.0, top: 10, bottom: 10),
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
                      return BarTooltipItem(
                        '$month\n$type: ${temp.toStringAsFixed(1)}°C',
                        const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 5,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}°',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
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
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                              ),
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
                  horizontalInterval: 5,
                  getDrawingHorizontalLine: (value) {
                    if (value == 0) {
                      return FlLine(
                        color: Colors.black87,
                        strokeWidth: 1.5,
                      );
                    }
                    return FlLine(
                      color: Colors.grey.shade300,
                      strokeWidth: 0.8,
                      dashArray: [3, 3],
                    );
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
          // Enhanced precipitation line overlay
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(right: 60.0, top: 10, bottom: 10),
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
                          final scaledValue = precipValue / precipToTempRatio;
                          return FlSpot(index.toDouble(), scaledValue.clamp(tempMin, tempMax));
                        }),
                        isCurved: true,
                        curveSmoothness: 0.3,
                        color: Colors.blue.shade600,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: Colors.blue.shade600,
                              strokeWidth: 2,
                              strokeColor: Colors.white,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: false,
                          color: Colors.blue.shade100.withOpacity(0.3),
                        ),
                      ),
                    ],
                    titlesData: const FlTitlesData(show: false),
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    lineTouchData: LineTouchData(
                      enabled: true,
                      touchTooltipData: LineTouchTooltipData(
                        tooltipRoundedRadius: 8,
                        tooltipPadding: const EdgeInsets.all(8),
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            final index = spot.x.toInt();
                            if (index >= 0 && index < 12) {
                              return LineTooltipItem(
                                '${months[index]}\nPrecipitation: ${data.monthlyPrecipitation[index].toStringAsFixed(0)} mm',
                                const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
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
          ),
          // Enhanced right axis for precipitation
          Positioned(
            right: 0,
            top: 10,
            bottom: 45,
            child: Container(
              width: 60,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                border: Border(
                  left: BorderSide(color: Colors.blue.shade200, width: 1),
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        'Precipitation (mm)',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final List<Widget> labels = [];
                          final height = constraints.maxHeight;

                          for (double temp = tempMax; temp >= 0; temp -= 10) {
                            final precipValue = temp * precipToTempRatio;
                            final position = ((tempMax - temp) / (tempMax - tempMin)) * height;

                            labels.add(
                              Positioned(
                                top: position - 8,
                                right: 4,
                                child: Text(
                                  '${precipValue.toInt()}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                              ),
                            );
                          }

                          return Stack(children: labels);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}