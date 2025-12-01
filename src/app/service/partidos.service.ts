import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface Partido {
  id: number;
  fecha: string;
  local: string;
  visitante: string;
  marcador: string;
}

@Injectable({ providedIn: 'root' })
export class PartidosService {
  private baseUrl = '/api/partidos';


  constructor(private http: HttpClient) {}

  list(): Observable<Partido[]> {
    return this.http.get<Partido[]>(this.baseUrl);
  }
}
