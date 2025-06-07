import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const MaterialApp(
    home: GenderChartScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class GenderChartScreen extends StatelessWidget {
  const GenderChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<PieChartSectionData> data = [
      PieChartSectionData(
        color: Colors.blue,
        value: 60,
        title: 'Male 60%',
        radius: 100,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: Colors.pink,
        value: 35,
        title: 'Female 35%',
        radius: 100,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: Colors.green,
        value: 5,
        title: 'Other 5%',
        radius: 100,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gender Wise Chart'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: data,
                  sectionsSpace: 2,
                  centerSpaceRadius: 0,
                  pieTouchData: PieTouchData(enabled: true),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Gender distribution of faculty members',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
