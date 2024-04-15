import 'package:flutter/cupertino.dart';
import 'package:page_transition/page_transition.dart';
import 'package:stravaclone/features/presentation/pages/home/home.dart';

import '../features/presentation/pages/unknown_page.dart';

class Routes {
  static dynamic routes() {
    return {
      'HomePage': (context) => const HomePage(),
    };
  }
  static Route? onGenerateRoute(RouteSettings settings) {
    List<String> pathElements = settings.name!.split('/');
    if (pathElements[0] == '' || pathElements.length == 1) {
      return null;
    }
    switch(pathElements[1]) {

    }
    return null;
  }
  static Route? onUnknownRoute(RouteSettings settings) {
    return PageTransition(child: const UnknownPage(), type: PageTransitionType.bottomToTop, settings: settings);
  }
}