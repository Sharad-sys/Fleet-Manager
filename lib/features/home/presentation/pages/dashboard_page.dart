import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tester/features/auth/cubit/auth_cubit.dart';
import 'package:tester/features/auth/cubit/auth_state.dart';
import 'package:tester/features/home/presentation/pages/home_page.dart';
import 'package:tester/features/home/presentation/pages/stats_page.dart';
import 'package:tester/features/home/presentation/widgets/bottom_nav_bar.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    Center(child: HomePage()),
    Center(child: StatsPage()),
  ];

  void _onTappedItem(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => context.go('/history'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthCubit>().logout(),
          ),
        ],
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            return IndexedStack(index: _currentIndex, children: _screens);
          } else if (state is AuthUnauthenticated) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => context.go('/login'),
            );
            return const SizedBox();
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTappedItem,
      ),
    );
  }
}
