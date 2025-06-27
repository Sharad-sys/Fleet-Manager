import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tester/core/theme/theme.dart';
import 'package:tester/features/history/application/cubit/history_cubit.dart';
import 'package:tester/features/home/application/cubit/stats_cubit.dart';
import 'package:tester/features/home/application/profileCubit/profile_cubit.dart';
import 'package:tester/features/map/application/map_cubit.dart';
import 'package:tester/features/transport/application/transport_cubit.dart';
import 'features/auth/services/auth_api_service.dart';
import 'features/auth/repositories/auth_repository.dart';
import 'features/auth/cubit/auth_cubit.dart';
import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthApiService().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(authRepository: AuthRepository()),
        ),
        BlocProvider(
          create: (context) => MapCubit(authRepository: AuthRepository()),
        ),
        BlocProvider(
          create: (context) => TransportCubit(authRepository: AuthRepository()),
        ),
        BlocProvider(
          create: (context) => HistoryCubit(authRepository: AuthRepository()),
        ),
         BlocProvider(
          create: (context) => StatsCubit(authRepository: AuthRepository()),
        ),
         BlocProvider(
          create: (context) => ProfileCubit(authRepository: AuthRepository()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Fleet Manager',
        theme: fleetDarkTheme,
        routerConfig: AppRouter.createRouter(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
