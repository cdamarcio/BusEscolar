/**
 * Desenvolvido por: Márcio Rodrigues de Oliveira, Engenheiro de Software
 */

import { Entity, Column, PrimaryGeneratedColumn, CreateDateColumn } from 'typeorm';
import { Geometry } from 'geojson';

@Entity('routes')
export class Route {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  name: string; // Ex: "Rota Zona Rural - Eixo Sul"

  @Column()
  driver_id: string;

  @Column()
  vehicle_id: string;

  // Armazena o traçado da rota (LineString) vindo do OSRM
  @Column({
    type: 'geometry',
    spatialFeatureType: 'LineString',
    srid: 4326,
    nullable: true,
  })
  path: Geometry;

  @CreateDateColumn()
  created_at: Date;
}