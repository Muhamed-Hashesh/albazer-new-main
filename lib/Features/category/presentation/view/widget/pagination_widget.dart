import 'package:albazar_app/core/utils/colors.dart';
import 'package:albazar_app/core/utils/styles.dart';
import 'package:flutter/material.dart';

class PaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;
  final bool isLoading;

  const PaginationWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).secondaryHeaderColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Previous button
          _buildNavigationButton(
            context: context,
            icon: Icons.chevron_left,
            enabled: currentPage > 1 && !isLoading,
            onTap: () => onPageChanged(currentPage - 1),
          ),

          const SizedBox(width: 12),

          // Page numbers
          Expanded(
            child: _buildPageNumbers(context),
          ),

          const SizedBox(width: 12),

          // Next button
          _buildNavigationButton(
            context: context,
            icon: Icons.chevron_right,
            enabled: currentPage < totalPages && !isLoading,
            onTap: () => onPageChanged(currentPage + 1),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton({
    required BuildContext context,
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: enabled ? AppColor.coverPageColor : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: enabled ? Colors.white : Colors.grey.shade500,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildPageNumbers(BuildContext context) {
    List<Widget> pageNumbers = [];

    // Calculate which pages to show
    int startPage = 1;
    int endPage = totalPages;

    if (totalPages > 7) {
      if (currentPage <= 4) {
        endPage = 7;
      } else if (currentPage >= totalPages - 3) {
        startPage = totalPages - 6;
      } else {
        startPage = currentPage - 3;
        endPage = currentPage + 3;
      }
    }

    // Add first page if not visible
    if (startPage > 1) {
      pageNumbers.add(_buildPageNumber(context, 1));
      if (startPage > 2) {
        pageNumbers.add(_buildDots());
      }
    }

    // Add visible page numbers
    for (int i = startPage; i <= endPage; i++) {
      pageNumbers.add(_buildPageNumber(context, i));
    }

    // Add last page if not visible
    if (endPage < totalPages) {
      if (endPage < totalPages - 1) {
        pageNumbers.add(_buildDots());
      }
      pageNumbers.add(_buildPageNumber(context, totalPages));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: pageNumbers,
      ),
    );
  }

  Widget _buildPageNumber(BuildContext context, int page) {
    final isSelected = page == currentPage;

    return GestureDetector(
      onTap: isLoading ? null : () => onPageChanged(page),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? AppColor.coverPageColor : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppColor.coverPageColor : Colors.grey.shade400,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            page.toString(),
            style: Styles.style14.copyWith(
              color: isSelected ? Colors.white : Theme.of(context).focusColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDots() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 40,
      height: 40,
      child: const Center(
        child: Text(
          '...',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
