/**
 * Desenvolvido por: Márcio Rodrigues de Oliveira, Engenheiro de Software
 */

import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  late io.Socket socket;
  final String serverUrl = "http://seu-api-url.com/tracking";

  void initConfig(String routeId) {
    socket = io.io(serverUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.onConnect((_) {
      print('Conectado ao servidor de rastreamento');
      // Entra na sala específica da rota para comunicação segmentada
      socket.emit('joinRoute', {'routeId': routeId});
    });

    socket.onDisconnect((_) => print('Desconectado do servidor'));
  }

  /// Envia a localização do motorista para o servidor
  void emitLocation(String routeId, double lat, double lng) {
    if (socket.connected) {
      socket.emit('updateLocation', {
        'routeId': routeId,
        'latitude': lat,
        'longitude': lng,
      });
    }
  }

  void dispose() {
    socket.disconnect();
    socket.dispose();
  }
}