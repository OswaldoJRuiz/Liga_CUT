package com.proyecto.Liga_CUT.cliente;

import com.proyecto.Liga_CUT.dto.EquipoDTO;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

@Service
public class EquipoServiceCliente {

    private final RestTemplate restTemplate;

    @Value("${api.equipos.url}")
    private String equiposApiUrl;

    public EquipoServiceCliente(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }
    
    public List<EquipoDTO> obtenerTodosLosEquipos() {
        // --- INICIO DE LA SIMULACIÓN ---
        // Descomenta la siguiente línea para devolver datos de prueba sin llamar a la API real.
        return obtenerEquiposDePrueba(); 
        // --- FIN DE LA SIMULACIÓN ---

        /* --- CÓDIGO REAL---
        try {
            String url = equiposApiUrl + "/equipos";
            EquipoDTO[] response = restTemplate.getForObject(url, EquipoDTO[].class);
            return response != null ? Arrays.asList(response) : Collections.emptyList();
        } catch (Exception e) {
            System.err.println("ERROR: No se pudo conectar al servicio de equipos en " + equiposApiUrl + ". " + e.getMessage());
            return Collections.emptyList();
        }
        */
    }
    
    // Método privado para generar datos falsos
    private List<EquipoDTO> obtenerEquiposDePrueba() {
        System.out.println("--- USANDO DATOS DE PRUEBA PARA EQUIPOS ---");
        List<EquipoDTO> equipos = new ArrayList<>();
        
        EquipoDTO equipo1 = new EquipoDTO();
        equipo1.setIdEquipo(1);
        equipo1.setNombre("Guerreros Jaguar");
        equipos.add(equipo1);
        
        EquipoDTO equipo2 = new EquipoDTO();
        equipo2.setIdEquipo(2);
        equipo2.setNombre("Águilas Reales");
        equipos.add(equipo2);

        EquipoDTO equipo3 = new EquipoDTO();
        equipo3.setIdEquipo(3);
        equipo3.setNombre("Serpientes Emplumadas");
        equipos.add(equipo3);

        return equipos;
    }
}