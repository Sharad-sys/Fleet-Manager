import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tester/features/auth/cubit/auth_cubit.dart';
import 'package:tester/features/auth/cubit/auth_state.dart';
import 'package:tester/features/map/application/map_cubit.dart';
import 'package:tester/features/map/application/map_state.dart';
import 'package:tester/features/map/presentation/widgets/simulate_location_button.dart';
import 'package:tester/features/transport/application/transport_cubit.dart';
import 'package:tester/features/transport/application/transport_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Set<int> acceptedRequests = {};
  bool isProcessing = false;

  @override
  void initState() {
    context.read<MapCubit>().getTransportDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: () {
              context.go('/history', extra: {'staffId': 2});
            },
            icon: const Icon(Icons.history),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthCubit>().logout(),
          ),
        ],
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          if (authState is AuthAuthenticated) {
            return BlocListener<TransportCubit, TransportState>(
              listener: (context, state) {
                if (state is TransportActionInProgress) {
                  setState(() => isProcessing = true);
                } else {
                  setState(() => isProcessing = false);
                }

                if (state is TransportActionSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Request ${state.action} successfully'),
                    ),
                  );
                  if (state.action == 'accepted') {
                    setState(() => acceptedRequests.add(state.transportId));
                  }
                  if (state.action == 'rejected') {
                    context.read<MapCubit>().removeTransport(state.transportId);
                  }
                } else if (state is TransportActionFailure) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Welcome, ${authState.user.name} 👋',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              context.read<MapCubit>().getTransportDetails(),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Fetch Pending Transport Requests'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(45),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: BlocBuilder<MapCubit, MapState>(
                          builder: (context, mapState) {
                            if (mapState is MapLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (mapState is MapLoaded) {
                              final filteredTransports = mapState.transportList
                                  .where(
                                    (t) =>
                                        t.status != 'completed' &&
                                        t.status != 'cancelled',
                                  )
                                  .toList();

                              if (filteredTransports.isEmpty) {
                                return const Center(
                                  child: Text(
                                    'No transport requests available.',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                );
                              }

                              return ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: filteredTransports.length,
                                itemBuilder: (context, index) {
                                  final transport = filteredTransports[index];
                                  final isAccepted = acceptedRequests.contains(
                                    transport.id,
                                  );
                                  final isAlreadyAccepted =
                                      transport.isAccepted;
                                  final status = transport.status;
                                  final vehicleId = transport.vehicleId!;

                                  return Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    margin: const EdgeInsets.only(bottom: 16),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            title: Text(
                                              transport.description,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            subtitle: Text(
                                              'Assigned by: Admin',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'From: ${transport.originLat}, ${transport.originLng}',
                                          ),
                                          Text(
                                            'To: ${transport.destinationLat}, ${transport.destinationLng}',
                                          ),
                                          const SizedBox(height: 12),
                                          if (!isAccepted && !isAlreadyAccepted)
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                TextButton.icon(
                                                  onPressed: () => context
                                                      .read<TransportCubit>()
                                                      .rejectRequest(
                                                        transport.id,
                                                      ),

                                                  icon: const Icon(
                                                    Icons.cancel,
                                                    color: Colors.red,
                                                  ),
                                                  label: const Text(
                                                    'Reject',
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                ElevatedButton.icon(
                                                  onPressed: () => context
                                                      .read<TransportCubit>()
                                                      .acceptRequest(
                                                        transport.id,
                                                      ),
                                                  icon: const Icon(Icons.check),
                                                  label: const Text('Accept'),
                                                ),
                                              ],
                                            )
                                          else if (status == 'cancelled')
                                            Row(
                                              children: [
                                                const Text(
                                                  'Request Rejected',
                                                  style: TextStyle(
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            )
                                          else ...[
                                            const Text(
                                              'Request Accepted ✅',
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            SimulateLocationButton(
                                              pointALat: transport.originLat,
                                              pointALong: transport.originLng,
                                              pointBLat:
                                                  transport.destinationLat,
                                              pointBLong:
                                                  transport.destinationLng,
                                              transportId: transport.id,
                                              vehicleId: vehicleId,
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  if (isProcessing)
                    Container(
                      color: Colors.black.withOpacity(0.4),
                      child: const Center(child: CircularProgressIndicator()),
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
