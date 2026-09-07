import 'package:flutter/material.dart';

class TransactionItem {
  final String title;
  final String category;
  final double amount;
  final IconData icon;
  final Color iconBg;
  final String date;
  final bool isExpense;

  const TransactionItem({
    required this.title,
    required this.category,
    required this.amount,
    required this.icon,
    required this.iconBg,
    required this.date,
    this.isExpense = true,
  });
}
