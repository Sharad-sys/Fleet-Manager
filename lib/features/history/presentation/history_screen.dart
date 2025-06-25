import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tester/features/history/application/cubit/history_cubit.dart';
import 'package:tester/features/history/application/cubit/history_state.dart';

class HistoryScreen extends StatelessWidget {
  final int staffId;

  const HistoryScreen({super.key, required this.staffId});

  @override
  Widget build(BuildContext context) {
  
    context.read<HistoryCubit>().fetchHistory(staffId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Completed Rides'),
      ),
      body: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HistorySucess) {
            final rides = state.completedRides;

            if (rides.isEmpty) {
              return const Center(child: Text('No completed rides.'));
            }

            return ListView.builder(
              itemCount: rides.length,
              itemBuilder: (context, index) {
                final ride = rides[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListTile(
                    title: Text("Ride ID: ${ride.id}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Accepted: ${ride.acceptedAt}"),
                        Text("From: ${ride.originLat}, ${ride.originLng}"),
                        Text("To: ${ride.destinationLat}, ${ride.destinationLng}"),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is HistoryFailure) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const SizedBox.shrink(); 
          }
        },
      ),
    );
  }
}
