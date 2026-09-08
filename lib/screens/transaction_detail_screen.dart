import 'package:flutter/material.dart';
import '../models/transaction_item.dart';

class TransactionDetailScreen extends StatelessWidget {
  final TransactionItem transaction;

  const TransactionDetailScreen({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () {
            // Navigator.pop removes this screen from the stack and goes back
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Transaction Details',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Centered Avatar / Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: transaction.iconBg.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: transaction.iconBg.withValues(alpha: 0.6),
                  width: 2,
                ),
              ),
              child: Icon(transaction.icon, color: transaction.iconBg, size: 40),
            ),
            const SizedBox(height: 16),
            Text(
              transaction.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              transaction.category,
              style: const TextStyle(fontSize: 14, color: Colors.white54),
            ),
            const SizedBox(height: 24),
            // Amount Display
            Text(
              '${transaction.isExpense ? '-' : '+'}\$${transaction.amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                color: transaction.isExpense
                    ? const Color(0xFFEF4444)
                    : const Color(0xFF10B981),
              ),
            ),
            const SizedBox(height: 36),

            // Details Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Column(
                children: [
                  _buildDetailRow('Status', 'Completed', isBadge: true),
                  const Divider(color: Colors.white12, height: 28),
                  _buildDetailRow('Date & Time', transaction.date),
                  const Divider(color: Colors.white12, height: 28),
                  _buildDetailRow('Payment Method', 'Apex Virtual Card (8842)'),
                  const Divider(color: Colors.white12, height: 28),
                  _buildDetailRow('Reference ID', 'TXN-984210985'),
                ],
              ),
            ),

            const SizedBox(height: 36),

            // Action Button to go back with result
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  // You can pass data back to the previous screen when popping!
                  Navigator.pop(context, 'Receipt downloaded for ${transaction.title}');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.download_rounded),
                label: const Text(
                  'Download Receipt',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBadge = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 14)),
        if (isBadge)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF10B981),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          )
        else
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
      ],
    );
  }
}
