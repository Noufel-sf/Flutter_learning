import 'package:flutter/material.dart';
import '../models/transaction_item.dart';

class AddTransactionBottomSheet extends StatefulWidget {
  const AddTransactionBottomSheet({super.key});

  @override
  State<AddTransactionBottomSheet> createState() =>
      _AddTransactionBottomSheetState();
}

class _AddTransactionBottomSheetState extends State<AddTransactionBottomSheet> {
  // 1. Form Key for validation (Equivalent to React Form ref)
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // 2. Controllers for text fields (Controlled inputs)
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  // Form State variables
  bool _isExpense = true;
  String _selectedCategory = 'Food & Drinks';

  final List<String> _categories = const [
    'Food & Drinks',
    'Shopping',
    'Subscription',
    'Freelance Work',
    'Travel',
    'Entertainment',
  ];

  // Map category to icons & colors
  (IconData, Color) _getCategoryMeta(String category) {
    return switch (category) {
      'Food & Drinks' => (Icons.coffee_rounded, const Color(0xFFF59E0B)),
      'Shopping' => (Icons.shopping_bag_outlined, const Color(0xFFEC4899)),
      'Subscription' => (Icons.palette_outlined, const Color(0xFF8B5CF6)),
      'Freelance Work' => (Icons.arrow_downward_rounded, const Color(0xFF10B981)),
      'Travel' => (Icons.flight_takeoff_rounded, const Color(0xFF06B6D4)),
      _ => (Icons.receipt_long_rounded, const Color(0xFF6366F1)),
    };
  }

  // 3. IMPORTANT: Dispose controllers to prevent memory leaks!
  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submitForm() {
    // Triggers all validator functions inside the Form
    if (_formKey.currentState!.validate()) {
      final double amount = double.parse(_amountController.text.trim());
      final (IconData icon, Color color) = _getCategoryMeta(_selectedCategory);

      // Create the new TransactionItem model
      final newTransaction = TransactionItem(
        title: _titleController.text.trim(),
        category: _selectedCategory,
        amount: amount,
        icon: icon,
        iconBg: color,
        date: 'Just now',
        isExpense: _isExpense,
      );

      // Pass the newly created transaction back to the dashboard!
      Navigator.pop(context, newTransaction);
    }
  }

  @override
  Widget build(BuildContext context) {
    // viewInsets handles moving the bottom sheet above the keyboard when open
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: bottomInset + 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar indicator
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Title Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'New Transaction',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white54),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Transaction Type Toggle (Expense vs Income)
              Row(
                children: [
                  Expanded(
                    child: _buildTypeButton(
                      title: 'Expense (-)',
                      isSelected: _isExpense,
                      color: const Color(0xFFEF4444),
                      onTap: () => setState(() => _isExpense = true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTypeButton(
                      title: 'Income (+)',
                      isSelected: !_isExpense,
                      color: const Color(0xFF10B981),
                      onTap: () => setState(() => _isExpense = false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Title Input Field
              const Text(
                'Description / Payee',
                style: TextStyle(fontSize: 13, color: Colors.white70),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration(
                  hintText: 'e.g., Grocery Shopping, Netflix',
                  prefixIcon: Icons.edit_note_rounded,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title or payee';
                  }
                  if (value.trim().length < 3) {
                    return 'Title must be at least 3 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Amount Input Field
              const Text(
                'Amount (\$)',
                style: TextStyle(fontSize: 13, color: Colors.white70),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration(
                  hintText: '0.00',
                  prefixIcon: Icons.attach_money_rounded,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an amount';
                  }
                  final parsed = double.tryParse(value.trim());
                  if (parsed == null || parsed <= 0) {
                    return 'Please enter a valid amount greater than 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),

              // Category Selector (ChoiceChips)
              const Text(
                'Category',
                style: TextStyle(fontSize: 13, color: Colors.white70),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedCategory = cat);
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
                      borderRadius: BorderRadius.circular(12),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 26),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text(
                    'Save Transaction',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeButton({
    required String title,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.2) : const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? color : Colors.white60,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.white30, fontSize: 14),
      prefixIcon: Icon(prefixIcon, color: const Color(0xFF818CF8), size: 20),
      filled: true,
      fillColor: const Color(0xFF1E293B),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF6366F1), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
      ),
    );
  }
}
