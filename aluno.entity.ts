/**
 * Desenvolvido por: Márcio Rodrigues de Oliveira, Engenheiro de Software
 */

import { Entity, Column, PrimaryGeneratedColumn, ManyToOne, Index } from 'typeorm';
import { Point } from 'geojson';
import { User } from './user.entity'; // Assumindo a existência da entidade User para o Responsável

@Entity('alunos')
export class Aluno {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  nome: string;

  @Column()
  matricula: string;

  @Column({ nullable: true })
  escola: string;

  /**
   * Localização da residência do aluno.
   * Usamos 'geography' para cálculos precisos em metros.
   * O SRID 4326 é o padrão mundial para GPS (WGS84).
   */
  @Index({ spatial: true })
  @Column({
    type: 'geography',
    spatialFeatureType: 'Point',
    srid: 4326,
  })
  localizacao_residencia: Point;

  @ManyToOne(() => User, (user) => user.dependentes)
  responsavel: User;

  @Column({ default: true })
  ativo: boolean;
}