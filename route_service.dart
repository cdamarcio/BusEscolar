/**
 * Desenvolvido por: Márcio Rodrigues de Oliveira, Engenheiro de Software
 */

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class RouteService {
  final String baseUrl = "http://seu-api-url.com/tracking";

  Future<List<LatLng>> fetchRoute(String routeId) async {
    final response = await http.get(Uri.parse('$baseUrl/route/$routeId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Assume que o backend retorna um GeoJSON do tipo LineString
      final List coordinates = data['path']['coordinates'];
      
      return coordinates.map((c) => LatLng(c[1], c[0])).toList();
    } else {
      throw Exception('Falha ao carregar a rota');
    }
  }
}