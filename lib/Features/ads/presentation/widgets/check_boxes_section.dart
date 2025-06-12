import 'package:albazar_app/Features/ads/presentation/widgets/custom_check_box.dart';
import 'package:flutter/material.dart';

class CheckBoxesSection extends StatelessWidget {
  final String title;
  final List<String> items, selectedItems;
  final ValueChanged<String> onChanged;
  final bool isList;
  const CheckBoxesSection({
    super.key,
    required this.title,
    required this.selectedItems,
    required this.items,
    required this.onChanged,
    this.isList = false,
  });

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
        isList
            ? const SizedBox(
                height: 0,
              )
            : const SizedBox(height: 10),
        if (isList)
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return CustomCheckBox(
                text: items[index],
                isChecked: selectedItems.contains(items[index]),
                onChanged: (value) {
                  onChanged(items[index]);
                },
              );
            },
            separatorBuilder: (_, __) => const SizedBox(
              height: 8,
            ),
            itemCount: items.length,
          )
        else
          Wrap(
            spacing: 14,
            runSpacing: 25,
            children: items.map((item) {
              return CustomCheckBox(
                text: item,
                isChecked: selectedItems.contains(item),
                onChanged: (value) {
                  onChanged(item);
                },
              );
            }).toList(),
          ),
        //   shrinkWrap: true,
        //   physics: const NeverScrollableScrollPhysics(),
        //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //     crossAxisCount: 5, // 5 columns
        //     crossAxisSpacing: 5,
        //     mainAxisSpacing: 3,
        //     childAspectRatio: 1.2,
        //   ),
        //   itemCount: items.length,
        //   itemBuilder: (context, index) {
        //     return CustomCheckBox(
        //       text: items[index],
        //       isChecked: selectedItem == items[index],
        //       onChanged: (value) {
        //         if (selectedItem == items[index]) {
        //           onChanged('');
        //           return;
        //         }
        //         onChanged(items[index]);
        //       },
        //     );
        //   },
        // ),
      ],
    );
  }
}
