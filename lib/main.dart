import 'package:ac_firebase/l10n/l10n.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'pages/auth_page.dart';
import 'pages/chat_page.dart';
import 'pages/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      primarySwatch: Colors.pink,
      backgroundColor: Colors.pink,
      colorScheme: const ColorScheme.dark(
        secondary: Colors.deepPurple,
      ),
      buttonTheme: ButtonTheme.of(context).copyWith(
        buttonColor: Colors.pink,
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
    return MaterialApp(
      title: 'Flutter Chat',
      theme: theme,
      supportedLocales: L10n.all,
      localizationsDelegates: L10n.localizationsDelegates,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashPage();
          }
          if (snapshot.hasData) {
            return const ChatPage();
          }
          return const AuthPage();
        },
      ),
    );
  }
}
