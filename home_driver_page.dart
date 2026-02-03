/**
 * Desenvolvido por: Márcio Rodrigues de Oliveira, Engenheiro de Software
 */

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

// Importação dos serviços que criamos anteriormente
import 'services/gps_service.dart';
import 'services/socket_service.dart';
import 'services/route_service.dart';

class HomeDriverPage extends StatefulWidget {
  final String routeId;
  const HomeDriverPage({super.key, required this.routeId});

  @override
  State<HomeDriverPage> createState() => _HomeDriverPageState();
}

class _HomeDriverPageState extends State<HomeDriverPage> {
  // Estado do Mapa e Localização
  final MapController _mapController = MapController();
  LatLng _currentBusPosition = const LatLng(0, 0);
  List<LatLng> _routePoints = [];
  
  // Serviços e Subscriptions
  final GpsService _gpsService = GpsService();
  final SocketService _socketService = SocketService();
  final RouteService _routeService = RouteService();
  StreamSubscription<Position>? _positionStream;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  /// Inicializa Conexões e Carrega Dados Iniciais
  void _initializeServices() async {
    // 1. Conecta ao WebSocket
    _socketService.initConfig(widget.routeId);

    // 2. Carrega o traçado da rota do backend (OSRM)
    try {
      final points = await _routeService.fetchRoute(widget.routeId);
      setState(() => _routePoints = points);
    } catch (e) {
      debugPrint("Erro ao carregar rota: $e");
    }

    // 3. Inicia o rastreamento GPS em tempo real
    _positionStream = _gpsService.getPositionStream().listen((Position position) {
      final newPos = LatLng(position.latitude, position.longitude);
      
      setState(() => _currentBusPosition = newPos);
      
      // Move a câmera para seguir o motorista
      _mapController.move(newPos, 15.0);

      // Envia para o Backend/Pais via WebSocket
      _socketService.emitLocation(widget.routeId, newPos.latitude, newPos.longitude);
    });
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _socketService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rota: ${widget.routeId}'),
        backgroundColor: Colors.orange.shade800,
        actions: [
          IconButton(
            icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
            onPressed: () => _alertPanic(), // Lógica de Pânico
          )
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(-15.79, -47.88), // Fallback inicial
              initialZoom: 15.0,
            ),
            children: [
              // Camada OpenStreetMap
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.cda.busescolar',
              ),
              
              // Camada da Linha da Rota (OSRM)
              if (_routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _routePoints,
                      color: Colors.blue.withOpacity(0.7),
                      strokeWidth: 6.0,
                    ),
                  ],
                ),

              // Marcador do Ônibus (Localização Real)
              MarkerLayer(
                markers: [
                  Marker(
                    point: _currentBusPosition,
                    width: 50,
                    height: 50,
                    child: const Icon(
                      Icons.directions_bus_rounded,
                      color: Colors.orange,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          // Card de Controle Inferior
          Positioned(
            bottom: 20, left: 15, right: 15,
            child: _buildInfoCard(),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Operação Ativa", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            const Divider(),
            ElevatedButton(
              onPressed: () {}, // Abre Lista de Alunos
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade800),
              child: const Text("LISTA DE CHAMADA DIGITAL", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }

  void _alertPanic() {
    // Implementação do envio de alerta crítico para a central
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("ALERTA DE PÂNICO ENVIADO À CENTRAL!")),
    );
  }
}