import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DailyAttendanceScreen extends StatelessWidget {
  const DailyAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Attendance'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 100,
            barTouchData: BarTouchData(enabled: true),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
                    return Text(days[value.toInt()]);
                  },
                  reservedSize: 32,
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            barGroups: [
              BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 90, color: Colors.blue)]),
              BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 75, color: Colors.blue)]),
              BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 80, color: Colors.blue)]),
              BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 70, color: Colors.blue)]),
              BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 95, color: Colors.blue)]),
            ],
          ),
        ),
      ),
    );
  }
}
