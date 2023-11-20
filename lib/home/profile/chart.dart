import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Chart extends StatefulWidget {
  const Chart({super.key});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Expanded(
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: getTitles,
                          )
                        ),
                        // leftTitles: AxisTitles(
                        //   sideTitles: SideTitles(showTitles: true),
                        // ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        )

                      ),
                      maxY: 10,
                      backgroundColor: Colors.amberAccent,
                      barGroups: [
                        BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 3, width: 40),]),
                        BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 5, width: 40)]),
                        BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 6, width: 40)]),
                        BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 1, width: 40)]),
                        BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 2, width: 40)]),
                        BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 7, width: 40)]),
                        BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 3, width: 40)]),
                      ]
                    ),
                  ))
            ],
          )
        ));
  }
  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: Colors.deepOrange,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Mn';
        break;
      case 1:
        text = 'Te';
        break;
      case 2:
        text = 'Wd';
        break;
      case 3:
        text = 'Tu';
        break;
      case 4:
        text = 'Fr';
        break;
      case 5:
        text = 'St';
        break;
      case 6:
        text = 'Sn';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }
}
