import 'package:flutter/material.dart';
import 'welcome.dart';
import 'discover.dart';
import 'destinationDetail.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Wanderly',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, fontFamily: 'Roboto'),
      routerDelegate: AppRouterDelegate(),
      routeInformationParser: AppRouteInformationParser(),
      backButtonDispatcher: RootBackButtonDispatcher(),
    );
  }
}

// ============================================================
// 1. Route path definitions
//    These are the "app states" Navigator 2.0 moves between.
// ============================================================

abstract class AppRoutePath {
  const AppRoutePath();
}

class WelcomeRoutePath extends AppRoutePath {
  const WelcomeRoutePath();
}

class DiscoverRoutePath extends AppRoutePath {
  const DiscoverRoutePath();
}

class DetailRoutePath extends AppRoutePath {
  final String destinationId;
  const DetailRoutePath(this.destinationId);
}

// ============================================================
// 2. RouteInformationParser
//    Converts a URL/deep-link (RouteInformation) into an
//    AppRoutePath, and back again. This is what lets the app
//    understand a link like /destination/kungliga-slottet.
// ============================================================

class AppRouteInformationParser extends RouteInformationParser<AppRoutePath> {
  @override
  Future<AppRoutePath> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = routeInformation.uri;

    if (uri.pathSegments.isEmpty) {
      return const WelcomeRoutePath();
    }

    if (uri.pathSegments.length == 1 && uri.pathSegments[0] == 'discover') {
      return const DiscoverRoutePath();
    }

    if (uri.pathSegments.length == 2 && uri.pathSegments[0] == 'destination') {
      return DetailRoutePath(uri.pathSegments[1]);
    }

    // Unknown path -> fall back to welcome.
    return const WelcomeRoutePath();
  }

  @override
  RouteInformation restoreRouteInformation(AppRoutePath configuration) {
    if (configuration is DiscoverRoutePath) {
      return RouteInformation(uri: Uri.parse('/discover'));
    }
    if (configuration is DetailRoutePath) {
      return RouteInformation(uri: Uri.parse('/destination/${configuration.destinationId}'));
    }
    // WelcomeRoutePath (and anything else) maps to '/'.
    return RouteInformation(uri: Uri.parse('/'));
  }
}

// ============================================================
// 3. RouterDelegate
//    Owns the current AppRoutePath and builds the Navigator's
//    page stack from it. All in-app navigation goes through the
//    goTo... / goBack methods below, which mutate _currentPath
//    and call notifyListeners() to trigger a rebuild.
// ============================================================

class AppRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  AppRoutePath _currentPath = const WelcomeRoutePath();
  Destination? _selectedDestination;

  @override
  AppRoutePath get currentConfiguration => _currentPath;

  // ---- Navigation actions called from the UI screens ----

  void goToDiscover() {
    _currentPath = const DiscoverRoutePath();
    notifyListeners();
  }

  void goToDetail(Destination destination) {
    _selectedDestination = destination;
    _currentPath = DetailRoutePath(destination.id);
    notifyListeners();
  }

  void goBack() {
    if (_currentPath is DetailRoutePath) {
      _currentPath = const DiscoverRoutePath();
    } else if (_currentPath is DiscoverRoutePath) {
      _currentPath = const WelcomeRoutePath();
    }
    notifyListeners();
  }

  // ---- Required by RouterDelegate ----

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {
    _currentPath = configuration;
    if (configuration is DetailRoutePath && _selectedDestination == null) {
      _selectedDestination = sampleDestinations.firstWhere(
        (d) => d.id == configuration.destinationId,
        orElse: () => sampleDestinations.first,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;
        goBack();
        return true;
      },
      pages: _buildPages(),
    );
  }

  List<Page> _buildPages() {
    final pages = <Page>[
      MaterialPage(
        key: const ValueKey('WelcomePage'),
        child: WelcomeScreen(onGetStarted: goToDiscover),
      ),
    ];

    if (_currentPath is DiscoverRoutePath || _currentPath is DetailRoutePath) {
      pages.add(
        MaterialPage(
          key: const ValueKey('DiscoverPage'),
          child: DiscoverScreen(onSelectDestination: goToDetail),
        ),
      );
    }

    if (_currentPath is DetailRoutePath && _selectedDestination != null) {
      pages.add(
        MaterialPage(
          key: ValueKey('DetailPage-${_selectedDestination!.id}'),
          child: DestinationDetailScreen(
            destination: _selectedDestination!,
            onBack: goBack,
          ),
        ),
      );
    }

    return pages;
  }
}