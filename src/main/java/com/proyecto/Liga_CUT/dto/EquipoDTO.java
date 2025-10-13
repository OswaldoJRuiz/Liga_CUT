package com.proyecto.Liga_CUT.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class EquipoDTO {
    
    // Jackson mapeará el JSON "id_equipo" a este campo "idEquipo"
    @JsonProperty("id_equipo")
    private Integer idEquipo;
    
    private String nombre;
}