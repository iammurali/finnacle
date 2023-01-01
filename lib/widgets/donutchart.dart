import 'package:finance_journal/widgets/indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DonutChart extends StatefulWidget {
  DonutChart({super.key, required this.categoryInsights});

  final List<Map<String, dynamic>> categoryInsights;

  @override
  State<StatefulWidget> createState() => DonutChartState();
}

class DonutChartState extends State<DonutChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
        color: const Color(0xff2c4260),
        child: Row(
          children: <Widget>[
            const SizedBox(
              height: 18,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    sections: showingSections(widget.categoryInsights),
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Indicator(
                  color: Color(0xff0293ee),
                  text: 'Regular',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Color(0xfff8b250),
                  text: 'Debt',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Color(0xff845bef),
                  text: 'Loan',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Color(0xff13d38e),
                  text: 'Investment',
                  isSquare: true,
                ),
                SizedBox(
                  height: 18,
                ),
              ],
            ),
            const SizedBox(
              width: 28,
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(
      List<Map<String, dynamic>> categoryInsights) {
    return List.generate(categoryInsights.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 14.0;
      final radius = isTouched ? 80.0 : 70.0;
      switch (categoryInsights[i]['trackingType']) {
        case null:
        case 'Regular':
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: categoryInsights[i]['num'],
            // title: '3',
            title: 'Rs.' + categoryInsights[i]['num'].toString(),
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: const Color(0xffffffff),
            ),
          );
        case 'Debt':
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: categoryInsights[i]['num'],
            // title: '2',
            title: 'Rs.' + categoryInsights[i]['num'].toString(),
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: const Color(0xffffffff),
            ),
          );
        case 'Loan':
          return PieChartSectionData(
            color: const Color(0xff845bef),
            value: categoryInsights[i]['num'],
            // title: '2',
            title: 'Rs.' + categoryInsights[i]['num'].toString(),
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: const Color(0xffffffff),
            ),
          );
        case 'Investment':
          return PieChartSectionData(
            color: const Color(0xff13d38e),
            value: categoryInsights[i]['num'],
            // title: '1',
            title: 'Rs.' + categoryInsights[i]['num'].toString(),
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: const Color(0xffffffff),
            ),
          );

        default:
          throw Error();
      }
    });
  }
}
