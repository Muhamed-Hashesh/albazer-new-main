import 'package:albazar_app/Features/chat/data/models/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatMessageCard extends StatelessWidget {
  final bool isMe;
  final ChatMessage message;
  const ChatMessageCard({
    super.key,
    this.isMe = true,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe
          ? AlignmentDirectional.centerStart
          : AlignmentDirectional.centerEnd,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.8,
        ),
        margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 15),
        decoration: BoxDecoration(
            // color:  Colors.grey ,
            // color: Colors.amber,
            borderRadius: BorderRadius.circular(10)),
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.only(
            bottomEnd: Radius.circular(isMe ? 16 : 0),
            bottomStart: Radius.circular(isMe ? 0 : 16),
            topStart: const Radius.circular(16),
            topEnd: const Radius.circular(16),
          )),
          color: isMe ? const Color(0xFFF6F9FF) : const Color(0xffFFED00),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.text,
                  style: TextStyle(color: Colors.black),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (message.id.isEmpty)
                      const Icon(
                        Icons.alarm,
                        size: 16,
                        color: Colors.grey,
                      ),
                    const SizedBox(
                      width: 6,
                    ),
                    Text(
                      DateFormat.jm().format(message.createdAt),
                      textAlign: TextAlign.right,
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall!
                          .copyWith(color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
