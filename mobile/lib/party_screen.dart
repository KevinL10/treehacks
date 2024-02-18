import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treehacks_app/connection_cubit.dart';

// class PartyScreenRoute extends CupertinoPageRoute<void> {
//   PartyScreenRoute()
//       : super(
//           builder: (context) {
//             return PartyScreen(partyCode: partyCode);
//           },
//         );

//   final String partyCode;
// }

class PartyScreen extends StatefulWidget {
  const PartyScreen({super.key});

  @override
  State<PartyScreen> createState() => _PartyScreenState();
}

class _PartyScreenState extends State<PartyScreen> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      print('DEBUG: timer is ticking at ${DateTime.now()}');
      context.read<ConnectionCubit>().submitData(<String, dynamic>{
        'heart_rate': 69,
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
            onChanged: (value) {
              print('DEBUG: value is $value');
            },
          ),
        ),
        CupertinoActionSheetAction(
          child: const Text('Submit'),
          onPressed: () {
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
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Party Screen'),
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
                Connected _ => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 32),
                      const Text(
                        'party code:',
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      const Text(
                        'widget.partyCode',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'heart rate:',
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
                      const Text(
                        'position in leaderboard',
                        style: TextStyle(fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                      const Text(
                        '7',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
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
              };
            },
          ),
        ),
      ),
    );
  }
}
