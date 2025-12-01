import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ApiService } from '../service/api.service';
import { Partido } from '../modelos/partidos';   // <— OJO

@Component({
  selector: 'app-calendario',
  standalone: true,
  imports: [CommonModule], // Necesario para *ngFor y pipes
  templateUrl: './calendario.html',
  styleUrls: ['./calendario.css']
})




export class Calendario implements OnInit {
  partidos: Partido[] = [];
  cargando = true;
  error?: string;

  constructor(private api: ApiService) {}

  ngOnInit(): void {
    this.api.getPartidos().subscribe({
      next: (data) => { this.partidos = data; this.cargando = false; },
      error: () => { this.error = 'No se pudieron cargar los partidos'; this.cargando = false; }
    });
  }
}
