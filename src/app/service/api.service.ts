import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Partido } from '../modelos/partidos';   // <— OJO

@Injectable({ providedIn: 'root' })
export class ApiService {
  private base = '/api'; // usa el proxy http://localhost:8080

  constructor(private http: HttpClient) {}

  getPartidos(): Observable<Partido[]> {
    return this.http.get<Partido[]>(`${this.base}/partidos`);
  }
}
