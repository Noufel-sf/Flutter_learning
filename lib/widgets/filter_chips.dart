import 'package:flutter/material.dart';

class FilterChipsSection extends StatelessWidget {
  final List<String> filters;
  final int selectedIndex;
  final ValueChanged<int> onFilterSelected;
  final VoidCallback? onSeeAll;

  const FilterChipsSection({
    super.key,
    required this.filters,
    required this.selectedIndex,
    required this.onFilterSelected,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
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
              onPressed: onSeeAll ?? () {},
              child: const Text(
                'See All',
                style: TextStyle(color: Color.fromARGB(255, 239, 89, 219)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: List.generate(filters.length, (index) {
              final bool isSelected = selectedIndex == index;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text(filters[index]),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      onFilterSelected(index);
                    }
                  },
                  backgroundColor: const Color.fromARGB(255, 162, 48, 250),
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
}
