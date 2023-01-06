import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddSpendingForm extends StatefulWidget {
  const AddSpendingForm(
      {Key? key,
      required this.context,
      required this.spendingType,
      required this.addItem})
      : super(key: key);

  final BuildContext context;
  final int spendingType;
  final Function addItem;

  @override
  State<AddSpendingForm> createState() => _AddSpendingFormState();
}

class _AddSpendingFormState extends State<AddSpendingForm> {
  List<String> list = <String>['Regular', 'Loan', 'Debt', 'Investment'];

  String dropdownValue = 'Regular';

  TextEditingController spentonController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  int? _selected = 0;

  Widget _icon(int index, {String? text, IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Center(
        child: GestureDetector(
          child: SizedBox(
            width: 60,
            height: 60,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: _selected == index
                    ? Color.fromARGB(121, 79, 65, 2)
                    : Color.fromARGB(44, 77, 76, 76),
              ),
              // color: Colors.grey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: _selected == index ? Colors.yellow : null,
                  ),
                  Text(text!,
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w300,
                          color: _selected == index ? Colors.yellow : null)),
                ],
              ),
            ),
          ),
          onTap: () => setState(
            () {
              _selected = index;
              dropdownValue = list[index];
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 15,
        left: 15,
        right: 15,
        // this will prevent the soft keyboard from covering the text fields
        bottom: MediaQuery.of(context).viewInsets.bottom + 120,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Text(
                widget.spendingType == 0 ? 'Add Expense' : 'Add Income',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
            ],
          ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _icon(0, text: "Regular", icon: Icons.monetization_on),
              _icon(1, text: "Loan", icon: Icons.outbond),
              _icon(2, text: "Debt", icon: Icons.arrow_drop_down_circle),
              _icon(3, text: "Investment", icon: Icons.pie_chart),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () async {
              // Save new journal
              await widget.addItem(widget.spendingType, spentonController.text,
                  amountController.text, dropdownValue);

              // // Clear the text fields
              spentonController.text = '';
              amountController.text = '';

              // Close the bottom sheet
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop();
            },
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    widget.spendingType == 0 ? 'Add Expense' : 'Add Income')),
          )
        ],
      ),
    );
  }
}
