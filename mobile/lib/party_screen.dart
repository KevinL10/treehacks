import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:treehacks_app/join_party_screen.dart';

class PartyScreenRoute extends CupertinoPageRoute {
  PartyScreenRoute({required this.partyCode})
      : super(builder: (BuildContext context) {
          return PartyScreen(partyCode: partyCode);
        });

  final String partyCode;
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
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              const Text(
                'party code:',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              Text(
                partyCode,
                style: const TextStyle(
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
