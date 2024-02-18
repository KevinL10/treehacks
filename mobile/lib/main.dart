import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treehacks_app/connection_cubit.dart';
import 'package:treehacks_app/join_party_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ConnectionCubit>(
      create: (context) => ConnectionCubit(
        url: Platform.isAndroid
            ? 'ws://10.0.2.2:8000/ws'
            : 'ws://localhost:8000/ws',
      ),
      child: const CupertinoApp(
        title: 'Secret TreeHacks X project',
        theme: CupertinoThemeData(),
        home: JoinPartyScreen(),
        localizationsDelegates: [
          DefaultMaterialLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
      ),
    );
  }
}
