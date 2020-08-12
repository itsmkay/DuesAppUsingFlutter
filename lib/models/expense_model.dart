import 'package:flutter/foundation.dart';

enum SplitType {
  equally, owe, lent
}

enum PaidBy {
  me, other,
}

class Expense{
  final String description;
  final double amount;
  final String id;
  final PaidBy paidBy;
  final SplitType splitType;

  Expense({
    @required this.amount,
    @required this.description,
    @required this.id,
    @required this.paidBy,
    @required this.splitType,
  });
}