import 'package:flutter/material.dart';

import '../../../core/constants/categories.dart';
import '../../../data/datasources/local/app_database.dart';

class CategoryChips extends StatelessWidget {
  final ScreenshotCategory selectedCategory;
  final ValueChanged<ScreenshotCategory> onCategorySelected;

  const CategoryChips({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final categoryInfo = categories[index];
          final isSelected = selectedCategory == categoryInfo.category;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FilterChip(
              label: Text(categoryInfo.label),
              selected: isSelected,
              onSelected: (_) => onCategorySelected(categoryInfo.category),
              showCheckmark: false,
              selectedColor: Theme.of(context).colorScheme.primaryContainer,
              labelStyle: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimaryContainer
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }
}
