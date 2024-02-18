import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treehacks_app/app_router.dart';
import 'package:treehacks_app/connection_cubit.dart';

const debugUrl = 'ws://localhost:8000/ws';
const androidDebugUrl = 'ws://10.0.2.2:8000/ws';
const prodUrl = 'wss://terrahacks.fly.dev/ws';

void main() {
  runApp(
    BlocProvider<ConnectionCubit>(
      create: (context) => ConnectionCubit(
        // url: Platform.isAndroid ? androidDebugUrl : debugUrl,
        url: prodUrl,
      ),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter(
      connectionCubit: context.read<ConnectionCubit>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp.router(
      routerConfig: _appRouter,
      title: 'Secret TreeHacks X project',
      theme: const CupertinoThemeData(),
      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
    );
  }
}
