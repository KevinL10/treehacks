import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:terra_flutter_bridge/models/enums.dart';
import 'package:terra_flutter_bridge/terra_flutter_bridge.dart';
import 'package:treehacks_app/connection_cubit.dart';
import 'package:treehacks_app/pin_input.dart';

// class JoinPartyScreenRoute extends CupertinoPageRoute<void> {
//   JoinPartyScreenRoute()
//       : super(
//           builder: (context) {
//             return const JoinPartyScreen();
//           },
//         );
// }

class JoinPartyScreen extends StatefulWidget {
  const JoinPartyScreen({super.key});

  @override
  State<JoinPartyScreen> createState() => _JoinPartyScreenState();
}

class _JoinPartyScreenState extends State<JoinPartyScreen> {
  final TextEditingController _partyCodeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 108),
                const Text('enter party code', textAlign: TextAlign.center),
                const SizedBox(height: 32),
                FractionallySizedBox(
                  widthFactor: 0.9,
                  child: PinInput(
                    textEditingController: _partyCodeController,
                    onChanged: (newValue) {
                      _partyCodeController.text = newValue;
                      setState(() {});
                    },
                    onCompleted: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                  ),
                ),
                const SizedBox(height: 72),
                if (_partyCodeController.text.length == 4) ...[
                  const Text('enter your name', textAlign: TextAlign.center),
                  const SizedBox(height: 32),
                  FractionallySizedBox(
                    widthFactor: 0.9,
                    child: CupertinoTextField(
                      autocorrect: false,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 28),
                      controller: _nameController,
                      padding: const EdgeInsets.all(16),
                      onChanged: (newValue) {
                        _nameController.text = newValue;
                      },
                    ),
                  ),
                ],
                const Spacer(),
                CupertinoButton.filled(
                  onPressed: () async {
                    final partyCode = _partyCodeController.text;
                    final name = _nameController.text;
                    if (partyCode.length != 4 || name.isEmpty) {
                      return;
                    }

                    await context.read<ConnectionCubit>().connect(
                          roomId: int.parse(partyCode),
                          name: name,
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
