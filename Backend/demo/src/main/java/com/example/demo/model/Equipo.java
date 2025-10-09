package com.example.demo.model;

import jakarta.persistence.*;

@Entity
@Table(name = "equipos")
public class Equipo {

   @Id
@GeneratedValue(strategy = GenerationType.IDENTITY)
@Column(name = "id_equipos")
private Long id;

@Column(name = "nombre_equipo", nullable = false)
private String nombre;

@Column(name = "escudo")
private String escudo;

@Column(name = "centro_universitario")
private String centroUniversitario;


    // Getters y setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getEscudo() { return escudo; }
    public void setEscudo(String escudo) { this.escudo = escudo; }

    public String getCentroUniversitario() { return centroUniversitario; }
    public void setCentroUniversitario(String centroUniversitario) { this.centroUniversitario = centroUniversitario; }
}
