import 'package:go_router/go_router.dart';

import '../models/employee_model.dart';
import '../modules/details/presentation/details_screen.dart';
import '../modules/home/presentation/home_screen.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),

      GoRoute(
        path: '/details',
        builder: (context, state) {
          final employee = state.extra as Employee;
          return DetailsScreen(employee: employee);
        },
      ),
    ],
  );

}