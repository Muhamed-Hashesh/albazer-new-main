import 'package:albazar_app/core/widgets/chips/custom_selection_chip.dart';
import 'package:flutter/material.dart';

class ChipSection extends StatelessWidget {
  const ChipSection({
    super.key,
    required this.items,
    required this.title,
    required this.selectedItems,
    required this.onSelect,
    this.inDashboard = false,
  });

  final List<String> items;
  final String title;
  final List<String> selectedItems;
  final ValueChanged<String> onSelect;
  final bool inDashboard;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          textAlign: TextAlign.right,
          style: TextStyle(
            color: Theme.of(context).focusColor,
            fontSize: 16,
            fontFamily: 'Noor',
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Wrap(
          spacing: 8,
          runSpacing: 10,
          children: items.map((item) {
            return CustomSelectionChip(
              label: item,
              isSelected: selectedItems.contains(item),
              onSelect: onSelect,
            );
          }).toList(),
        ),
      ],
    );
  }
}
