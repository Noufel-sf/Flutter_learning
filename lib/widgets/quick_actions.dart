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
        _ActionButton(icon: Icons.arrow_upward_rounded, label: 'Send', onTap: onSend),
        _ActionButton(icon: Icons.arrow_downward_rounded, label: 'Receive', onTap: onReceive),
        _ActionButton(icon: Icons.account_balance_wallet_outlined, label: 'Top-up', onTap: onTopUp),
        _ActionButton(icon: Icons.more_horiz_rounded, label: 'More', onTap: onMore),
      ],
    );
  }
}

// ============================================================================
// ✨ MICRO-INTERACTION: Interactive Spring-scale Action Button
// ============================================================================
class _ActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.90 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutQuad,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: _isPressed
                    ? const Color(0xFF6366F1).withValues(alpha: 0.3)
                    : const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: _isPressed
                      ? const Color(0xFF818CF8)
                      : Colors.white.withValues(alpha: 0.06),
                  width: _isPressed ? 1.5 : 1.0,
                ),
                boxShadow: _isPressed
                    ? [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : null,
              ),
              child: Icon(widget.icon, color: const Color(0xFF818CF8), size: 26),
            ),
            const SizedBox(height: 8),
            Text(
              widget.label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
