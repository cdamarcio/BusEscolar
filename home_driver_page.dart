/**
 * Desenvolvido por: Márcio Rodrigues de Oliveira, Engenheiro de Software
 */

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'gps_service.dart';

// ... (Restantes imports)

class _HomeDriverPageState extends State<HomeDriverPage> {
  LatLng _currentBusPosition = const LatLng(-15.793889, -47.882778);
  StreamSubscription<Position>? _positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    _startTracking();
  }

  void _startTracking() {
    _positionStreamSubscription = GpsService().getPositionStream().listen((Position position) {
      setState(() {
        _currentBusPosition = LatLng(position.latitude, position.longitude);
      });
      
      // Centraliza o mapa no autocarro automaticamente
      _mapController.move(_currentBusPosition, 15.0);

      // Aqui invocaria o seu SocketService para enviar ao Backend
      // _socketService.emitLocation(_currentBusPosition);
    });
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel(); // Importante para evitar memory leaks
    super.dispose();
  }

  // No widget FlutterMap, altere o MarkerLayer:
  // Marker(
  //   point: _currentBusPosition,
  //   child: const Icon(Icons.directions_bus, color: Colors.blue, size: 40),
  // ),
}