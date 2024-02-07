import 'package:flutter/material.dart';

enum NavigationItems {
  home,
  search,
  notification,
  account,
  settings,
}

extension NavigationContentExtension on NavigationItems {
  IconData get icon {
    switch (this) {
      case NavigationItems.home:
        return Icons.home;
      case NavigationItems.search:
        return Icons.search;
      case NavigationItems.notification:
        return Icons.notifications;
      case NavigationItems.account:
        return Icons.person;
      case NavigationItems.settings:
        return Icons.settings;
      default:
        return Icons.question_mark;
    }
  }

  String get route {
    switch (this) {
      case NavigationItems.home:
        return '/home';
      case NavigationItems.search:
        return '/search';
      case NavigationItems.notification:
        return '/notification';
      case NavigationItems.account:
        return '/account';
      case NavigationItems.settings:
        return '/settings';
    }
  }
}
