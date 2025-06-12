import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatDivider extends StatelessWidget {
  final DateTime date;
  const ChatDivider({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          const Expanded(
            child: Divider(
              indent: 12,
              endIndent: 24,
            ),
          ),
          Text(
            _formatDate(date),
          ),
          const Expanded(
            child: Divider(
              indent: 24,
              endIndent: 12,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    if (DateTime.now().difference(date).inDays == 0) return "اليوم";
    if (DateTime.now().difference(date).inDays == 1) return "امس";
    return DateFormat("yyyy/MM/dd", "ar").format(date);
  }
}
