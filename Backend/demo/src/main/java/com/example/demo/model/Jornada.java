package com.example.demo.model;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "jornadas")
public class Jornada {
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "id_jornada")
  private Long id;

  @Column(name = "numero_jornada", nullable = false)
  private int numero;

  @Column(name = "fecha_inicio")
  private LocalDate fechaInicio;

  @Column(name = "fecha_fin")
  private LocalDate fechaFin;

    @Column(name = "id_partido")
    private Long idPartido;

   
    public Long getId() { 
        return id; 
    }
    public void setId(Long id) { 
        this.id = id; 
    }

    public int getNumero() { 
        return numero; 
    }
    public void setNumero(int numero) { 
        this.numero = numero; 
    }

    public LocalDate getFechaInicio() { 
        return fechaInicio; 
    }
    public void setFechaInicio(LocalDate fechaInicio) { 
        this.fechaInicio = fechaInicio; 
    }

    public LocalDate getFechaFin() { 
        return fechaFin; 
    }
    public void setFechaFin(LocalDate fechaFin) { 
        this.fechaFin = fechaFin; 
    }

    public Long getIdPartido() { 
        return idPartido; 
    }
}
