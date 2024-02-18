import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:terra_flutter_bridge/models/enums.dart';
import 'package:terra_flutter_bridge/terra_flutter_bridge.dart';
import 'package:treehacks_app/connection_cubit.dart';
import 'package:treehacks_app/party_screen.dart';
import 'package:treehacks_app/pin_input.dart';

class JoinPartyScreenRoute extends CupertinoPageRoute<void> {
  JoinPartyScreenRoute()
      : super(
          builder: (context) {
            return const JoinPartyScreen();
          },
        );
}

class JoinPartyScreen extends StatefulWidget {
  const JoinPartyScreen({super.key});

  @override
  State<JoinPartyScreen> createState() => _JoinPartyScreenState();
}

class _JoinPartyScreenState extends State<JoinPartyScreen> {
  final TextEditingController _partyCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    TerraFlutter.initTerra('devID', 'referenceID').then((_) {
      TerraFlutter.initConnection(
        Connection.appleHealth,
        'token',
        true,
        [CustomPermission.heartRate, CustomPermission.steps],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    final partyCode = _partyCodeController.text;
                    print('DEBUG tapped 1, length: ${partyCode.length}');
                    if (partyCode.length != 4) {
                      return;
                    }

                    print('DEBUG tapped 2');
                    await context.read<ConnectionCubit>().connect(partyCode);

                    if (!context.mounted) {
                      return;
                    }

                    await Navigator.of(context).pushReplacement(
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
  }
}
