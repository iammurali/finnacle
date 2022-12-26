// ignore_for_file: prefer_const_constructors

import 'package:finance_journal/data/sqlhelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _spendings = [];

  bool _isLoading = true;

  TextEditingController spentonController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  void _refreshSpendings() async {
    final data = await SQLHelper.getItems();
    print(data);
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
      content: Text(
          "Launching this missile will destroy the entire universe. Is this what you intended to do?"),
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
    final deleted = await SQLHelper.deleteItem(id);
  }

  _addItem(int spendingType, spentOn, amount) async {
    // ignore: unused_local_variable

    if (amount != "" && amount != null) {
      amount = double.parse(amount);
    } else {
      return false;
    }

    final insertSpending =
        await SQLHelper.createItem(spentOn, null, spendingType, amount);
    _refreshSpendings();
  }

  void _showForm(int type) async {
    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
                // this will prevent the soft keyboard from covering the text fields
                bottom: MediaQuery.of(context).viewInsets.bottom + 120,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: spentonController,
                    decoration: const InputDecoration(hintText: 'Reason'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(hintText: 'Amount'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Save new journal
                      await _addItem(
                          type, spentonController.text, amountController.text);

                      // Clear the text fields
                      spentonController.text = '';
                      amountController.text = '';

                      // Close the bottom sheet
                      Navigator.of(context).pop();
                    },
                    child: Text('Create New'),
                  )
                ],
              ),
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
        title: Text(widget.title),
      ),
      body: _isLoading
          ? CircularProgressIndicator()
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _spendings.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  key: Key(_spendings[index]['id'].toString()),
                  confirmDismiss: (direction) =>
                      showAlertDialog(context, _spendings[index]['id'], index),
                  child: Material(
                    child: ListTile(
                      leading: _spendings[index]['spending_type'] == 0
                          ? Icon(
                              Icons.arrow_downward_sharp,
                              color: Color.fromARGB(255, 162, 65, 65),
                            )
                          : Icon(
                              Icons.arrow_upward_sharp,
                              color: Color.fromARGB(255, 111, 207, 114),
                            ),
                      trailing: Text(_spendings[index]['amount'].toString()),
                      title: Text(_spendings[index]['spent_on']),
                      subtitle: Text(DateFormat.yMMMEd().format(
                          DateTime.parse(_spendings[index]['createdAt']))),
                      // tileColor: Colors.amber[colorCodes[index]],
                    ),
                  ),
                );
              },
              // separatorBuilder: (BuildContext context, int index) => const Divider(),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Row(
          children: [
            FloatingActionButton(
              onPressed: () {
                _showForm(1);
              },
              backgroundColor: Color.fromARGB(255, 49, 136, 52),
              tooltip: 'Income',
              child: const Icon(Icons.add),
            ),
            const Spacer(),
            FloatingActionButton(
              onPressed: () {
                _showForm(0);
              },
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
