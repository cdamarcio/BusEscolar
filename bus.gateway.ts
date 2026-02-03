/**
 * Desenvolvido por: Márcio Rodrigues de Oliveira, Engenheiro de Software
 */

import {
    WebSocketGateway,
    WebSocketServer,
    SubscribeMessage,
    OnGatewayConnection,
    OnGatewayDisconnect,
    MessageBody,
    ConnectedSocket,
  } from '@nestjs/websockets';
  import { Server, Socket } from 'socket.io';
  import { UsePipes, ValidationPipe } from '@nestjs/common';
  import { UpdateLocationDto } from './dto/update-location.dto';
  
  @WebSocketGateway({
    cors: { origin: '*' },
    namespace: 'tracking',
  })
  export class BusGateway implements OnGatewayConnection, OnGatewayDisconnect {
    @WebSocketServer()
    server: Server;
  
    handleConnection(client: Socket) {
      console.log(`Cliente conectado: ${client.id}`);
    }
  
    handleDisconnect(client: Socket) {
      console.log(`Cliente desconectado: ${client.id}`);
    }
  
    /**
     * Permite que Pais/Responsáveis entrem na sala de uma rota específica
     * para receber atualizações de localização.
     */
    @SubscribeMessage('joinRoute')
    handleJoinRoute(
      @MessageBody('routeId') routeId: string,
      @ConnectedSocket() client: Socket,
    ) {
      client.join(`route_${routeId}`);
      return { event: 'joined', data: routeId };
    }
  
    /**
     * Recebe a localização do motorista e faz o broadcast para a sala da rota.
     */
    @UsePipes(new ValidationPipe())
    @SubscribeMessage('updateLocation')
    handleUpdateLocation(
      @MessageBody() data: UpdateLocationDto,
      @ConnectedSocket() client: Socket,
    ) {
      // Transmite a localização apenas para os dispositivos na sala desta rota
      this.server.to(`route_${data.routeId}`).emit('locationUpdated', {
        latitude: data.latitude,
        longitude: data.longitude,
        timestamp: new Date().toISOString(),
      });
    }
  }