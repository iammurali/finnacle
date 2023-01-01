import 'package:finance_journal/data/sqlhelper.dart';
import 'package:finance_journal/widgets/barchart.dart';
import 'package:finance_journal/widgets/donutchart.dart';
import 'package:finance_journal/widgets/piechart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  List<Map<String, dynamic>> _categoryInsights = [];
  List<Map<String, dynamic>> _expenseIncomeInsights = [];

  double _income = 0;
  double _expense = 0;

  List<String> list = <String>['Regular', 'Two', 'Three', 'Four'];

  String dropdownValue = 'Regular';

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshSpendings();
  }

  void _refreshSpendings() async {
    List<Map<String, dynamic>> categoryInsights =
        await SQLHelper.getCountBasedOn('trackingType');
    print(categoryInsights);

    List<Map<String, dynamic>> expenseIncomeInsights =
        await SQLHelper.getCountBasedOn('spending_type');

    if (expenseIncomeInsights.isNotEmpty) {
      final incomeTmp = expenseIncomeInsights.firstWhere(
          (element) => element['spending_type'] == 1,
          orElse: () => Map());

      Map? expenseTmp = expenseIncomeInsights.firstWhere(
          (Map? element) => element!['spending_type'] == 0,
          orElse: () => Map());
      setState(() {
        _isLoading = false;
        _categoryInsights = categoryInsights;
        _expenseIncomeInsights = expenseIncomeInsights;
        _income = incomeTmp['num'];
        _expense = expenseTmp['num'];
      });
    } else {
      setState(() {
        _isLoading = false;
        _categoryInsights = categoryInsights;
        _expenseIncomeInsights = expenseIncomeInsights;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        centerTitle: false,
      ),
      body: _isLoading == false
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Card(
                          color: Colors.green,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(children: [
                              const Icon(
                                Icons.arrow_circle_down_outlined,
                                color: Colors.white,
                              ),
                              const Text(
                                'Income',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              _income != null
                                  ? Text(
                                      _income.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      '0',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    )
                            ]),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          color: Colors.red,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(children: [
                              const Icon(
                                Icons.arrow_circle_up_outlined,
                                color: Colors.white,
                              ),
                              const Text(
                                'Expense',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              _expense != null
                                  ? Text(
                                      _expense.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    )
                                  : const SizedBox()
                            ]),
                          ),
                        ),
                      )
                    ],
                  ),
                  DonutChart(
                    categoryInsights: _categoryInsights,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _categoryInsights.length,
                    itemBuilder: (context, i) {
                      return ListTile(
                        title: Text(_categoryInsights[i]['trackingType']),
                        trailing: Text(_categoryInsights[i]['num'].toString()),
                      );
                    },
                  ),
                ],
              ),
            )
          : const Center(child: Text('Analytics')),
    );
  }
}
