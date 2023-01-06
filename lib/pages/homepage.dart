// ignore_for_file: prefer_const_constructors

import 'package:finance_journal/data/sqlhelper.dart';
import 'package:finance_journal/pages/addspendingform.dart';
import 'package:finance_journal/pages/analyticspage.dart';
import 'package:finance_journal/pages/filterspendings.dart';
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

  String? gender;

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

  void _showFilter(int type) async {
    final spendings = await SQLHelper.getListByQuery();
    print(spendings);
    setState(() {
      _spendings = spendings;
      _isLoading = false;
    });

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
              // color: Colors.amber[300],
              padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
                // this will prevent the soft keyboard from covering the text fields
                bottom: MediaQuery.of(context).viewInsets.bottom + 120,
              ),
              child: FilterSpendings(),
            ));
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
        // elevation: 0,
        title: Text(widget.title),
        actions: [
          // IconButton(
          //     onPressed: (() {
          //       Navigator.of(context).push(
          //           MaterialPageRoute(builder: (context) => AnalyticsPage()));
          //     }),
          //     icon: Icon(Icons.filter_alt_outlined)),
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
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: double.infinity,
                    height: 40,
                    // color: Colors.yellow,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Text('Filter Section'),
                        Expanded(
                          child: Container(),
                        ),
                        IconButton(
                            splashRadius: 20,
                            onPressed: (() {
                              _showFilter(0);
                            }),
                            icon: Icon(Icons.filter_alt_outlined)),
                        SizedBox(
                          width: 15,
                        )
                      ],
                    ),
                  ),
                  Divider(),
                  ListView.separated(
                    separatorBuilder: (context, index) => Divider(
                      thickness: 1,
                    ),
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    // padding: const EdgeInsets.all(2),
                    itemCount: _spendings.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: const [
                              Icon(
                                Icons.delete_forever_outlined,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        key: Key(_spendings[index]['id'].toString()),
                        confirmDismiss: (direction) => showAlertDialog(
                            context, _spendings[index]['id'], index),
                        child: ListTile(
                          visualDensity: VisualDensity.compact,
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
                                // SizedBox(
                                //   height: 2.0,
                                // ),
                                Text(
                                  '₹${_spendings[index]['amount']}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: _spendings[index]
                                                  ['spending_type'] ==
                                              0
                                          ? Color.fromARGB(255, 162, 65, 65)
                                          : Color.fromARGB(255, 111, 207, 114)),
                                ),
                                _spendings[index]['trackingType'] != null
                                    ? Text(
                                        _spendings[index]['trackingType']
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600]),
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
                              DateFormat.MMMd().format(DateTime.parse(
                                  _spendings[index]['createdAt'])),
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[600])),
                          // tileColor: Colors.amber[colorCodes[index]],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
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
            // const Spacer(),
            SizedBox(
              width: 10.0,
            ),
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
