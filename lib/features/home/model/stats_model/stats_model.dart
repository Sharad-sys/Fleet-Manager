import 'package:equatable/equatable.dart';

class StatsModel extends Equatable {
  final String status;
  final String message;
  final int totalCompleted;
  final int ongoing;
  final int rejected;

  const StatsModel({
    required this.status,
    required this.message,
    required this.totalCompleted,
    required this.ongoing,
    required this.rejected,
  });

  factory StatsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return StatsModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      totalCompleted: data['totalCompleted'] ?? 0,
      ongoing: data['ongoing'] ?? 0,
      rejected: data['rejected'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': {
        'totalCompleted': totalCompleted,
        'ongoing': ongoing,
        'rejected': rejected,
      }
    };
  }

  @override
  List<Object?> get props => [
        status,
        message,
        totalCompleted,
        ongoing,
        rejected,
      ];
}
