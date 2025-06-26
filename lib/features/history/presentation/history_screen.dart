import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';
import 'package:tester/features/history/application/cubit/history_cubit.dart';
import 'package:tester/features/history/application/cubit/history_state.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final Map<String, String> _addressCache = {};

  @override
  void initState() {
    super.initState();
    context.read<HistoryCubit>().fetchHistory();
  }

  String formatDateTime(DateTime iso) {
    return DateFormat.yMMMd().add_jm().format(iso);
  }

  Future<void> _resolveAddress({
    required double lat,
    required double long,
    required String key,
  }) async {
    if (_addressCache.containsKey(key)) return;

    try {
      final placemarks = await placemarkFromCoordinates(lat, long);
      final placemark = placemarks.first;
      final fullAddress = "${placemark.name}, ${placemark.locality}";
      setState(() {
        _addressCache[key] = fullAddress;
      });
    } catch (_) {
      setState(() {
        _addressCache[key] = "Unknown location";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Completed Rides'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HistorySucess) {
            final rides = state.completedRides;

            if (rides.isEmpty) {
              return const Center(
                child: Text(
                  'No completed rides yet.',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: rides.length,
              itemBuilder: (context, index) {
                final ride = rides[index];
                final fromKey = "from_${ride.id}";
                final toKey = "to_${ride.id}";

                _resolveAddress(
                  lat: ride.originLat,
                  long: ride.originLng,
                  key: fromKey,
                );
                _resolveAddress(
                  lat: ride.destinationLat,
                  long: ride.destinationLng,
                  key: toKey,
                );

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.directions_car,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Ride ID: ${ride.id}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimary.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 18,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Accepted at: ${formatDateTime(ride.acceptedAt)}",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onPrimary
                                      .withValues(alpha: 0.7),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 18,
                              color: Colors.redAccent,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "From: ${_addressCache[fromKey] ?? 'Resolving...'}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).colorScheme.onPrimary
                                      .withValues(alpha: 0.6),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.flag,
                              size: 18,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "To: ${_addressCache[toKey] ?? 'Resolving...'}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).colorScheme.onPrimary
                                      .withValues(alpha: 0.6),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is HistoryFailure) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
