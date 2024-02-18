import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:treehacks_app/connection_cubit.dart';
import 'package:treehacks_app/join_party_screen.dart';
import 'package:treehacks_app/party_screen.dart';

export 'package:go_router/go_router.dart';

const joinPartyRouteLocation = '/';
const partyRouteLocation = '/party';

RoutingConfig _generateRoutingConfig() {
  return RoutingConfig(
    routes: <RouteBase>[
      GoRoute(
        path: joinPartyRouteLocation,
        builder: (context, state) => const JoinPartyScreen(),
      ),
      GoRoute(
        path: partyRouteLocation,
        builder: (context, state) {
          return const PartyScreen();
        },
      ),
    ],
  );
}

class AppRouter extends GoRouter {
  AppRouter({
    required ConnectionCubit connectionCubit,
  })  : _connectionCubit = connectionCubit,
        super.routingConfig(
          routingConfig: ValueNotifier(
            _generateRoutingConfig(),
          ),
        ) {
    _subscription = _connectionCubit.stream.listen((_) => _update());
  }

  final ConnectionCubit _connectionCubit;

  StreamSubscription<void>? _subscription;

  void _update() {
    final newLocation = switch (_connectionCubit.state) {
      NotConnected _ => joinPartyRouteLocation,
      InProgress _ => joinPartyRouteLocation,
      Connected _ => partyRouteLocation,
    };

    go(newLocation);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
