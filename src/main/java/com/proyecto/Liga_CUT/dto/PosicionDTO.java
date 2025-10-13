package com.proyecto.Liga_CUT.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO para enviar la tabla de posiciones al frontend.
 * @Data genera getters, setters, toString, etc.
 * @NoArgsConstructor genera un constructor sin argumentos.
 * @AllArgsConstructor genera un constructor con todos los argumentos.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class PosicionDTO {
    private Integer posicion;
    private Long equipoId;
    private String nombre;
    private Integer partidosJugados;
    private Integer ganados;
    private Integer empatados;
    private Integer perdidos;
    private Integer golesFavor;
    private Integer golesContra;
    private Integer diferenciaGoles;
    private Integer puntos;
}
