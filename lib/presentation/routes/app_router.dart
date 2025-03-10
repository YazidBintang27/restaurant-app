import 'package:go_router/go_router.dart';
import 'package:restaurant_app/presentation/pages/detail.dart';
import 'package:restaurant_app/presentation/pages/main.dart';
import 'package:restaurant_app/presentation/pages/setting.dart';
import 'package:restaurant_app/presentation/pages/splash.dart';

class AppRouter {
  static final GoRouter router = GoRouter(initialLocation: '/splash', routes: [
    GoRoute(path: '/splash', builder: (context, state) => const Splash()),
    GoRoute(
      path: '/main',
      builder: (context, state) => const Main(),
    ),
    GoRoute(
        path: '/detail/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return Detail(id: id);
        }),
    GoRoute(path: '/setting', builder: (context, state) => const Setting())
  ]);
}
