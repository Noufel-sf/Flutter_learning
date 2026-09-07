import 'package:flutter/material.dart';

void main() {
  runApp(const ApexWalletApp());
}

// ============================================================================
// 1. ROOT APP (StatelessWidget + Theme Configuration)
// ============================================================================
class ApexWalletApp extends StatelessWidget {
  const ApexWalletApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Apex Pay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1), // Modern Indigo
          brightness: Brightness.dark,
          surface: const Color(0xFF0F172A),  // Deep Slate background
        ),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const WalletDashboardScreen(),
    );
  }
}

// ============================================================================
// 2. DATA MODELS (Clean, Immutable Dart Models)
// ============================================================================
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

// ============================================================================
// 3. MAIN SCREEN (StatefulWidget for interactive category filter & balance)
// ============================================================================
class WalletDashboardScreen extends StatefulWidget {
  const WalletDashboardScreen({super.key});

  @override
  State<WalletDashboardScreen> createState() => _WalletDashboardScreenState();
}

class _WalletDashboardScreenState extends State<WalletDashboardScreen> {
  // State variables
  int _selectedFilterIndex = 0;
  bool _isBalanceVisible = true;

  final List<String> _filters = ['All', 'Income', 'Expenses', 'Subscriptions'];

  final List<TransactionItem> _allTransactions = const [
    TransactionItem(
      title: 'Dribbble Pro',
      category: 'Subscription',
      amount: 19.99,
      icon: Icons.palette_outlined,
      iconBg: Color(0xFFEC4899),
      date: 'Today, 2:45 PM',
      isExpense: true,
    ),
    TransactionItem(
      title: 'Client Payment',
      category: 'Freelance Work',
      amount: 2450.00,
      icon: Icons.arrow_downward_rounded,
      iconBg: Color(0xFF10B981),
      date: 'Yesterday',
      isExpense: false,
    ),
    TransactionItem(
      title: 'Apple Store',
      category: 'Hardware',
      amount: 899.00,
      icon: Icons.laptop_mac_rounded,
      iconBg: Color(0xFF6366F1),
      date: 'Sep 04',
      isExpense: true,
    ),
    TransactionItem(
      title: 'Starbucks Coffee',
      category: 'Food & Drinks',
      amount: 7.50,
      icon: Icons.coffee_rounded,
      iconBg: Color(0xFFF59E0B),
      date: 'Sep 02',
      isExpense: true,
    ),
  ];

  // Filtering transactions dynamically
  List<TransactionItem> get _filteredTransactions {
    return switch (_selectedFilterIndex) {
      1 => _allTransactions.where((t) => !t.isExpense).toList(),
      2 => _allTransactions.where((t) => t.isExpense).toList(),
      3 => _allTransactions.where((t) => t.category == 'Subscription').toList(),
      _ => _allTransactions,
    };
  }

  @override
  Widget build(BuildContext context) {
    // SafeArea ensures content doesn't collide with status bars or notches
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Header Bar
              _buildTopHeader(),

              const SizedBox(height: 24),

              // 2. Premium Gradient Virtual Card
              _buildVirtualCard(),

              const SizedBox(height: 24),

              // 3. Quick Action Buttons (Send, Receive, Pay, More)
              _buildQuickActionButtons(),

              const SizedBox(height: 28),

              // 4. Section Title & Category Filters
              _buildFilterSection(),

              const SizedBox(height: 16),

              // 5. Transaction List View
              _buildTransactionList(),
            ],
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // Extracted Component: Top Header
  // --------------------------------------------------------------------------
  Widget _buildTopHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // User Avatar with Ring
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF6366F1), width: 2),
              ),
              child: const CircleAvatar(
                radius: 22,
                backgroundColor: Color(0xFF1E293B),
                child: Icon(Icons.person, color: Colors.white70),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Welcome back,',
                  style: TextStyle(fontSize: 13, color: Colors.white54),
                ),
                Text(
                  'Noufel Dev',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
        // Notification Icon Button with subtle background
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Colors.white),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  // --------------------------------------------------------------------------
  // Extracted Component: Premium Glass / Gradient Card
  // --------------------------------------------------------------------------
  Widget _buildVirtualCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF9333EA), Color(0xFFEC4899)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 10),
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
                icon: Icon(
                  _isBalanceVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: Colors.white70,
                ),
                onPressed: () {
                  setState(() {
                    _isBalanceVisible = !_isBalanceVisible;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _isBalanceVisible ? '\$18,450.80' : '••••••••',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                '****  ****  ****  8842',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  letterSpacing: 2,
                ),
              ),
              Text(
                '08/29',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // Extracted Component: Quick Action Buttons
  // --------------------------------------------------------------------------
  Widget _buildQuickActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionButton(Icons.arrow_upward_rounded, 'Send', () {}),
        _buildActionButton(Icons.arrow_downward_rounded, 'Receive', () {}),
        _buildActionButton(Icons.account_balance_wallet_outlined, 'Top-up', () {}),
        _buildActionButton(Icons.more_horiz_rounded, 'More', () {}),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
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

  // --------------------------------------------------------------------------
  // Extracted Component: Filters & Section Header
  // --------------------------------------------------------------------------
  Widget _buildFilterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Transactions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('See All', style: TextStyle(color: Color(0xFF818CF8))),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: List.generate(_filters.length, (index) {
              final bool isSelected = _selectedFilterIndex == index;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text(_filters[index]),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedFilterIndex = index;
                      });
                    }
                  },
                  backgroundColor: const Color(0xFF1E293B),
                  selectedColor: const Color(0xFF6366F1),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.white60,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  // --------------------------------------------------------------------------
  // Extracted Component: Transactions List
  // --------------------------------------------------------------------------
  Widget _buildTransactionList() {
    final list = _filteredTransactions;
    if (list.isEmpty) {
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
      shrinkWrap: true, // required when nesting inside SingleChildScrollView
      physics: const NeverScrollableScrollPhysics(), // let parent scroll
      itemCount: list.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = list[index];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
          ),
          child: Row(
            children: [
              // Category Icon
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
              // Title & Category
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
                      style: const TextStyle(fontSize: 12, color: Colors.white38),
                    ),
                  ],
                ),
              ),
              // Amount (Green if income, White if expense)
              Text(
                '${item.isExpense ? '-' : '+'}\$${item.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: item.isExpense ? Colors.white : const Color(0xFF10B981),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
