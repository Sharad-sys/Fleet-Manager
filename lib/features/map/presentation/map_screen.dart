import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:dio/dio.dart';
import 'package:tester/features/map/application/map_cubit.dart';
import 'package:tester/features/transport/application/transport_cubit.dart';

class MapScreen extends StatefulWidget {
  final LatLng origin;
  final LatLng destination;
  final int transportId;

  const MapScreen({super.key, required this.origin, required this.destination,required this.transportId});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();

  late LatLng pointA;
  late LatLng pointB;

  late LatLng _currentPosition;
  List<LatLng> _routePoints = [];

  Timer? _movementTimer;
  Timer? _backendTimer;
  int _currentIndex = 0;
  final String vehicleId = 'abc123';

  @override
  void initState() {
    super.initState();
    pointA = widget.origin;
    pointB = widget.destination;
    _currentPosition = pointA;
    _fetchRouteWithDio();
  }

  Future<void> _fetchRouteWithDio() async {
    final dio = Dio();

    final url =
        'https://router.project-osrm.org/route/v1/driving/${pointA.longitude},${pointA.latitude};${pointB.longitude},${pointB.latitude}?overview=full&geometries=geojson';

    try {
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final data = response.data;

        final List coordinates = data['routes'][0]['geometry']['coordinates'];

        setState(() {
          _routePoints = coordinates
              .map(
                (coord) => LatLng(coord[1], coord[0]),
              ) // [lng, lat] → [lat, lng]
              .toList();
        });

        if (_routePoints.isNotEmpty) {
          _startSimulation();
        }
      } else {
        print('Dio: Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Dio error fetching route: $e');
    }
  }

  void _startSimulation() {
    _movementTimer = Timer.periodic(const Duration(milliseconds: 3), (timer) {
      if (_currentIndex < _routePoints.length) {
        setState(() {
          _currentPosition = _routePoints[_currentIndex];
        });

        _mapController.move(_currentPosition, _mapController.camera.zoom);
        _currentIndex++;
      } else {
        timer.cancel();
        _backendTimer?.cancel();
        print('Simulation complete.');

        showCupertinoDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
            title: const Text("Journey Completed"),
            content: const Text("The vehicle has reached its destination."),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: const Text("Go to Home"),
                onPressed: () {

                  context.read<MapCubit>().completeTransport(
                    widget.transportId,
                  );
                  Navigator.of(context).pop();
                  //Navigator.of(context).pop();

                  context.go('/home');
                },
              ),
            ],
          ),
        );
      }
    });

    _backendTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _sendLocationToBackend();
    });
  }

  Future<void> _sendLocationToBackend() async {
    //final url = '/api/transports/${vehicleId}/accept';

    final body = {
      "vehicleId": 6,
      "latitude": _currentPosition.latitude,
      "longitude": _currentPosition.longitude,
    };

    print(body);

    context.read<MapCubit>().pushDataToBackEnd(body);

    // try {
    //   final response = await dio.post(url, data: body);
    //   print('Location sent to backend: ${response.statusCode}');
    // } catch (e) {
    //   print('Failed to send location: $e');
    // }
  }

  void _centerMap() {
    _mapController.move(_currentPosition, _mapController.camera.zoom);
  }

  @override
  void dispose() {
    _movementTimer?.cancel();
    _backendTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simulated Route')),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(initialCenter: pointA, initialZoom: 11),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              if (_routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _routePoints,
                      color: Colors.blue,
                      strokeWidth: 4.0,
                    ),
                  ],
                ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: pointA,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.location_on,
                      size: 40,
                      color: Colors.green,
                    ),
                  ),
                  Marker(
                    point: pointB,
                    width: 40,
                    height: 40,
                    child: const Icon(Icons.flag, size: 40, color: Colors.red),
                  ),
                  Marker(
                    point: _currentPosition,
                    width: 40,
                    height: 40,
                    child: Image.asset(
                      'lib/assets/truck.png',
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: _centerMap,
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}
