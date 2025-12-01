package com.proyecto.Liga_CUT.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class PartidoRequestDTO {
    private Integer idEquipoLocal;
    private Integer idEquipoVisitante;
    private LocalDateTime fechaPlay;
    private int golesLocal;
    private int golesVisitante;
    private String estado;
}