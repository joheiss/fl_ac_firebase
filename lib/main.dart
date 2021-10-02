import 'package:ac_firebase/l10n/l10n.dart';
import 'package:flutter/material.dart';

import 'pages/home_page.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      primarySwatch: Colors.lightBlue,
    );
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme.copyWith(
        colorScheme: const ColorScheme.dark(secondary: Colors.black),
      ),
      supportedLocales: L10n.all,
      localizationsDelegates: L10n.localizationsDelegates,
      home: const HomePage(title: 'Home Page'),
    );
  }
}
