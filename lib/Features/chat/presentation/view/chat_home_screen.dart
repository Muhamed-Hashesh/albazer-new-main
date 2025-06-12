import 'dart:math';

import 'package:albazar_app/core/extensions/navigation_extension.dart';
import 'package:albazar_app/core/routes/routes.dart';
import 'package:albazar_app/core/widgets/custom_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:albazar_app/Features/ads/presentation/widgets/form_header.dart';
import 'package:albazar_app/Features/chat/data/models/chat.dart';
import 'package:albazar_app/Features/chat/presentation/cubits/chats/chats_cubit.dart';
import 'package:albazar_app/core/enums/request_status.dart';
import 'package:albazar_app/core/helper/messages.dart';
import 'package:albazar_app/core/helper/user_helper.dart';
import 'package:albazar_app/core/utils/icons.dart';
import 'package:albazar_app/core/widgets/avatars/user_avatar.dart';
import 'package:albazar_app/core/widgets/loading/custom_skeleton_widget.dart';

class ChatHomeScreen extends StatelessWidget {
  const ChatHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const FormHeader(
              title: "محادثه",
              image: AppIcons.chat, // you can change this icon to messagess
              isIcon: true,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height - 170,
              child: BlocConsumer<ChatsCubit, ChatsState>(
                listener: (context, state) {
                  if (state.status == RequestStatus.error) {
                    AppMessages.showError(context, state.error);
                  }
                },
                builder: (context, state) {
                  return CustomSkeletonWidget(
                      isLoading: state.status == RequestStatus.loading &&
                          state.chats.isEmpty,
                      child: state.chats.isEmpty &&
                              state.status == RequestStatus.loading
                          ? _buildLoading()
                          : state.status == RequestStatus.error &&
                                  state.chats.isEmpty
                              ? Center(
                                  key: UniqueKey(),
                                  child: Text(state.error),
                                )
                              : state.chats.isEmpty
                                  ? Center(
                                      key: UniqueKey(),
                                      child: const Text("لا يوجد محادثات"),
                                    )
                                  : ListView.builder(
                                      key: UniqueKey(),
                                      itemBuilder: (_, index) {
                                        return CustomCardWithChatHome(
                                          isOnline: state.onlineUsers.contains(
                                              state.chats[index].user.id),
                                          chat: state.chats[index],
                                        );
                                      },
                                      // separatorBuilder: separatorBuilder,
                                      itemCount: state.chats.length,
                                    )
                      //  switch (state.status) {
                      //   RequestStatus.loading => _buildLoading(),
                      //   RequestStatus.success => state.chats.isEmpty
                      //       ? Center(
                      //           key: UniqueKey(),
                      //           child: const Text("لا يوجد محادثات"),
                      //         )
                      //       : ListView.builder(
                      //           key: UniqueKey(),
                      //           itemBuilder: (_, index) => CustomCardWithChatHome(
                      //             isOnline: state.onlineUsers
                      //                 .contains(state.chats[index].user.id),
                      //             chat: state.chats[index],
                      //           ),
                      //           // separatorBuilder: separatorBuilder,
                      //           itemCount: state.chats.length,
                      //         ),
                      //   RequestStatus.error => Center(
                      //       key: UniqueKey(),
                      //       child: Text(state.error),
                      //     ),
                      //   _ => SizedBox.shrink(
                      //       key: UniqueKey(),
                      //     ),
                      // },
                      );
                },
              ),
            ),
            const Spacer(),
            const CustomBottomNav(),
          ],
        ),
      ),
    );
  }

  ListView _buildLoading() {
    return ListView.builder(
      key: UniqueKey(),
      itemBuilder: (_, __) => CustomCardWithChatHome(
        isOnline: false,
        isLoading: true,
        chat: Chat.fromJson({
          "firstname": "s" * (Random().nextInt(10) + 2),
          "lasttname": "s" * (Random().nextInt(10) + 2),
          "phone": "s" * (Random().nextInt(20) + 2),
          "lastMessage": {
            "text": "s" * (Random().nextInt(100) + 1),
          },
        }),
      ),
      // separatorBuilder: separatorBuilder,
      itemCount: 10,
    );
  }
}

class CustomCardWithChatHome extends StatelessWidget {
  final Chat chat;
  final bool isOnline, isLoading;
  const CustomCardWithChatHome({
    super.key,
    required this.chat,
    required this.isOnline,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        debugPrint("chat phone: ${chat.user.phone}");
        debugPrint("chat phone2: ${chat.phone.phone}");

        context.pushNamed(
          AppRoutes.chat,
          arguments: chat.user,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xFFD2D2D2)))),
        child: Row(
          children: [
            Stack(
              children: [
                UserAvatar(
                  url: chat.user.profileImage ?? '',
                  isLoading: isLoading,
                ),
                // CircleAvatar(
                //   maxRadius: 30,
                //   backgroundColor: Colors.grey.shade200,
                //   foregroundImage:
                //       CachedNetworkImageProvider(user.profileImage ?? ''),
                //   child: isLoading ? null : SvgPicture.asset(AppIcons.profile),
                // ),
                if (isOnline)
                  Positioned(
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
                  )
              ],
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${chat.user.firstName} ${chat.user.lastName}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).focusColor,
                      fontSize: 16,
                      fontFamily: 'Noor',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      chat.lastMessage.senderId == UserHelper.user?.id
                          ? "انت: ${chat.lastMessage.text}"
                          : chat.lastMessage.text,
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).focusColor,
                        fontSize: 13,
                        fontFamily: 'Noor',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
