import 'package:ac_firebase/widgets/message_add.dart';
import 'package:ac_firebase/widgets/messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatPage extends StatefulWidget {
  static const chatCollection = 'chats/4n5emtMyDM6knvL2UGGM/messages';

  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var _first = true;

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((msg) => print('[DEBUG] => The message is $msg'));
    FirebaseMessaging.onMessageOpenedApp.listen((msg) => print('[DEBUG] => The launch message is $msg'));
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    // ask for permission to receive push messages (only needed for IOS)
    if (_first) {
      _first = false;
      final fcm = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      FirebaseMessaging.instance.subscribeToTopic('ac_firebase');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.chatPageTitle ?? 'Chat'),
        actions: [
          // IconButton(
          //   onPressed: _addMessage,
          //   icon: const Icon(Icons.add, color: Colors.white),
          // ),
          IconButton(
            onPressed: () => FirebaseAuth.instance.signOut(),
            icon: const Icon(Icons.logout),
          ),
          // DropdownButton(
          //  underline: const Container(),
          //   elevation: 0,
          //   icon: const Icon(Icons.more_vert),
          //   items: [
          //     DropdownMenuItem(
          //       child: Row(
          //         mainAxisSize: MainAxisSize.min,
          //         children: [
          //           const Icon(Icons.exit_to_app),
          //           const SizedBox(width: 8),
          //           Text(l10n?.logoutButton ?? 'Logout'),
          //         ],
          //       ),
          //       value: 'logout',
          //     )
          //   ],
          //   onChanged: (val) => val == 'logout' ? FirebaseAuth.instance.signOut() : null,
          // ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      child: Column(
        children: const [
          Expanded(child: Messages()),
          MessageAdd(),
        ],
      ),
    );
  }

  void _addMessage() {
    FirebaseFirestore.instance.collection(ChatPage.chatCollection).add({
      'text': 'I have added this message at ${DateTime.now().toIso8601String()}',
    });
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('[DEBUG] => Handling a background message ${message.messageId}');
}
