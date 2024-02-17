import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treehacks_app/connection_cubit.dart';
import 'package:treehacks_app/party_screen.dart';
import 'package:treehacks_app/pin_input.dart';

class JoinPartyScreenRoute extends CupertinoPageRoute {
  JoinPartyScreenRoute()
      : super(builder: (BuildContext context) {
          return JoinPartyScreen();
        });
}

class JoinPartyScreen extends StatelessWidget {
  final TextEditingController _partyCodeController = TextEditingController();

  JoinPartyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ConnectionCubit>(
      create: (context) => ConnectionCubit(
          url: Platform.isAndroid
              ? 'ws://10.0.2.2:8000'
              : 'ws://localhost:8000'),
      child: Builder(builder: (context) {
        return CupertinoPageScaffold(
          navigationBar: const CupertinoNavigationBar(
            middle: Text('join party'),
          ),
          child: SafeArea(
            child: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(),
                    const Text('enter party code', textAlign: TextAlign.center),
                    const SizedBox(height: 32),
                    FractionallySizedBox(
                      widthFactor: 0.9,
                      child: PinInput(
                        textEditingController: _partyCodeController,
                        onChanged: (newValue) {
                          _partyCodeController.text = newValue;
                        },
                      ),
                    ),
                    const Spacer(flex: 2),
                    CupertinoButton.filled(
                      onPressed: () async {
                        String partyCode = _partyCodeController.text;
                        print('DEBUG tapped 1, length: ${partyCode.length}');
                        if (partyCode.length != 4) {
                          return;
                        }

                        print('DEBUG tapped 2');
                        await context
                            .read<ConnectionCubit>()
                            .connect(partyCode);
                        if (!context.mounted) return;

                        Navigator.of(context).pushReplacement(
                          PartyScreenRoute(partyCode: partyCode),
                        );
                      },
                      child: const Text('Join'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
