import 'package:flutter/material.dart';

class VirtualCard extends StatefulWidget {
  final double balance;
  final bool isBalanceVisible;
  final VoidCallback onToggleVisibility;
  final String cardNumber;
  final String expiryDate;

  const VirtualCard({
    super.key,
    required this.balance,
    required this.isBalanceVisible,
    required this.onToggleVisibility,
    this.cardNumber = '****  ****  ****  8842',
    this.expiryDate = '08/29',
  });

  @override
  State<VirtualCard> createState() => _VirtualCardState();
}

class _VirtualCardState extends State<VirtualCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    // ========================================================================
    // ✨ MICRO-INTERACTION: AnimatedScale on touch down/up
    // ========================================================================
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF6366F1),
                Color.fromARGB(255, 38, 82, 187),
                Color(0xFFEC4899),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6366F1).withValues(alpha: 0.35),
                blurRadius: _isPressed ? 10 : 20,
                offset: Offset(0, _isPressed ? 4 : 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Balance',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder: (child, anim) =>
                          ScaleTransition(scale: anim, child: child),
                      child: Icon(
                        widget.isBalanceVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        key: ValueKey<bool>(widget.isBalanceVisible),
                        color: Colors.white70,
                      ),
                    ),
                    onPressed: widget.onToggleVisibility,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // ================================================================
              // ✨ ANIMATED BALANCE COUNTER (TweenAnimationBuilder)
              // Smoothly interpolates the balance number when value changes!
              // ================================================================
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: widget.isBalanceVisible
                    ? TweenAnimationBuilder<double>(
                        key: const ValueKey('visible_balance'),
                        tween: Tween<double>(
                          begin: widget.balance,
                          end: widget.balance,
                        ),
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOutExpo,
                        builder: (context, animatedValue, child) {
                          return Text(
                            '\$${animatedValue.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          );
                        },
                      )
                    : const Text(
                        '••••••••',
                        key: ValueKey('hidden_balance'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.cardNumber,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      letterSpacing: 2,
                    ),
                  ),
                  Text(
                    widget.expiryDate,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
