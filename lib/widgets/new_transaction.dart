import 'package:flutter/material.dart';
import 'transaction_list.dart';
import '../models/button_color.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final addnewTransaction;

  NewTransaction({required this.addnewTransaction});

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  //add controller which will be created by constructor that responds to user keystrokes
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

// executes the function and updates the TransactionList
  void _submitData() {
    final enteredTitle = _titleController.text;
    final enterAmount = _amountController.text;

    if ((enteredTitle.isEmpty && enterAmount.isEmpty) ||
        (enteredTitle.isEmpty && enterAmount.isNotEmpty) ||
        (enteredTitle.isNotEmpty && enterAmount.isEmpty) ||
        (enteredTitle.isNotEmpty &&
            (RegExp(r'^(\\w+)$').hasMatch(enterAmount))) ||
        (enteredTitle.isNotEmpty &&
            // (RegExp(r'^(\\d+)$').hasMatch(enterAmount) &&
            (double.parse(enterAmount) <= 0))) {
      return;
    }
    //  else if ((enteredTitle.isNotEmpty &&
    //     (RegExp(r'^(\\d+)$').hasMatch(enterAmount) &&
    //         (double.parse(enterAmount) <= 0)))) {
    //   return;
    // }
    //widget dot(.) notation allows state class fuction to access widget property of widget class: NewTransaction
    widget.addnewTransaction(
      enteredTitle,
      //converts user input to numeric value
      double.parse(enterAmount),

      _selectedDate,
    );
    //closes the bottom sheet after single confirmation
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      // this function will only be called if user choose a date
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: mediaQuery.viewInsets.bottom +
                10, //viewInsets controls the keyboard and its interaction with the top view of it
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Title'),

                // onChanged: (value) {
                //   titleInput = value;
                // },

                controller: _titleController,
                //after finalizing user input it calls the build submit function of user input to be in a executable form
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Amount'),
                // onChanged: (value) => amountInput = value,
                controller: _amountController,
                //after finalizing user input it calls the build submit function of user input to be in a executable form
                onSubmitted: (_) => _submitData(),
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //takes as much as space as possible
                  Expanded(
                    child: Text(
                      style: TextStyle(
                        color: Color.fromARGB(255, 138, 138, 138),
                        fontFamily: 'Lato',
                      ),
                      _selectedDate == null
                          ? 'Choose Date'
                          : 'Selected Date: ${DateFormat.yMMMd().format(_selectedDate)}',
                    ),
                  ),
                  IconButton(
                      onPressed: _presentDatePicker,
                      // backgroundColor: Color.fromARGB(255, 0, 95, 150),
                      icon: Icon(
                        Icons.date_range_sharp,
                        color: Color.fromARGB(255, 0, 95, 150),
                      )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    // executes the function and updates the TransactionList
                    onPressed: _submitData,

                    child: Text('Add Transaction'),
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.resolveWith(ButtonColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
