import 'package:go_router/go_router.dart';
import 'package:machine_test_rearrange/rearrange/presentation/pages/home.dart';
import 'package:machine_test_rearrange/rearrange/presentation/pages/rearrange_screen.dart';
import 'package:machine_test_rearrange/rearrange/presentation/router/app_pages.dart';

class AppRouter {
  static GoRouter createRoute() {
    return GoRouter(initialLocation: AppPages.home, routes: [
      GoRoute(
          path: AppPages.home,
          name: AppPages.home,
          builder: (context, state) {
            return const HomeScreen();
          }),
      GoRoute(
          path: AppPages.reArrange,
          name: AppPages.reArrange,
          builder: (context, state) {
            return const ReArrangeScreen();
          })
    ]);
  }
}
