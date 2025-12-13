package com.proyecto.Liga_CUT.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor; 
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor 
public class EquipoDTO {
    
  
    @JsonProperty("id_equipo")
    private Integer idEquipo;
    
    private String nombre;
}