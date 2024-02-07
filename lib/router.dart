import 'package:custom_bottomnavigation/custom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(initialLocation: '/', routes: <RouteBase>[
  GoRoute(
    path: '/',
    builder: (BuildContext context, GoRouterState state) {
      return Scaffold(
        backgroundColor: Colors.blue[50],
        body: Center(
            child: ElevatedButton(
                onPressed: () {
                  context.go('/home');
                },
                child: Text('start'))),
      );
    },
  ),
  ShellRoute(
    builder: (BuildContext context, GoRouterState state, Widget child) {
      void handleOnTap(i) {
        print('Tapped :$i');
        switch (i) {
          case 0:
            context.go('/home');
            break;
          case 1:
            context.go('/search');
            break;
          case 2:
            context.go('/notification');
            break;
          case 3:
            context.go('/account');
            break;
          case 4:
            context.go('/settings');
            break;
        }
      }

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[100],
          title: Text('Custom NavBar Demo'),
        ),
        body: Stack(
          children: [
            child,
            CustomNavigation(
              onTap: handleOnTap,
            )
          ],
        ),
      );
    },
    routes: [
      GoRoute(
        path: '/home',
        builder: (BuildContext context, GoRouterState state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('home'),
                ElevatedButton(
                  onPressed: () {
                    context.go('/');
                  },
                  child: Text('Start'),
                ),
              ],
            ),
          );
        },
      ),
      GoRoute(
        path: '/search',
        builder: (BuildContext context, GoRouterState state) {
          return Center(child: Text('search'));
        },
      ),
      GoRoute(
        path: '/notification',
        builder: (BuildContext context, GoRouterState state) {
          return Center(child: Text('notification'));
        },
      ),
      GoRoute(
        path: '/account',
        builder: (BuildContext context, GoRouterState state) {
          return Center(child: Text('account'));
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (BuildContext context, GoRouterState state) {
          return Center(child: Text('settings'));
        },
      ),
      // 他の子ルートをここに追加
    ],
  ),
]);
