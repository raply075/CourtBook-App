import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/admin_provider.dart';

class BookingChart extends StatelessWidget {
  const BookingChart({super.key});

  @override
  Widget build(BuildContext context) {
    final admin = context.watch<AdminProvider>();

    final weekly = admin.weeklyBooking;

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: SizedBox(
          height: 250,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              borderData: FlBorderData(show: false),
              gridData: const FlGridData(show: false),

              titlesData: FlTitlesData(
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),

                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= weekly.length) {
                        return const SizedBox();
                      }

                      return Text(
                        weekly[value.toInt()].day,
                        style: const TextStyle(fontSize: 12),
                      );
                    },
                  ),
                ),
              ),

              barGroups: List.generate(
                weekly.length,
                (index) => BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: weekly[index].total.toDouble(),
                      width: 16,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
