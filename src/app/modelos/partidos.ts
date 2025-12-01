
export interface Equipo {
  id?: number;       
  nombre?: string;   
}

export interface Jornada {
  id?: number;
  numero?: number;
}

export interface Partido {
  id: number;                 // viene de getId()
  local: Equipo;              // getLocal()
  visitante: Equipo;          // getVisitante()
  fecha: string;              // LocalDate -> ISO string
  hora: string;               // LocalTime -> "HH:mm:ss"
  lugar: string;
  marcadorLocal: number;
  marcadorVisitante: number;
  estado: string;
  jornada?: Jornada;
}
