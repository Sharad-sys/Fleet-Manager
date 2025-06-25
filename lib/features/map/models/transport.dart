class Transport {
  final int id;
  final String originLat;
  final String originLng;
  final String destinationLat;
  final String destinationLng;
  final String description;
  final int priority;
  final String status;
  final bool isAccepted;
  final String? createdBy;
  final String? assignedTo;
  final int? vehicleId;

  Transport({
    required this.id,
    required this.originLat,
    required this.originLng,
    required this.destinationLat,
    required this.destinationLng,
    required this.description,
    required this.priority,
    required this.status,
    required this.isAccepted,
    required this.createdBy,
    required this.assignedTo,
    required this.vehicleId,
  });

  factory Transport.fromJson(Map<String, dynamic> json) {
    return Transport(
      id: json['id'],
      originLat: json['originLat'],
      originLng: json['originLng'],
      destinationLat: json['destinationLat'],
      destinationLng: json['destinationLng'],
      description: json['description'] ?? '',
      priority: json['priority'],
      status: json['status'],
      isAccepted: json['isAccepted'],
      createdBy: json['createdBy']?['name'],
      assignedTo: json['assignedTo']?['name'],
      vehicleId: (json['assignments'] as List?)?.isNotEmpty==true ? json['assignments'][0]['vehicleId'] : null,
    );
  }
}
