import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

class SimulateLocationButton extends StatelessWidget {
  final String pointALat;
  final String pointALong;
  final String pointBLat;
  final String pointBLong;
  final int transportId;
  final int vehicleId;

  const SimulateLocationButton({
    super.key,
    required this.pointALat,
    required this.pointALong,
    required this.pointBLat,
    required this.pointBLong,
    required this.transportId,
    required this.vehicleId,
  });

  Future<void> _handlePermissionAndNavigate(BuildContext context) async {
    final status = await Permission.location.request();

    if (status.isGranted) {
      context.go(
        '/map',
        extra: {
          'origin': LatLng(double.parse(pointALat), double.parse(pointALong)),
          'destination': LatLng(
            double.parse(pointBLat),
            double.parse(pointBLong),
          ),
          'transportId': transportId,
          'vehicleId':vehicleId,
        },
      );
    } else if (status.isDenied || status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location permission is required to simulate.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _handlePermissionAndNavigate(context),
      child: const Text('Simulate Location'),
    );
  }
}
