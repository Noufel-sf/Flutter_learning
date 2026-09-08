import 'package:flutter/material.dart';
import '../models/transaction_item.dart';
import '../widgets/top_header.dart';
import '../widgets/virtual_card.dart';
import '../widgets/quick_actions.dart';
import '../widgets/filter_chips.dart';
import '../widgets/transaction_list.dart';
import '../widgets/add_transaction_bottom_sheet.dart';
import 'send_money_screen.dart';

class WalletDashboardScreen extends StatefulWidget {
  const WalletDashboardScreen({super.key});

  @override
  State<WalletDashboardScreen> createState() => _WalletDashboardScreenState();
}

class _WalletDashboardScreenState extends State<WalletDashboardScreen> {
  int _selectedFilterIndex = 0;
  bool _isBalanceVisible = true;
  double _balance = 18450.80;

  final List<String> _filters = const [
    'All',
    'Income',
    'Expenses',
    'Subscriptions',
  ];

  // Mutable list to dynamically append new transactions
  final List<TransactionItem> _allTransactions = [
    const TransactionItem(
      title: 'Dribbble Pro',
      category: 'Subscription',
      amount: 19.99,
      icon: Icons.palette_outlined,
      iconBg: Color(0xFF999999),
      date: 'Today, 2:45 PM',
      isExpense: true,
    ),
    const TransactionItem(
      title: 'Client Payment',
      category: 'Freelance Work',
      amount: 2450.00,
      icon: Icons.arrow_downward_rounded,
      iconBg: Color(0xFF10B100),
      date: 'Yesterday',
      isExpense: false,
    ),
    const TransactionItem(
      title: 'Apple Store',
      category: 'Hardware',
      amount: 899.00,
      icon: Icons.laptop_mac_rounded,
      iconBg: Color.fromARGB(255, 68, 69, 121),
      date: 'Sep 04',
      isExpense: true,
    ),
    const TransactionItem(
      title: 'Starbucks Coffee',
      category: 'Food & Drinks',
      amount: 7.50,
      icon: Icons.coffee_rounded,
      iconBg: Color(0xFFF59E0B),
      date: 'Sep 02',
      isExpense: true,
    ),
  ];

  List<TransactionItem> get _filteredTransactions {
    return switch (_selectedFilterIndex) {
      1 => _allTransactions.where((t) => !t.isExpense).toList(),
      2 => _allTransactions.where((t) => t.isExpense).toList(),
      3 => _allTransactions.where((t) => t.category == 'Subscription').toList(),
      _ => _allTransactions,
    };
  }

  // ==========================================================================
  // 📝 MODAL BOTTOM SHEET TRIGGER & DYNAMIC STATE APPENDING
  // ==========================================================================
  Future<void> _openAddTransactionSheet() async {
    final newTransaction = await showModalBottomSheet<TransactionItem>(
      context: context,
      isScrollControlled: true, // Allows sheet to expand with keyboard
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => const AddTransactionBottomSheet(),
    );

    // If form was validated and submitted successfully
    if (newTransaction != null) {
      setState(() {
        // 1. Insert new transaction at top of list
        _allTransactions.insert(0, newTransaction);

        // 2. Dynamically calculate new wallet balance
        if (newTransaction.isExpense) {
          _balance -= newTransaction.amount;
        } else {
          _balance += newTransaction.amount;
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added "${newTransaction.title}" successfully!'),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddTransactionSheet,
        backgroundColor: const Color(0xFF6366F1),
        foregroundColor: Colors.white,
        elevation: 6,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Add',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Header Component
              TopHeader(
                userName: 'Noufel Dev',
                onNotificationTap: () {},
              ),

              const SizedBox(height: 34),

              // 2. Virtual Card Component
              VirtualCard(
                balance: _balance,
                isBalanceVisible: _isBalanceVisible,
                onToggleVisibility: () {
                  setState(() {
                    _isBalanceVisible = !_isBalanceVisible;
                  });
                },
              ),

              const SizedBox(height: 24),

              // 3. Quick Action Buttons Component
              QuickActions(
                onSend: () async {
                  final message = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SendMoneyScreen(),
                    ),
                  );
                  if (message != null && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(message),
                        backgroundColor: const Color(0xFF10B981),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                onReceive: _openAddTransactionSheet,
                onTopUp: _openAddTransactionSheet,
                onMore: () {},
              ),

              const SizedBox(height: 28),

              // 4. Filters Component
              FilterChipsSection(
                filters: _filters,
                selectedIndex: _selectedFilterIndex,
                onFilterSelected: (index) {
                  setState(() {
                    _selectedFilterIndex = index;
                  });
                },
                onSeeAll: () {},
              ),

              const SizedBox(height: 16),

              // 5. Transaction List Component
              TransactionList(
                transactions: _filteredTransactions,
              ),

              // Extra bottom padding for FloatingActionButton
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
