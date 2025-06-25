import 'package:equatable/equatable.dart';

class History extends Equatable {
  final int id;
  final DateTime acceptedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double originLat;
  final double originLng;
  final double destinationLat;
  final double destinationLng;

  const History({
    required this.id,
    required this.acceptedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.originLat,
    required this.originLng,
    required this.destinationLat,
    required this.destinationLng,
  });

  factory History.fromJson(Map<String,dynamic> json){

    return History(
      id: json['id'],
      acceptedAt: DateTime.parse(json['acceptedAt']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      originLat: double.parse(json['originLat'].toString()),
      originLng: double.parse(json['originLng'].toString()),
      destinationLat: double.parse(json['destinationLat'].toString()),
      destinationLng: double.parse(json['destinationLng'].toString()),
    );

  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'acceptedAt': acceptedAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'originLat': originLat,
      'originLng': originLng,
      'destinationLat': destinationLat,
      'destinationLng': destinationLng,
    };
  }

  @override
  List<Object?> get props => [
    id,
    acceptedAt,
    createdAt,
    updatedAt,
    originLat,
    originLng,
    destinationLat,
    destinationLng,
  ];


}
