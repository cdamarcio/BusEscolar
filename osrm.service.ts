/**
 * Desenvolvido por: Márcio Rodrigues de Oliveira, Engenheiro de Software
 */

import { Injectable, HttpService } from '@nestjs/common';

@Injectable()
export class OsrmService {
  private readonly osrmUrl = process.env.OSRM_URL || 'http://localhost:5000';

  constructor(private httpService: HttpService) {}

  async getOptimizedRoute(coordinates: number[][]) {
    // Formata coordenadas para o padrão OSRM: lon,lat;lon,lat
    const coordsString = coordinates.map(c => `${c[0]},${c[1]}`).join(';');
    
    const url = `${this.osrmUrl}/route/v1/driving/${coordsString}?overview=full&geometries=geojson`;
    
    const response = await this.httpService.get(url).toPromise();
    return response.data.routes[0].geometry; // Retorna o GeoJSON para o PostGIS
  }
}