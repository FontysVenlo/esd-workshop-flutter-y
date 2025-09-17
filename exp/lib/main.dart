import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const ClimateApp());
}

class ClimateApp extends StatelessWidget {
  const ClimateApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Climate Diagrams',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ClimateHomePage(),
    );
  }
}

class ClimateHomePage extends StatefulWidget {
  const ClimateHomePage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<ClimateHomePage> createState() => _ClimateHomePageState();
}

class _ClimateHomePageState extends State<ClimateHomePage> {
  bool isLoading = false;
  ClimateData? climateData;
  String selectedLocation = 'Brocken';
  
  final Map<String, Map<String, double>> locations = {
    'Brocken': {'lat': 51.7992, 'lon': 10.6183},
    'Berlin': {'lat': 52.5200, 'lon': 13.4050},
    'Munich': {'lat': 48.1351, 'lon': 11.5820},
    'Hamburg': {'lat': 53.5511, 'lon': 9.9937},
    'Frankfurt': {'lat': 50.1109, 'lon': 8.6821},
  };

  @override
  void initState() {
    super.initState();
    fetchClimateData();
  }

  Future<void> fetchClimateData() async {
    setState(() {
      isLoading = true;
    });

    final location = locations[selectedLocation]!;
    
    // Using Open-Meteo API for historical weather data
    // We'll fetch data for the last complete year to calculate monthly averages
    final now = DateTime.now();
    final startDate = DateTime(now.year - 1, 1, 1);
    final endDate = DateTime(now.year - 1, 12, 31);
    
    final url = Uri.parse(
      'https://archive-api.open-meteo.com/v1/era5?'
      'latitude=${location['lat']}&'
      'longitude=${location['lon']}&'
      'start_date=${DateFormat('yyyy-MM-dd').format(startDate)}&'
      'end_date=${DateFormat('yyyy-MM-dd').format(endDate)}&'
      'daily=temperature_2m_max,temperature_2m_min,precipitation_sum,windspeed_10m_max&'
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    }
  }

/* Build */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Klimadiagramme - $selectedLocation'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          DropdownButton<String>(
            value: selectedLocation,
            items: locations.keys.map((String location) {
              return DropdownMenuItem<String>(
                value: location,
                child: Text(location),
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
          const SizedBox(width: 20),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : climateData == null
              ? const Center(child: Text('No data available'))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: SizedBox(
                                    height: 300,
                                    child: TemperatureChart(
                                      data: climateData!,
                                      title: 'Höchst- und Tiefsttemperatur',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: SizedBox(
                                    height: 300,
                                    child: PrecipitationChart(
                                      data: climateData!,
                                      title: 'Niederschlagsmenge',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: SizedBox(
                                    height: 300,
                                    child: WindChart(
                                      data: climateData!,
                                      title: 'Mittlere Windstärke',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: SizedBox(
                                    height: 300,
                                    child: CombinedClimateChart(
                                      data: climateData!,
                                      title: 'Klima-Übersicht',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}

class ClimateData {
  final List<double> monthlyMaxTemp;
  final List<double> monthlyMinTemp;
  final List<double> monthlyPrecipitation;
  final List<double> monthlyWindSpeed;

  ClimateData({
    required this.monthlyMaxTemp,
    required this.monthlyMinTemp,
    required this.monthlyPrecipitation,
    required this.monthlyWindSpeed,
  });

  factory ClimateData.fromJson(Map<String, dynamic> json) {
    final daily = json['daily'];
    final maxTemps = List<double>.from(daily['temperature_2m_max']);
    final minTemps = List<double>.from(daily['temperature_2m_min']);
    final precipitation = List<double>.from(daily['precipitation_sum']);
    final windSpeed = List<double>.from(daily['windspeed_10m_max']);

    // Calculate monthly averages
    List<double> monthlyMax = [];
    List<double> monthlyMin = [];
    List<double> monthlyPrecip = [];
    List<double> monthlyWind = [];

    for (int month = 1; month <= 12; month++) {
      List<double> maxForMonth = [];
      List<double> minForMonth = [];
      List<double> precipForMonth = [];
      List<double> windForMonth = [];

      for (int i = 0; i < maxTemps.length; i++) {
        final date = DateTime.parse(daily['time'][i]);
        if (date.month == month) {
          maxForMonth.add(maxTemps[i]);
          minForMonth.add(minTemps[i]);
          precipForMonth.add(precipitation[i]);
          windForMonth.add(windSpeed[i]);
        }
      }

      monthlyMax.add(maxForMonth.isEmpty ? 0 : maxForMonth.reduce((a, b) => a + b) / maxForMonth.length);
      monthlyMin.add(minForMonth.isEmpty ? 0 : minForMonth.reduce((a, b) => a + b) / minForMonth.length);
      monthlyPrecip.add(precipForMonth.isEmpty ? 0 : precipForMonth.reduce((a, b) => a + b));
      monthlyWind.add(windForMonth.isEmpty ? 0 : windForMonth.reduce((a, b) => a + b) / windForMonth.length);
    }

    return ClimateData(
      monthlyMaxTemp: monthlyMax,
      monthlyMinTemp: monthlyMin,
      monthlyPrecipitation: monthlyPrecip,
      monthlyWindSpeed: monthlyWind,
    );
  }
}

class TemperatureChart extends StatelessWidget {
  final ClimateData data;
  final String title;

  const TemperatureChart({
    Key? key,
    required this.data,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final months = ['Jan', 'Feb', 'Mär', 'Apr', 'Mai', 'Jun', 
                   'Jul', 'Aug', 'Sep', 'Okt', 'Nov', 'Dez'];

    return Column(
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 16),
        Expanded(
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(
                leftTitlesData: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                  ),
                ),
                bottomTitlesData: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= 0 && value.toInt() < months.length) {
                        return Text(months[value.toInt()], style: const TextStyle(fontSize: 10));
                      }
                      return const Text('');
                    },
                    reservedSize: 30,
                  ),
                ),
                rightTitlesData: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitlesData: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: true),
              lineBarsData: [
                LineChartBarData(
                  spots: data.monthlyMaxTemp.asMap().entries.map((e) {
                    return FlSpot(e.key.toDouble(), e.value);
                  }).toList(),
                  isCurved: true,
                  color: Colors.red,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(show: false),
                ),
                LineChartBarData(
                  spots: data.monthlyMinTemp.asMap().entries.map((e) {
                    return FlSpot(e.key.toDouble(), e.value);
                  }).toList(),
                  isCurved: true,
                  color: Colors.blue,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(show: false),
                ),
              ],
              minX: 0,
              maxX: 11,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 20, height: 3, color: Colors.red),
            const SizedBox(width: 5),
            const Text('Höchsttemperatur'),
            const SizedBox(width: 20),
            Container(width: 20, height: 3, color: Colors.blue),
            const SizedBox(width: 5),
            const Text('Tiefsttemperatur'),
          ],
        ),
      ],
    );
  }
}

class PrecipitationChart extends StatelessWidget {
  final ClimateData data;
  final String title;

  const PrecipitationChart({
    Key? key,
    required this.data,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final months = ['Jan', 'Feb', 'Mär', 'Apr', 'Mai', 'Jun', 
                   'Jul', 'Aug', 'Sep', 'Okt', 'Nov', 'Dez'];

    return Column(
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 16),
        Expanded(
          child: BarChart(
            BarChartData(
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(
                leftTitlesData: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                  ),
                ),
                bottomTitlesData: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= 0 && value.toInt() < months.length) {
                        return Text(months[value.toInt()], style: const TextStyle(fontSize: 10));
                      }
                      return const Text('');
                    },
                    reservedSize: 30,
                  ),
                ),
                rightTitlesData: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitlesData: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: true),
              barGroups: data.monthlyPrecipitation.asMap().entries.map((e) {
                return BarChartGroupData(
                  x: e.key,
                  barRods: [
                    BarChartRodData(
                      toY: e.value,
                      color: Colors.blue.shade300,
                      width: 20,
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class WindChart extends StatelessWidget {
  final ClimateData data;
  final String title;

  const WindChart({
    Key? key,
    required this.data,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final months = ['Jan', 'Feb', 'Mär', 'Apr', 'Mai', 'Jun', 
                   'Jul', 'Aug', 'Sep', 'Okt', 'Nov', 'Dez'];

    return Column(
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 16),
        Expanded(
          child: BarChart(
            BarChartData(
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(
                leftTitlesData: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                  ),
                ),
                bottomTitlesData: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= 0 && value.toInt() < months.length) {
                        return Text(months[value.toInt()], style: const TextStyle(fontSize: 10));
                      }
                      return const Text('');
                    },
                    reservedSize: 30,
                  ),
                ),
                rightTitlesData: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitlesData: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: true),
              barGroups: data.monthlyWindSpeed.asMap().entries.map((e) {
                return BarChartGroupData(
                  x: e.key,
                  barRods: [
                    BarChartRodData(
                      toY: e.value,
                      color: Colors.teal.shade400,
                      width: 20,
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class CombinedClimateChart extends StatelessWidget {
  final ClimateData data;
  final String title;

  const CombinedClimateChart({
    Key? key,
    required this.data,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final months = ['Jan', 'Feb', 'Mär', 'Apr', 'Mai', 'Jun', 
                   'Jul', 'Aug', 'Sep', 'Okt', 'Nov', 'Dez'];

    return Column(
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 16),
        Expanded(
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(
                leftTitlesData: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                  ),
                ),
                rightTitlesData: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                  ),
                ),
                bottomTitlesData: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= 0 && value.toInt() < months.length) {
                        return Text(months[value.toInt()], style: const TextStyle(fontSize: 10));
                      }
                      return const Text('');
                    },
                    reservedSize: 30,
                  ),
                ),
                topTitlesData: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: true),
              lineBarsData: [
                LineChartBarData(
                  spots: data.monthlyMaxTemp.asMap().entries.map((e) {
                    return FlSpot(e.key.toDouble(), e.value);
                  }).toList(),
                  isCurved: true,
                  color: Colors.red,
                  barWidth: 2,
                  isStrokeCapRound: true,
                  dotData: FlDotData(show: false),
                ),
                LineChartBarData(
                  spots: data.monthlyPrecipitation.asMap().entries.map((e) {
                    return FlSpot(e.key.toDouble(), e.value / 5); // Scale precipitation
                  }).toList(),
                  isCurved: false,
                  color: Colors.blue.shade300,
                  barWidth: 0,
                  isStrokeCapRound: true,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.blue.withOpacity(0.3),
                  ),
                ),
              ],
              minX: 0,
              maxX: 11,
            ),
          ),
        ),
      ],
    );
  }
}
