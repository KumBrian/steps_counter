import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:steps_counter/cubits/step_counter_cubit.dart';
import 'package:steps_counter/utils/utils.dart';

class GraphWidget extends StatefulWidget {
  const GraphWidget({super.key});

  @override
  State<GraphWidget> createState() => _GraphWidgetState();
}

class _GraphWidgetState extends State<GraphWidget> {
  List<Color> gradientColors = [
    AppColors.purpleColor,
    AppColors.blueColor,
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 24,
            ),
            child: BlocBuilder<StepCounterCubit, Map<String, dynamic>>(
              builder: (context, state) {
                final history = state['history'] as Map<String, int>;
                return LineChart(
                  mainData(history),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  List<String> dates = List.generate(7, (index) {
    DateTime date = DateTime.now().subtract(Duration(days: index));
    return DateFormat.EEEE().format(date);
  });

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = Text(dates[6].substring(0, 3).toUpperCase(), style: style);
        break;
      case 2:
        text = Text(dates[5].substring(0, 3).toUpperCase(), style: style);
        break;
      case 3:
        text = Text(dates[4].substring(0, 3).toUpperCase(), style: style);
        break;
      case 4:
        text = Text(dates[3].substring(0, 3).toUpperCase(), style: style);
        break;
      case 5:
        text = Text(dates[2].substring(0, 3).toUpperCase(), style: style);
        break;
      case 6:
        text = Text(dates[1].substring(0, 3).toUpperCase(), style: style);
        break;
      case 7:
        text = Text(dates[0].substring(0, 3).toUpperCase(), style: style);
        break;
      default:
        text = Text('', style: style);
        break;
    }

    return SideTitleWidget(
      meta: meta,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1000:
        text = '1K';
        break;
      case 3000:
        text = '3K';
        break;
      case 5000:
        text = '5K';
        break;
      default:
        return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: Text(text, style: style, textAlign: TextAlign.right),
    );
  }

  LineChartData mainData(Map<String, int> history) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: AppColors.secondaryColor,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: AppColors.secondaryColor,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 25,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 20,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: AppColors.backgroundColor),
      ),
      minX: 1,
      maxX: 7,
      minY: 0,
      maxY: 6000,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(1, (history[dates[6]] ?? 0).toDouble()),
            FlSpot(2, (history[dates[5]] ?? 0).toDouble()),
            FlSpot(3, (history[dates[4]] ?? 0).toDouble()),
            FlSpot(4, (history[dates[3]] ?? 0).toDouble()),
            FlSpot(5, (history[dates[2]] ?? 0).toDouble()),
            FlSpot(6, (history[dates[1]] ?? 0).toDouble()),
            FlSpot(7, (history[dates[0]] ?? 0).toDouble()),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withValues(alpha: 0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
