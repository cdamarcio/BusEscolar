/**
 * Desenvolvido por: Márcio Rodrigues de Oliveira, Engenheiro de Software
 */

// ... (imports anteriores)
import 'package:flutter_map/flutter_map.dart';

// No estado da sua página:
List<LatLng> _routePoints = [];

void _loadRoute() async {
  final points = await RouteService().fetchRoute("id-da-rota");
  setState(() {
    _routePoints = points;
  });
}

// Dentro do widget FlutterMap:
children: [
  TileLayer(
    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    userAgentPackageName: 'com.cda.busescolar',
  ),
  // Camada que desenha a linha da rota
  if (_routePoints.isNotEmpty)
    PolylineLayer(
      polylines: [
        Polyline(
          points: _routePoints,
          color: Colors.blueAccent,
          strokeWidth: 5.0,
          isOutline: true,
          outlineColor: Colors.black,
        ),
      ],
    ),
  // ... (MarkerLayer do ônibus)
],