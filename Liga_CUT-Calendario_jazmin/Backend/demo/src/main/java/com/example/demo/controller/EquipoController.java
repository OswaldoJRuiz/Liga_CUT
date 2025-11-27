package com.example.demo.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.example.demo.model.Equipo;
import com.example.demo.repository.EquipoRepository;

import java.util.List;

@RestController
@RequestMapping("/api/equipos")
public class EquipoController {

    private final EquipoRepository equipoRepository;

    public EquipoController(EquipoRepository equipoRepository) {
        this.equipoRepository = equipoRepository;
    }

    // GET 
    @GetMapping
    public List<Equipo> getAll() {
        return equipoRepository.findAll();
    }

    // POST 
    @PostMapping
    public Equipo create(@RequestBody Equipo equipo) {
        return equipoRepository.save(equipo);
    }

    // PUT 
    @PutMapping("/{id}")
    public ResponseEntity<Equipo> update(@PathVariable Long id, @RequestBody Equipo equipoDetails) {
        return equipoRepository.findById(id)
                .map(equipo -> {
                    equipo.setNombre(equipoDetails.getNombre());
                    equipo.setEscudo(equipoDetails.getEscudo());
                    equipo.setCentroUniversitario(equipoDetails.getCentroUniversitario());
                    Equipo updated = equipoRepository.save(equipo);
                    return ResponseEntity.ok(updated);
                })
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
public ResponseEntity<Void> delete(@PathVariable Long id) {
    if (!equipoRepository.existsById(id)) {
        return ResponseEntity.notFound().build();
    }
    equipoRepository.deleteById(id);
    return ResponseEntity.noContent().build();
}

}
