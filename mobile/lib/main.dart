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
            ? 'http://10.0.2.2:8000'
            : 'http://localhost:8000',
      ),
      child: CupertinoApp(
        title: 'Secret TreeHacks X project',
        theme: const CupertinoThemeData(),
        home: JoinPartyScreen(),
        localizationsDelegates: const [
          DefaultMaterialLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
      ),
    );
  }
}
