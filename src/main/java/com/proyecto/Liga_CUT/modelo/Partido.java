package com.proyecto.Liga_CUT.modelo;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@Entity
@Table(name = "partido")
public class Partido {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_partido") 
    private Integer idPartido;

    @Column(name = "id_equipo_local", nullable = false)
    private Integer idEquipoLocal;

    @Column(name = "id_equipo_visitante", nullable = false)
    private Integer idEquipoVisitante;

    @Column(name = "fecha_play") 
    private LocalDateTime fechaPlay;

    @Column(name = "goles_local") 
    private int golesLocal;

    @Column(name = "goles_visitante") 
    private int golesVisitante;
    
    private String estado;
}