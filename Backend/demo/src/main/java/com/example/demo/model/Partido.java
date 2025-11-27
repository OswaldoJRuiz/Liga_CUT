package com.example.demo.model;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalTime;

@Entity
@Table(name = "partidos")
public class Partido {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_partido")
    private Long idPartido;

    // FK: equipos.id_equipos (local)
    @ManyToOne(optional = false, fetch = FetchType.LAZY)
    @JoinColumn(name = "id_local", nullable = false)
    private Equipo local;

    // FK: equipos.id_equipos (visitante)
    @ManyToOne(optional = false, fetch = FetchType.LAZY)
    @JoinColumn(name = "id_visitante", nullable = false)
    private Equipo visitante;

    // fecha: DATE NOT NULL
    @Column(name = "fecha", nullable = false)
    private LocalDate fecha;

    // hora: TIME WITHOUT TIME ZONE NOT NULL
    @Column(name = "hora", nullable = false)
    private LocalTime hora;

    // lugar: VARCHAR NOT NULL
    @Column(name = "lugar", nullable = false, length = 255)
    private String lugar;

    // marcador_local: INTEGER (default 0 en BD)
    @Column(name = "marcador_local", nullable = false)
    private int marcadorLocal = 0;

    // OJO: si tu columna en BD se llama 'marcador_visita' cámbialo aquí:
    @Column(name = "marcador_visitante", nullable = false)
    private int marcadorVisitante = 0;

    // estado: VARCHAR NOT NULL (default 'pendiente' en BD)
    @Column(name = "estado", nullable = false, length = 255)
    private String estado = "pendiente";

    // FK: jornadas.id_jornada
    @ManyToOne(optional = false, fetch = FetchType.LAZY)
    @JoinColumn(name = "jornada_id", nullable = false)
    private Jornada jornada;

    // ===== Getters y setters =====
    public Long getId() { return idPartido; }
    public void setId(Long id) { this.idPartido = id; }

    public Equipo getLocal() { return local; }
    public void setLocal(Equipo local) { this.local = local; }

    public Equipo getVisitante() { return visitante; }
    public void setVisitante(Equipo visitante) { this.visitante = visitante; }

    public LocalDate getFecha() { return fecha; }
    public void setFecha(LocalDate fecha) { this.fecha = fecha; }

    public LocalTime getHora() { return hora; }
    public void setHora(LocalTime hora) { this.hora = hora; }

    public String getLugar() { return lugar; }
    public void setLugar(String lugar) { this.lugar = lugar; }

    public int getMarcadorLocal() { return marcadorLocal; }
    public void setMarcadorLocal(int marcadorLocal) { this.marcadorLocal = marcadorLocal; }

    public int getMarcadorVisitante() { return marcadorVisitante; }
    public void setMarcadorVisitante(int marcadorVisitante) { this.marcadorVisitante = marcadorVisitante; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public Jornada getJornada() { return jornada; }
    public void setJornada(Jornada jornada) { this.jornada = jornada; }
}
