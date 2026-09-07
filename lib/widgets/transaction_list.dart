import 'package:flutter/material.dart';
import '../models/transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<TransactionItem> transactions;

  const TransactionList({
    super.key,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        alignment: Alignment.center,
        child: const Text(
          'No transactions found in this category.',
          style: TextStyle(color: Colors.white38),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = transactions[index];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 21, 34, 55),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: item.iconBg.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.icon, color: item.iconBg, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item.category} • ${item.date}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(95, 241, 228, 228),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${item.isExpense ? '-' : '+'}\$${item.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: item.isExpense
                      ? const Color.fromARGB(255, 15, 224, 57)
                      : const Color.fromARGB(255, 10, 53, 39),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
