import 'package:custom_bottomnavigation/custom_navigation.dart';
import 'package:custom_bottomnavigation/navigation_items.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(initialLocation: '/', routes: <RouteBase>[
  GoRoute(
    path: '/',
    builder: (BuildContext context, GoRouterState state) {
      return Scaffold(
        backgroundColor: Colors.blue[300],
        body: Center(
            child: ElevatedButton(
                onPressed: () {
                  context.go(NavigationItems.home.route);
                },
                child: const Text('start'))),
      );
    },
  ),

  /// bottomNavigationBar Route
  ShellRoute(
    builder: (BuildContext context, GoRouterState state, Widget child) {
      /// tap callback & navigation
      void handleOnTap(tappedIndex) {
        for (NavigationItems item in NavigationItems.values) {
          if (tappedIndex == item.index) {
            context.go(item.route);
          }
        }
      }

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[100],
          title: const Text('Custom NavBar Demo'),
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('home'),
                ElevatedButton(
                  onPressed: () {
                    context.go('/');
                  },
                  child: const Text('Go To Top Page'),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        },
      ),
      GoRoute(
        path: '/search',
        builder: (BuildContext context, GoRouterState state) {
          return const Center(child: Text('search'));
        },
      ),
      GoRoute(
        path: '/notification',
        builder: (BuildContext context, GoRouterState state) {
          return const Center(child: Text('notification'));
        },
      ),
      GoRoute(
        path: '/account',
        builder: (BuildContext context, GoRouterState state) {
          return const Center(child: Text('account'));
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (BuildContext context, GoRouterState state) {
          return const Center(child: Text('settings'));
        },
      ),
    ],
  ),
]);
