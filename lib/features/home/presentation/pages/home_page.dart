import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tester/features/auth/cubit/auth_state.dart';
import 'package:tester/features/map/application/map_cubit.dart';
import 'package:tester/features/map/application/map_state.dart';
import 'package:tester/features/map/presentation/widgets/simulate_location_button.dart';
import 'package:tester/features/transport/application/transport_cubit.dart';
import 'package:tester/features/transport/application/transport_state.dart';
import '../../../auth/cubit/auth_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Set<int> acceptedRequests = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthCubit>().logout();
            },
          ),
        ],
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          if (authState is AuthAuthenticated) {
            return BlocListener<TransportCubit, TransportState>(
              listener: (context, state) {
                if (state is TransportActionSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Request ${state.action} successfully')),
                  );
                  if (state.action == 'accepted') {
                    setState(() {
                      acceptedRequests.add(state.transportId);
                    });
                  }
                } else if (state is TransportActionFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Welcome, ${authState.user.name}!',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<MapCubit>().getTransportDetails();
                    },
                    child: const Text('Fetch Transport Requests'),
                  ),
                  Expanded(
                    child: BlocBuilder<MapCubit, MapState>(
                      builder: (context, mapState) {
                        if (mapState is MapLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (mapState is MapLoaded &&
                            mapState.transportList.isNotEmpty) {
                          return ListView.builder(
                            itemCount: mapState.transportList.length,
                            itemBuilder: (context, index) {
                              final transport = mapState.transportList[index];
                              final isAccepted = acceptedRequests.contains(transport.id);
                              final status = mapState.transportList[index].status;

                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        transport.description ?? 'No Description',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text('From: ${transport.originLat}, ${transport.originLng}'),
                                      Text('To: ${transport.destinationLat}, ${transport.destinationLng}'),
                                      Text('Assigned By: Admin'),
                                      const SizedBox(height: 12),
                                      if (!isAccepted) ...[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                context
                                                    .read<TransportCubit>()
                                                    .rejectRequest(transport.id);
                                              },
                                              child: const Text(
                                                'Reject',
                                                style: TextStyle(color: Colors.red),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                context
                                                    .read<TransportCubit>()
                                                    .acceptRequest(transport.id);
                                              },
                                              child: const Text('Accept'),
                                            ),
                                          ],
                                        ),
                                      ] else ...[
                                        const Text(
                                          'Request Accepted',
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        SimulateLocationButton(
                                          pointALat: transport.originLat,
                                          pointALong: transport.originLng,
                                          pointBLat: transport.destinationLat,
                                          pointBLong: transport.destinationLng,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        } else if (mapState is MapLoaded &&
                            mapState.transportList.isEmpty) {
                          return const Center(
                            child: Text('No transport requests available.'),
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
