import 'package:albazar_app/core/utils/colors.dart';
import 'package:flutter/material.dart';

class NumbersSection extends StatelessWidget {
  const NumbersSection({
    super.key,
    required this.title,
    required this.maxNumbers,
    required this.selectedNumber,
    required this.onSelect,
  });

  final String title;
  final int maxNumbers, selectedNumber;
  final ValueChanged<int> onSelect;

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
          children: List.generate(maxNumbers, ((index) {
            return GestureDetector(
              onTap: () {
                if (selectedNumber == index + 1) {
                  onSelect(0);
                  return;
                }
                onSelect(index + 1);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: ShapeDecoration(
                  color: selectedNumber == index + 1
                      ? AppColor.coverPageColor
                      : Theme.of(context).highlightColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "${index + 1}",
                  style: const TextStyle(
                    color: Color(0xff8C8C8C),
                    fontSize: 14,
                    fontFamily: 'Noor',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            );
          })),
        ),
      ],
    );
  }
}
