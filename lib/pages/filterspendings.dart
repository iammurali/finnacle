import 'package:flutter/material.dart';

class FilterSpendings extends StatefulWidget {
  const FilterSpendings({
    Key? key,
  }) : super(key: key);

  @override
  State<FilterSpendings> createState() => _FilterSpendingsState();
}

class _FilterSpendingsState extends State<FilterSpendings> {
  String? range;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Filter',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 5,
        ),
        RadioListTile(
          title: const Text(
            'This Month',
          ),
          value: "month",
          groupValue: range,
          activeColor: Colors.green,
          selectedTileColor: Colors.green,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          onChanged: (value) {
            setState(() {
              range = value.toString();
            });
          },
        ),
        const SizedBox(
          height: 5,
        ),
        RadioListTile(
          title: Text('This Week'),
          value: "week",
          activeColor: Colors.green,
          selectedTileColor: Colors.green,
          groupValue: range,
          onChanged: (value) {
            setState(() {
              range = value.toString();
            });
          },
        ),
        const SizedBox(
          height: 5,
        ),
        RadioListTile(
          title: Text("Today"),
          value: "today",
          activeColor: Colors.green,
          selectedTileColor: Colors.green,
          groupValue: range,
          onChanged: (value) {
            setState(() {
              range = value.toString();
            });
          },
        ),
        const SizedBox(
          height: 5,
        ),
        RadioListTile(
          title: Text("Income only"),
          value: "income",
          groupValue: range,
          activeColor: Colors.green,
          selectedTileColor: Colors.green,
          onChanged: (value) {
            setState(() {
              range = value.toString();
            });
          },
        ),
        const SizedBox(
          height: 5,
        ),
        RadioListTile(
          title: Text("Expense only"),
          value: "expense",
          activeColor: Colors.green,
          selectedTileColor: Colors.green,
          groupValue: range,
          onChanged: (value) {
            setState(() {
              range = value.toString();
            });
          },
        ),
      ],
    );
  }
}
