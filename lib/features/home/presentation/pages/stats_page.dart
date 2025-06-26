import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tester/features/home/application/cubit/stats_cubit.dart';
import 'package:tester/features/home/application/cubit/stats_state.dart';
import 'package:tester/features/home/presentation/widgets/transport_stats_chart.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  @override
  void initState() {
    super.initState();

    context.read<StatsCubit>().getMyStats();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatsCubit, StatsState>(
      builder: (context, state) {
        if (state is StatsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is StatsFailure) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (state is StatsSucess) {
          final stats = state.transportStats;

          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Your Transport Stats',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              centerTitle: true,
              elevation: 2,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Overview',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(
                        context,
                      ).colorScheme.onPrimary.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TransportStatsChart(
                    completed: stats.totalCompleted,
                    ongoing: stats.ongoing,
                    rejected: stats.rejected,
                  ),
                  const SizedBox(height: 30),
                  _buildStatCard(
                    title: 'Total Completed',
                    count: stats.totalCompleted,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 10),
                  _buildStatCard(
                    title: 'Ongoing',
                    count: stats.ongoing,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 10),
                  _buildStatCard(
                    title: 'Rejected',
                    count: stats.rejected,
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required int count,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: color.withValues(alpha: 0.1),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.2),
          child: Icon(Icons.bar_chart, color: color),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
        trailing: Text(
          '$count',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: color,
          ),
        ),
      ),
    );
  }
}
