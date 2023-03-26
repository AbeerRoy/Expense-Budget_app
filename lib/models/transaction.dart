import 'package:flutter/foundation.dart';

//Normal blueprint of transaction and not a widget

class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;

  //Adding 'Transaction' constructor to use the values at run time
  Transaction(
      {required this.id,
      required this.title,
      required this.amount,
      required this.date});
}
