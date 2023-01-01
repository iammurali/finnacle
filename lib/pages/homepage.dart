// ignore_for_file: prefer_const_constructors

import 'package:finance_journal/data/sqlhelper.dart';
import 'package:finance_journal/pages/addspendingform.dart';
import 'package:finance_journal/pages/analyticspage.dart';
import 'package:finance_journal/shared/colors.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _spendings = [];

  List<String> list = <String>['Regular', 'Two', 'Three', 'Four'];

  String dropdownValue = 'Regular';

  bool _isLoading = true;

  TextEditingController spentonController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  void _refreshSpendings() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _spendings = data;
      _isLoading = false;
    });
  }

  Future<bool?> showAlertDialog(BuildContext context, id, index) {
    // set up the buttons
    Widget remindButton = TextButton(
      child: Text("no"),
      onPressed: () {
        Navigator.of(context).pop(false);
      },
    );
    Widget cancelButton = TextButton(
      child: Text("yes"),
      onPressed: () {
        setState(() {
          _spendings = List.from(_spendings)..removeAt(index);
        });
        _deleteItem(id);
        Navigator.of(context).pop(true);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Notice"),
      content: Text("Confirm delete?"),
      actions: [
        remindButton,
        cancelButton,
      ],
    ); // show the dialog
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _deleteItem(id) async {
    // ignore: unused_local_variable
    final deleted = await SQLHelper.deleteItem(id);
  }

  _addItem(int spendingType, spentOn, amount, trackingType) async {
    // ignore: unused_local_variable

    if (amount != "" && amount != null) {
      amount = double.parse(amount);
    } else {
      return false;
    }

    // ignore: unused_local_variable
    final insertSpending = await SQLHelper.createItem(
        spentOn, null, spendingType, amount, trackingType);
    _refreshSpendings();
  }

  void _showForm(int type) async {
    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => AddSpendingForm(
            context: context, spendingType: type, addItem: _addItem));
  }

  @override
  void initState() {
    super.initState();
    _refreshSpendings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: (() {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AnalyticsPage()));
              }),
              icon: Icon(Icons.punch_clock_outlined)),
          IconButton(
              onPressed: (() {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AnalyticsPage()));
              }),
              icon: Icon(Icons.analytics_outlined)),
          IconButton(onPressed: (() {}), icon: Icon(Icons.settings_outlined))
        ],
      ),
      body: _isLoading
          ? CircularProgressIndicator()
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _spendings.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.delete_forever_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  key: Key(_spendings[index]['id'].toString()),
                  confirmDismiss: (direction) =>
                      showAlertDialog(context, _spendings[index]['id'], index),
                  child: Material(
                    child: ListTile(
                      visualDensity: VisualDensity.comfortable,
                      leading: SizedBox(
                        height: double.infinity,
                        child: _spendings[index]['spending_type'] == 0
                            ? Icon(
                                size: 30,
                                Icons.arrow_circle_down_outlined,
                                color: Color.fromARGB(255, 162, 65, 65),
                              )
                            : Icon(
                                size: 30,
                                Icons.arrow_circle_up,
                                color: Color.fromARGB(255, 111, 207, 114),
                              ),
                      ),
                      trailing: SizedBox(
                        // color: Colors.yellow,
                        height: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 2.0,
                            ),
                            Text(
                              '₹${_spendings[index]['amount']}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: _spendings[index]['spending_type'] == 0
                                      ? Color.fromARGB(255, 162, 65, 65)
                                      : Color.fromARGB(255, 111, 207, 114)),
                            ),
                            _spendings[index]['trackingType'] != null
                                ? Text(
                                    _spendings[index]['trackingType']
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey[600]),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                      title: Text(
                        _spendings[index]['spent_on'],
                        style: TextStyle(fontSize: 13),
                      ),
                      subtitle: Text(
                          DateFormat.MMMd().format(
                              DateTime.parse(_spendings[index]['createdAt'])),
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[600])),
                      // tileColor: Colors.amber[colorCodes[index]],
                    ),
                  ),
                );
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Row(
          children: [
            FloatingActionButton(
              heroTag: 'income',
              onPressed: () {
                _showForm(1);
              },
              foregroundColor: Colors.white,
              backgroundColor: Color.fromARGB(255, 49, 136, 52),
              tooltip: 'Income',
              child: const Icon(Icons.add),
            ),
            const Spacer(),
            FloatingActionButton(
              heroTag: 'expense',
              onPressed: () {
                _showForm(0);
              },
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
              tooltip: 'Expense',
              child: const Icon(Icons.remove),
            ),
          ],
        ),
      ),
    );
  }
}
