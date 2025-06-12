import 'dart:math';
import 'package:albazar_app/Features/auth/data/models/user.dart';
import 'package:albazar_app/Features/chat/data/models/chat_message.dart';
import 'package:albazar_app/Features/chat/presentation/cubits/messages/messages_cubit.dart';
import 'package:albazar_app/Features/chat/presentation/view/widget/chat_divider.dart';
import 'package:albazar_app/Features/chat/presentation/view/widget/chat_message_card.dart';
import 'package:albazar_app/core/enums/request_status.dart';
import 'package:albazar_app/core/helper/messages.dart';
import 'package:albazar_app/core/helper/ulr_helper.dart';
import 'package:albazar_app/core/helper/user_helper.dart';
import 'package:albazar_app/core/widgets/avatars/user_avatar.dart';
import 'package:albazar_app/core/widgets/loading/custom_skeleton_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChatScreen extends StatefulWidget {
  final UserModel user;
  const ChatScreen({
    super.key,
    required this.user,
  });
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  void _sendMessage(BuildContext context) {
    if (_messageController.text.trim().isNotEmpty) {
      final message = ChatMessage.fromJson(
        {
          'text': _messageController.text.trim(),
          'senderId': UserHelper.user?.id,
          'receiverId': widget.user.id,
        },
      );
      _messageController.clear();
      context.read<MessagesCubit>().sendMessage(message: message);

      // setState(() {
      //   _messages.insert(
      //     0,
      //     ChatMessage.fromJson(
      //       {
      //         'text': _messageController.text.trim(),
      //         'senderId': UserHelper.user?.id,
      //         'receiverId': widget.user.id,
      //       },
      //     ),
      //   );
      // });
    }
  }

  @override
  void dispose() {
    context.read<MessagesCubit>().disposeSocketListeners();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Theme.of(context).secondaryHeaderColor,
        toolbarHeight: 80,
        backgroundColor: Theme.of(context).highlightColor,
        elevation: 6,
        title: Row(
          children: [
            Stack(
              children: [
                UserAvatar(
                  url: widget.user.profileImage ?? '',
                ),
                BlocSelector<MessagesCubit, MessagesState, bool>(
                  selector: (state) => state.isOnline,
                  builder: (context, isOnline) {
                    if (!isOnline) {
                      return const SizedBox.shrink();
                    }
                    return Positioned(
                      bottom: 0,
                      right: 42,
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: const ShapeDecoration(
                          color: Color(0xFF1FE526),
                          shape: OvalBorder(),
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
            const SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.user.firstName} ${widget.user.lastName}",
                  style: TextStyle(
                    color: Theme.of(context).focusColor,
                    fontSize: 16,
                    fontFamily: 'Noor',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    child: BlocSelector<MessagesCubit, MessagesState, bool>(
                      selector: (state) => state.isOnline,
                      builder: (context, isOnline) {
                        if (!isOnline) {
                          return const SizedBox.shrink(
                            key: ValueKey('offline'),
                          );
                        }
                        return Text(
                          'متصل',
                          key: const ValueKey('online'),
                          style: TextStyle(
                            color: Theme.of(context).focusColor,
                            fontSize: 13,
                            fontFamily: 'Noor',
                            fontWeight: FontWeight.w400,
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            )
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            color: Theme.of(context).scaffoldBackgroundColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () async {
                  await UrlHelper.openPhone(number: widget.user.phone);
                  // print('${widget.user.phone} User ID');
                },
                child: const ListTile(
                  title: Text('اتصال'),
                  leading: Icon(
                    Icons.call,
                  ),
                ),
              ),
              PopupMenuItem(
                onTap: () async => await UrlHelper.openWhatsapp(
                  number: widget.user.phone,
                ),
                child: const ListTile(
                  title: Text('واتساب'),
                  leading: FaIcon(FontAwesomeIcons.whatsapp),
                ),
              ),
            ],
            child: const Icon(Icons.more_vert_sharp, size: 40),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<MessagesCubit, MessagesState>(
              listenWhen: (previous, current) => current.messages.isNotEmpty,
              listener: (context, state) {
                if (state.status == RequestStatus.error &&
                    state.messages.isNotEmpty) {
                  AppMessages.showError(context, state.error);
                }
              },
              builder: (context, state) {
                return CustomSkeletonWidget(
                  isLoading: state.status == RequestStatus.loading &&
                      state.messages.isEmpty,
                  child: Builder(builder: (context) {
                    if (state.status == RequestStatus.loading &&
                        state.messages.isEmpty) {
                      return ListView.builder(
                        reverse: true,
                        padding: const EdgeInsets.all(8.0),
                        itemCount: Random().nextInt(100) + 10,
                        itemBuilder: (context, index) {
                          return ChatMessageCard(
                            message: ChatMessage.fromJson({
                              "text": "s" * (Random().nextInt(100) + 1),
                            }),
                            isMe: Random().nextBool(),
                          );
                        },
                      );
                    }
                    if (state.status == RequestStatus.error &&
                        state.messages.isEmpty) {
                      return Center(
                        child: Text(state.error),
                      );
                    }
                    return ListView.separated(
                      reverse: true,
                      padding: const EdgeInsets.all(8.0),
                      itemCount: state.messages.length,
                      separatorBuilder: (context, index) {
                        if (state.messages[index].id.isNotEmpty) {
                          if (index < state.messages.length - 1) {
                            if (state.messages[index].createdAt.day !=
                                state.messages[index + 1].createdAt.day) {
                              return ChatDivider(
                                date: state.messages[index].createdAt,
                              );
                            }
                          }
                        }

                        return const SizedBox.shrink();
                      },
                      itemBuilder: (context, index) {
                        return ChatMessageCard(
                          message: state.messages[index],
                          isMe: state.messages[index].senderId ==
                              UserHelper.user?.id,
                        );
                      },
                    );
                  }),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    child: TextField(
                      controller: _messageController,
                      maxLines: 5,
                      minLines: 1,
                      decoration: const InputDecoration(
                        // suffixIcon: Row(
                        //   mainAxisAlignment: MainAxisAlignment.end,
                        //   mainAxisSize: MainAxisSize.min,
                        //   children: [
                        //     IconButton(
                        //       onPressed: () {},
                        //       icon: const Icon(Icons.ice_skating),
                        //     ),
                        //     IconButton(
                        //       onPressed: () {},
                        //       icon: const Icon(Icons.camera),
                        //     ),
                        //   ],
                        // ),
                        border: InputBorder.none,
                        hintText: "ارسل رسالة...",
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton.filled(
                  onPressed: () => _sendMessage(context),
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
