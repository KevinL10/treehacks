import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:treehacks_app/join_party_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Secret TreeHacks X project',
      theme: const CupertinoThemeData(),
      home: JoinPartyScreen(),
      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
    );
  }
}
