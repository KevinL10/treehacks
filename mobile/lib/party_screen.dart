import 'dart:async';

import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treehacks_app/connection_cubit.dart';

class PartyScreen extends StatefulWidget {
  const PartyScreen({super.key});

  @override
  State<PartyScreen> createState() => _PartyScreenState();
}

class _PartyScreenState extends State<PartyScreen> {
  final songTextEditingController = TextEditingController();
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      context.read<ConnectionCubit>().submitData(<String, dynamic>{
        'heartrate': 69,
        'step_count': 2137,
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Widget _modalBuilder(BuildContext context) {
    return CupertinoActionSheet(
      title: const Text('You win!', style: TextStyle(fontSize: 24)),
      message: const Text('You have the most steps! 🎉'),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: CupertinoTextField.borderless(
            autocorrect: false,
            textAlign: TextAlign.center,
            placeholder: 'Request the next song',
            controller: songTextEditingController,
          ),
        ),
        CupertinoActionSheetAction(
          child: const Text('Submit'),
          onPressed: () {
            context
                .read<ConnectionCubit>()
                .setSong(songTextEditingController.text);
            Navigator.pop(context);
          },
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: const Text('Cancel', style: TextStyle(color: Colors.red)),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocPresentationListener<ConnectionCubit, ConnectionCubitEvent>(
      listener: (context, event) {
        switch (event) {
          case ShowWinDialog():
            showCupertinoModalPopup<void>(
              context: context,
              builder: _modalBuilder,
            );
        }
      },
      child: CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('party time'),
        ),
        child: SafeArea(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(24),
            child: BlocBuilder<ConnectionCubit, ConnState>(
              builder: (context, state) {
                return switch (state) {
                  NotConnected _ => const Text('Not connected'),
                  InProgress _ => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  final Connected c => switch (c.uiState) {
                      UiState.waiting => const Center(
                          child: Text('waiting for party to start...'),
                        ),
                      UiState.starting || UiState.finished => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 32),
                            const Text(
                              'party code',
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              c.roomId.toString(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),
                            const Text(
                              'heart rate',
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                            const Text(
                              '142 bpm',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),
                            if (state.placement != null) ...[
                              const Text(
                                'position in leaderboard',
                                style: TextStyle(fontSize: 24),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                state.placement.toString(),
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                            const Spacer(),
                            CupertinoButton(
                              onPressed: () {
                                showCupertinoModalPopup<void>(
                                  context: context,
                                  builder: _modalBuilder,
                                );
                              },
                              child: const Text('simulate "you win"'),
                            ),
                            CupertinoButton(
                              color: Colors.red,
                              onPressed: () {
                                context.read<ConnectionCubit>().leaveParty();
                              },
                              child: const Text('Leave Party'),
                            ),
                          ],
                        ),
                    },
                };
              },
            ),
          ),
        ),
      ),
    );
  }
}
