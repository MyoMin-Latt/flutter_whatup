import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_ui/common/widgets/loader.dart';
import 'package:whatsapp_ui/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_ui/widgets/my_message_card.dart';
import 'package:whatsapp_ui/widgets/sender_message_card.dart';

import '../../../models/message.dart';

class ChatList extends ConsumerStatefulWidget {
  const ChatList({super.key, required this.receiverUserId});

  final String receiverUserId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final messageController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
        stream:
            ref.read(chatControllerProvider).chatStream(widget.receiverUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            messageController
                .jumpTo(messageController.position.maxScrollExtent);
          });
          return ListView.builder(
            controller: messageController,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final messageData = snapshot.data![index];
              var timeSent = DateFormat.Hm().format(messageData.timeSent);
              if (messageData.senderId ==
                  FirebaseAuth.instance.currentUser!.uid) {
                return MyMessageCard(
                  message: messageData.text,
                  date: timeSent,
                );
              }
              return SenderMessageCard(
                message: messageData.text,
                date: timeSent,
              );
            },
          );
        });
  }
}


// class ChatList extends ConsumerWidget {
//   const ChatList({Key? key, required this.receiverUserId}) : super(key: key);

//   final String receiverUserId;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return StreamBuilder<List<Message>>(
//         stream: ref.read(chatControllerProvider).chatStream(receiverUserId),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Loader();
//           }
//           return ListView.builder(
//             itemCount: snapshot.data!.length,
//             itemBuilder: (context, index) {
//               final messageData = snapshot.data![index];
//               var timeSent = DateFormat.Hm().format(messageData.timeSent);
//               if (messageData.senderId ==
//                   FirebaseAuth.instance.currentUser!.uid) {
//                 return MyMessageCard(
//                   message: messageData.text,
//                   date: timeSent,
//                 );
//               }
//               return SenderMessageCard(
//                 message: messages[index]['text'].toString(),
//                 date: messages[index]['time'].toString(),
//               );
//             },
//           );
//         });
//   }
// }
