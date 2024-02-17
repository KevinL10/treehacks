import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:treehacks_app/join_party_screen.dart';

class PartyScreenRoute extends CupertinoPageRoute {
  PartyScreenRoute({required this.partyCode})
      : super(builder: (BuildContext context) {
          return PartyScreen(partyCode: partyCode);
        });

  final String partyCode;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return PartyScreen(partyCode: partyCode);
  }
}

class PartyScreen extends StatelessWidget {
  final String partyCode;

  const PartyScreen({super.key, required this.partyCode});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Party Screen'),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              const Text(
                'party code:',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                partyCode,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'heart rate:',
                style: TextStyle(fontSize: 20),
              ),
              const Text(
                '142 bpm',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'position in leaderboard',
                style: TextStyle(fontSize: 24),
              ),
              const Text(
                '7',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              CupertinoButton(
                color: Colors.red,
                onPressed: () {
                  Navigator.of(context).pushReplacement(JoinPartyScreenRoute());
                },
                child: const Text('Leave Party'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
