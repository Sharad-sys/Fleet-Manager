import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:tester/features/auth/cubit/auth_state.dart';
import 'package:tester/features/map/presentation/map_screen.dart';
import '../../features/auth/cubit/auth_cubit.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';

class AppRouter {
  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: '/',
      redirect: (context, state) {
        final authCubit = context.read<AuthCubit>();
        final authState = authCubit.state;

        print('Router: Current location: ${state.matchedLocation}');
        print('Router: Auth state: $authState');

        if (authState is AuthLoading) {
          print('Router: Still loading, staying on splash');
          return null;
        }

        if (authState is AuthAuthenticated) {
          if (state.matchedLocation != '/home' &&
              state.matchedLocation != '/map') {
            print('Router: Authenticated, redirecting to /home');
            return '/home';
          }
          return null;
        }

        if (authState is AuthUnauthenticated) {
          if (state.matchedLocation == '/') {
            print('Router: Not authenticated, redirecting to /login');
            return '/login';
          }

          return null;
        }

        print('Router: No redirect needed');
        return null;
      },
      routes: [
        GoRoute(path: '/', builder: (context, state) => const SplashPage()),
        GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
        GoRoute(
          path: '/signup',
          builder: (context, state) => const SignupPage(),
        ),
        GoRoute(path: '/home', builder: (context, state) => HomePage()),
        GoRoute(
          path: '/map',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            return MapScreen(
              origin: extra['origin']! as LatLng,
              destination: extra['destination']! as LatLng,
              transportId: extra['transportId']! as int,
            );
          },
        ),
      ],
    );
  }
}
