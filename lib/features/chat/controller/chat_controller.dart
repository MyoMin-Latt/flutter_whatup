// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/enums/message_enum.dart';
import 'package:whatsapp_ui/common/providers/message_reply_provider.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_ui/models/group.dart';

import '../../../models/chat_contact.dart';
import '../../../models/message.dart';
import '../repository/chat_repository.dart';

final chatControllerProvider = Provider(
  (ref) => ChatController(
      chatRepository: ref.watch(chatRepositoryProvider), ref: ref),
);

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;
  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  Stream<List<ChatContact>> chatContacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<GroupModel>> chatGroups() {
    return chatRepository.getChatGroups();
  }

  Stream<List<Message>> chatStream(String receiverUserId) {
    return chatRepository.getChatStream(receiverUserId);
  }

  void sendTextMessage(
    BuildContext context,
    String text,
    String receiverUserId,
  ) {
    final messageReply = ref.read(messageReplyProvider);

    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendTextMessage(
            context: context,
            text: text,
            receiverUserId: receiverUserId,
            senderUser: value!,
            messageReply: messageReply,
          ),
        );
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  void sendFileMessage(
    BuildContext context,
    File file,
    String receiverUserId,
    MessageEnum messageEnum,
  ) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendFileMessage(
            context: context,
            file: file,
            receiverUserId: receiverUserId,
            senderUserData: value!,
            messageEnum: messageEnum,
            ref: ref,
            messageReply: messageReply,
          ),
        );
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  void sendGIFMessage(
      BuildContext context, String gifUrl, String receiverUserId) {
    int gifUrlPartIndex = gifUrl.lastIndexOf('-') + 1;
    String gifUrlPart = gifUrl.substring(gifUrlPartIndex);
    String newgifUrl = 'https://i.giphy.com/media/$gifUrlPart/200.gif';

    final messageReply = ref.read(messageReplyProvider);

    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendGIFMessage(
            context: context,
            gifUrl: newgifUrl,
            receiverUserId: receiverUserId,
            senderUser: value!,
            messageReply: messageReply,
          ),
        );
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  void setChatMessageSeen(
    BuildContext context,
    String receiverUserId,
    String messageId,
  ) {
    chatRepository.setChatMessageSeen(
      context,
      receiverUserId,
      messageId,
    );
  }
}
