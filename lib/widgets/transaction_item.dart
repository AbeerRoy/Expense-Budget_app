import 'package:flutter/material.dart';
import '../models/transaction.dart';
import './transaction_list.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    super.key,
    required this.transaction,
    required this.deleteTransaction,
  });

  final Transaction transaction;
  final Function deleteTransaction;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: EdgeInsets.all(6),
            child: FittedBox(
              child: Text('\৳${transaction.amount}'),
            ),
          ),
        ),
        title: Text(
          transaction.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        //),
        subtitle: Text(
          DateFormat.yMMMd().format(transaction.date),
        ),
        // ),
        trailing: FittedBox(
          child: IconButton(
              onPressed: () => deleteTransaction(transaction.id),
              icon: Icon(Icons.delete)),
        ),
      ),
    );
  }
}
