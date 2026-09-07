import 'package:flutter/material.dart';

class QuickActions extends StatelessWidget {
  final VoidCallback? onSend;
  final VoidCallback? onReceive;
  final VoidCallback? onTopUp;
  final VoidCallback? onMore;

  const QuickActions({
    super.key,
    this.onSend,
    this.onReceive,
    this.onTopUp,
    this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionButton(Icons.arrow_upward_rounded, 'Send', onSend),
        _buildActionButton(Icons.arrow_downward_rounded, 'Receive', onReceive),
        _buildActionButton(Icons.account_balance_wallet_outlined, 'Top-up', onTopUp),
        _buildActionButton(Icons.more_horiz_rounded, 'More', onMore),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
            ),
            child: Icon(icon, color: const Color(0xFF818CF8), size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
