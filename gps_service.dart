/**
 * Desenvolvido por: Márcio Rodrigues de Oliveira, Engenheiro de Software
 */

import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class GpsService {
  /// Verifica permissões e retorna a posição atual
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return Future.error('Serviço de localização desativado.');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return Future.error('Permissão negada.');
    }

    return await Geolocator.getCurrentPosition();
  }

  /// Stream que monitoriza a mudança de posição com precisão elevada
  Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Atualiza a cada 10 metros para poupar bateria
      ),
    );
  }
}