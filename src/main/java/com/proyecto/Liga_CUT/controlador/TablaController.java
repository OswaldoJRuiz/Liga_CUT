package com.proyecto.Liga_CUT.controlador;

import com.proyecto.Liga_CUT.dto.PosicionDTO;
import com.proyecto.Liga_CUT.servicio.ServicioTabla;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*") 
public class TablaController {
    private final ServicioTabla servicioTabla;

    public TablaController(ServicioTabla servicioTabla) {
        this.servicioTabla = servicioTabla;
    }
    
    @GetMapping("/tabla")
    public List<PosicionDTO> obtenerTabla() {
        return servicioTabla.obtenerTabla();
    }
}
