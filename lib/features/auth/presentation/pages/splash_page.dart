import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tester/features/auth/cubit/auth_state.dart';
import '../../cubit/auth_cubit.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    print('SplashPage: initState called');
    // Check authentication status when app starts
    context.read<AuthCubit>().checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          print('SplashPage: State changed to: $state');

          // Handle navigation based on auth state
          if (state is AuthAuthenticated) {
            print('SplashPage: User authenticated, navigating to home');
            context.go('/home');
          } else if (state is AuthUnauthenticated) {
            print('SplashPage: User not authenticated, navigating to login');
            context.go('/login');
          }
        },
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            print('SplashPage: Building with state: $state');
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.fire_truck, size: 80, color: Colors.white),
                  SizedBox(height: 24),
                  Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
