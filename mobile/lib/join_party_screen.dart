import 'package:flutter/cupertino.dart';
import 'package:treehacks_app/party_screen.dart';
import 'package:treehacks_app/pin_input.dart';

class JoinPartyScreenRoute extends CupertinoPageRoute {
  JoinPartyScreenRoute()
      : super(builder: (BuildContext context) {
          return JoinPartyScreen();
        });

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return JoinPartyScreen();
  }
}

class JoinPartyScreen extends StatelessWidget {
  final TextEditingController _partyCodeController = TextEditingController();

  JoinPartyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('join party'),
      ),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                const Text('enter party code'),
                const SizedBox(height: 32),
                FractionallySizedBox(
                  widthFactor: 0.9,
                  child: PinInput(
                    textEditingController: _partyCodeController,
                    onChanged: (newValue) {},
                  ),
                ),
                const Spacer(flex: 2),
                CupertinoButton.filled(
                  onPressed: () async {
                    String partyCode = _partyCodeController.text;
                    if (_partyCodeController.text.length != 4) {
                      return;
                    }

                    await Future.delayed(const Duration(seconds: 1));
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
  }
}
