package com.proyecto.Liga_CUT.controlador;

import com.proyecto.Liga_CUT.dto.PartidoRequestDTO;
import com.proyecto.Liga_CUT.dto.PosicionDTO;
import com.proyecto.Liga_CUT.modelo.Partido;
import com.proyecto.Liga_CUT.servicio.ServicioTabla;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*") // Permite peticiones desde cualquier origen
public class TablaController {

    private final ServicioTabla servicioTabla;

    public TablaController(ServicioTabla servicioTabla) {
        this.servicioTabla = servicioTabla;
    }
    
    @GetMapping("/tabla")
    public List<PosicionDTO> obtenerTabla() {
        return servicioTabla.obtenerTabla();
    }

    @PostMapping("/partidos")
    public ResponseEntity<Partido> crearPartido(@RequestBody PartidoRequestDTO partidoDTO) {
        Partido nuevoPartido = servicioTabla.crearPartido(partidoDTO);
        return new ResponseEntity<>(nuevoPartido, HttpStatus.CREATED);
    }

 
    @PutMapping("/partidos/{id}")
    public ResponseEntity<Partido> actualizarPartido(@PathVariable Integer id, @RequestBody PartidoRequestDTO partidoDTO) {
        Partido partidoActualizado = servicioTabla.actualizarPartido(id, partidoDTO);
        return new ResponseEntity<>(partidoActualizado, HttpStatus.OK);
    }
}
