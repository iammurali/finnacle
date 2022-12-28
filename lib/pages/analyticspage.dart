import 'package:finance_journal/data/sqlhelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  List<Map<String, dynamic>> _spendings = [];

  List<String> list = <String>['Regular', 'Two', 'Three', 'Four'];

  String dropdownValue = 'Regular';

  bool _isLoading = true;

  void _refreshSpendings() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _spendings = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        centerTitle: false,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : const Center(child: Text('Analytics')),
    );
  }
}
