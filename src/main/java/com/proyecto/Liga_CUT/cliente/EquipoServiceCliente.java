package com.proyecto.Liga_CUT.cliente;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.proyecto.Liga_CUT.dto.EquipoDTO;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

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

        System.out.println("--- USANDO DATOS DE PRUEBA PARA EQUIPOS ---");
        return Arrays.asList(
            new EquipoDTO(1, "Los Poderosos"),
            new EquipoDTO(2, "Los Veloces"),
            new EquipoDTO(3, "Los Invencibles")
        );
        //  FIN MODO DE PRUEBA 


        /*  CÓDIGO REAL  
        try {
            String url = equiposApiUrl + "/api/equipos"; 
            EquipoDTO[] response = restTemplate.getForObject(url, EquipoDTO[].class);
            return response != null ? Arrays.asList(response) : Collections.emptyList();
        } catch (Exception e) {
            System.err.println("ERROR: No se pudo conectar al servicio de equipos en " + equiposApiUrl + ". " + e.getMessage());
            return Collections.emptyList();
        }
        */
    }
}
