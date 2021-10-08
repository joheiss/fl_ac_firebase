import 'package:ac_firebase/pages/chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MessageAdd extends StatefulWidget {
  const MessageAdd({Key? key}) : super(key: key);

  @override
  _MessageAddState createState() => _MessageAddState();
}

class _MessageAddState extends State<MessageAdd> {
  final _controller = TextEditingController();
  var _message = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                autocorrect: true,
                textCapitalization: TextCapitalization.sentences,
                enableSuggestions: true,
                decoration: InputDecoration(labelText: l10n?.messageLabel ?? 'Send a message ...'),
                onChanged: (val) => setState(() => _message = val.trim()),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: _message.isNotEmpty ? _sendMessage : null,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ],
        ));
  }

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final userId = FirebaseAuth.instance.currentUser?.uid;
    FirebaseFirestore.instance
        .collection(ChatPage.chatCollection)
        .add({'text': _message, 'createdAt': Timestamp.now(), 'userId': userId});
    _controller.clear();
  }
}
