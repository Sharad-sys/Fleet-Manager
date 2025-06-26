import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TransportStatsChart extends StatelessWidget {
  final int completed;
  final int ongoing;
  final int rejected;

  const TransportStatsChart({
    super.key,
    required this.completed,
    required this.ongoing,
    required this.rejected,
  });

  @override
  Widget build(BuildContext context) {
    final total = completed + ongoing + rejected;

    if (total == 0) {
      return Center(
        child: Text(
          "No data to display",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 1.3,
      child: PieChart(
        PieChartData(
          centerSpaceRadius: 50,
          sectionsSpace: 4,
          sections: [
            PieChartSectionData(
              value: completed.toDouble(),
              color: Colors.green,
              title: '$completed\nCompleted',
              radius: 60,
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            PieChartSectionData(
              value: ongoing.toDouble(),
              color: Colors.blue,
              title: '$ongoing\nOngoing',
              radius: 60,
              titleStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            PieChartSectionData(
              value: rejected.toDouble(),
              color: Colors.red,
              title: '$rejected\nRejected',
              radius: 60,
              titleStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
