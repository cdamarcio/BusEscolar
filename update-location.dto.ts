/**
 * Desenvolvido por: Márcio Rodrigues de Oliveira, Engenheiro de Software
 */

import { IsNumber, IsString } from 'class-validator';

export class UpdateLocationDto {
  @IsString()
  routeId: string;

  @IsNumber()
  latitude: number;

  @IsNumber()
  longitude: number;
}