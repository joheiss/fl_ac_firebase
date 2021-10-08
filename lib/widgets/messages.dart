import 'package:ac_firebase/pages/chat_page.dart';
import 'package:ac_firebase/widgets/message_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(ChatPage.chatCollection)
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        final messages = snapshot.data.docs;
        final uid = FirebaseAuth.instance.currentUser?.uid.trim();
        print('[DEBUG] => uid: $uid');
        return ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) => MessageItem(
            key: ValueKey(messages[index].id),
            message: messages[index]['text'],
            userId: messages[index]['userId'],
            isMe: messages[index]['userId'].trim() as String == uid as String ? true : false,
          ),
          reverse: true,
        );
      },
    );
  }
}
