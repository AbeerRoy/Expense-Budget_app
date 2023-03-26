import 'package:budget_app/widgets/chart_bar.dart';

import '../models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  //importing the Transaction
  final List<Transaction> recentTransactions;
  //constructor is a chart
  Chart(this.recentTransactions);

  //getter are the property that's calculated dynamically
  List<Map<String, Object>> get groupedTransactionValues {
    // return the generated List
    return List.generate(7, (index) {
      //grouping transaction with weekdays and then substracted present time value as the recent will be latest
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      double totalSum = 0.0;

      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }

      // print(DateFormat.E().format(weekDay));
      // print(totalSum);

      //return nested Map of all the values

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + (item['amount'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
      child: Card(
        elevation: 6,
        margin: EdgeInsets.all(20),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupedTransactionValues.map((data) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                  label: data['day'].toString(),
                  spendingAmount: (data['amount'] as double),
                  spendingPercentageTotal:
                      // checking if totalSpending is zero or not
                      totalSpending == 0.0
                          ? 0.0
                          : ((data['amount'] as double) / totalSpending),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
