import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
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
  final Map<int, String> _addressCache = {};

  @override
  void initState() {
    super.initState();
    context.read<MapCubit>().getTransportDetails();
  }

  Future<String> _getAddress(int id, double lat, double lng) async {
    final cacheKey = id;
    if (_addressCache.containsKey(cacheKey)) {
      return _addressCache[cacheKey]!;
    }
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final addr = [
          place.street,
          place.locality,
          place.administrativeArea,
          place.country
        ].where((s) => s != null && s.isNotEmpty).join(', ');
        _addressCache[cacheKey] = addr;
        return addr;
      }
    } catch (e) {
      debugPrint('Geocode error ($id): $e');
    }
    return 'Unknown location';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Dashboard'),
      //   actions: [
      //     IconButton(icon: const Icon(Icons.history), onPressed: () => context.go('/history')),
      //     IconButton(icon: const Icon(Icons.logout), onPressed: () => context.read<AuthCubit>().logout()),
      //   ],
      // ),
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
                    SnackBar(content: Text('Request ${state.action} successfully')),
                  );
                  if (state.action == 'accepted') {
                    setState(() => acceptedRequests.add(state.transportId));
                  }
                  if (state.action == 'rejected') {
                    context.read<MapCubit>().removeTransport(state.transportId);
                  }
                } else if (state is TransportActionFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message))
                  );
                }
              },
              child: Stack(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Welcome, ${authState.user.name} 👋',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ElevatedButton.icon(
                          onPressed: () => context.read<MapCubit>().getTransportDetails(),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Fetch Pending Requests'),
                          style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(45)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: BlocBuilder<MapCubit, MapState>(
                          builder: (context, mapState) {
                            if (mapState is MapLoading) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (mapState is MapLoaded) {
                              final transports = mapState.transportList
                                  .where((t) => t.status != 'completed' && t.status != 'cancelled')
                                  .toList();
                              if (transports.isEmpty) {
                                return const Center(child: Text('No transport requests available.', style: TextStyle(fontSize: 16)));
                              }
                              return ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: transports.length,
                                itemBuilder: (context, i) {
                                  final tr = transports[i];
                                  final isAccepted = acceptedRequests.contains(tr.id);
                                  final status = tr.status;

                                  return Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    margin: const EdgeInsets.only(bottom: 16),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(tr.description, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 8),
                                          FutureBuilder<String>(
                                            future: _getAddress(tr.id, double.parse(tr.originLat), double.parse(tr.originLng)),
                                            builder: (ctx, snap) => Text('From: ${snap.data ?? "Loading..."}'),
                                          ),
                                          const SizedBox(height: 4),
                                          FutureBuilder<String>(
                                            future: _getAddress(-tr.id, double.parse(tr.destinationLat), double.parse(tr.destinationLng)),
                                            builder: (ctx, snap) => Text('To: ${snap.data ?? "Loading..."}'),
                                          ),
                                          const SizedBox(height: 12),
                                          if (!isAccepted && !tr.isAccepted)
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                TextButton.icon(
                                                  onPressed: () => context.read<TransportCubit>().rejectRequest(tr.id),
                                                  icon: const Icon(Icons.cancel, color: Colors.red),
                                                  label: const Text('Reject', style: TextStyle(color: Colors.red)),
                                                ),
                                                const SizedBox(width: 8),
                                                ElevatedButton.icon(
                                                  onPressed: () => context.read<TransportCubit>().acceptRequest(tr.id),
                                                  icon: const Icon(Icons.check),
                                                  label: const Text('Accept'),
                                                ),
                                              ],
                                            )
                                          else if (status == 'cancelled')
                                            const Text('Request Rejected', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600))
                                          else
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text('Request Accepted ✅', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
                                                const SizedBox(height: 10),
                                                SimulateLocationButton(
                                                  pointALat: tr.originLat,
                                                  pointALong: tr.originLng,
                                                  pointBLat: tr.destinationLat,
                                                  pointBLong: tr.destinationLng,
                                                  transportId: tr.id,
                                                  vehicleId: tr.vehicleId!,
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                    ],
                  ),
                  if (isProcessing)
                    Container(color: Color.fromRGBO(0, 0, 0, 0.4), child: const Center(child: CircularProgressIndicator())),
                ],
              ),
            );
          } else if (authState is AuthUnauthenticated) {
            WidgetsBinding.instance.addPostFrameCallback((_) => context.go('/login'));
            return const SizedBox();
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
