import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';



class PieCharts extends StatefulWidget {
  const PieCharts({super.key});

  @override
  State<PieCharts> createState() => _PieChartsState();
}

class _PieChartsState extends State<PieCharts> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: PieChart(
          swapAnimationDuration: const Duration(milliseconds: 750), // Optional
          swapAnimationCurve: Curves.linear,
          PieChartData(
            // read about it in the PieChartData
              sections: [
                PieChartSectionData(
                  radius: 50,
                  value: 20,
                  color: Colors.cyanAccent,
                ),
                PieChartSectionData(
                  value: 200,
                  color: Colors.red,
                ),
                PieChartSectionData(
                  value: 20,
                  color: Colors.grey,
                ),
              ]
          ),
        ),
      ),
    );
  }
}
