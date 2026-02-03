/**
 * Desenvolvido por: Márcio Rodrigues de Oliveira, Engenheiro de Software
 */

import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Aluno } from './entities/aluno.entity';

@Injectable()
export class GeofencingService {
  constructor(
    @InjectRepository(Aluno)
    private alunoRepository: Repository<Aluno>,
  ) {}

  /**
   * Verifica quais alunos estão em um raio de proximidade da localização atual do ônibus.
   * @param latitude Latitude atual do ônibus
   * @param longitude Longitude atual do ônibus
   * @param radius Raio em metros (ex: 500 para 500 metros)
   */
  async checkProximity(latitude: number, longitude: number, radius: number = 500): Promise<Aluno[]> {
    // A query utiliza ST_DWithin para encontrar pontos geográficos próximos.
    // O SRID 4326 refere-se ao sistema de coordenadas WGS84 (GPS).
    return await this.alunoRepository
      .createQueryBuilder('aluno')
      .where(
        `ST_DWithin(
          aluno.localizacao_residencia, 
          ST_SetSRID(ST_MakePoint(:longitude, :latitude), 4326)::geography, 
          :radius
        )`,
        { longitude, latitude, radius }
      )
      .getMany();
  }
}