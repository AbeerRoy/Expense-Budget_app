import 'package:flutter/material.dart';
import '../models/transaction.dart';

import './transaction_item.dart';

class TransactionList extends StatelessWidget {
  // Display format for the List of added transactions
  final List<Transaction> transactions;
  final Function deleteTransaction;

  const TransactionList(
      {required this.transactions, required this.deleteTransaction});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    final textScaleFactor = mediaQuery.textScaleFactor;
    return Container(
      // height: 400, //should be edited based on emulator effect
      //SingleChildScrollView makes the column nested scrollable in same page
      //child: SingleChildScrollView(
      //MediaQuery class has more adaptive ability
      height: mediaQuery.size.height * 0.65,
      child: transactions.isEmpty
          ? LayoutBuilder(builder: (context, constraints) {
              return Column(
                children: [
                  FittedBox(
                    child: Text('No transaction added yet!',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.bold,
                          fontSize: 25 * textScaleFactor,
                        )),
                  ),

                  //Image path
                  Container(
                      height: constraints.maxHeight * 0.35,
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: Image.asset(
                        'assets/images/no_task.png',
                        fit: BoxFit.cover,
                      ))
                ],
              );
            })
          : ListView.builder(
              itemBuilder: (context, index) {
                //creates and deletes list Item using transaction_list
                return TransactionItem(
                    transaction: transactions[index],
                    deleteTransaction: deleteTransaction);
              },
              itemCount: transactions.length,
            ),
      //instead of using the Column children method we return the card items
      //children: transactions.map((transaction) {
      //ListTile is an alternative to card widget. its has build-in features that caters List files for view
      // return Card(
      //   child: Row(
      //     children: <Widget>[
      //       Column(
      //         crossAxisAlignment: CrossAxisAlignment.center,
      //         children: [
      //           Container(
      //             margin: EdgeInsets.symmetric(
      //                 vertical: 10, horizontal: 15),
      //             decoration: BoxDecoration(
      //                 // borderRadius: BorderRadiusDirectional.horizontal(
      //                 //     end: Radius.zero),
      //                 border: Border.all(
      //               color: Theme.of(context).primaryColor,
      //               width: 2,
      //             )),

      //             //Transaction amount

      //             child: FittedBox(
      //               child: Text(
      //                 'BDT: ${transactions[index].amount.toStringAsFixed(2)}',
      //                 style: TextStyle(
      //                   fontWeight: FontWeight.bold,
      //                   fontSize: 8,
      //                   color: Theme.of(context).primaryColor,
      //                   fontFamily: 'Lato',
      //                 ),
      //               ),
      //             ),
      //             padding: EdgeInsets.all(8),
      //           ),
      //         ],
      //       ),

      //       //Transaction Title

      //       Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           Text(
      //             transactions[index].title,
      //             style: TextStyle(
      //               fontWeight: FontWeight.bold,
      //               fontSize: 16,
      //               fontFamily: 'Lato',
      //             ),
      //           ),

      //           //Transaction Date

      //           Text(
      //             DateFormat.yMMMd()
      //                 .add_jm()
      //                 .format(transactions[index].date),
      //             style: TextStyle(
      //               color: Colors.grey,
      //               fontFamily: 'Lato',
      //             ),
      //           ),
      //         ],
      //       ),
      //     ],
      //   ),
      // );

      //   },
      //   //the itemCount constructor keeps track of items present in list and renders based on the length
      //   itemCount: transactions.length,
      // ),
    );
  }
}
