package com.example.demo.controller;

import com.example.demo.model.Partido;
import com.example.demo.repository.PartidoRepository;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/partidos")
public class PartidoController {

    private final PartidoRepository repo;

    public PartidoController(PartidoRepository repo) {
        this.repo = repo;
    }

    // Listar
    @GetMapping
    public List<Partido> getAll() { return repo.findAll(); }

    // Obtener por id
    @GetMapping("/{id}")
    public ResponseEntity<Partido> getById(@PathVariable Long id) {
        return repo.findById(id).map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // Crear
    @PostMapping
    public ResponseEntity<Partido> create(@RequestBody Partido body) {
        Partido saved = repo.save(body);
        return ResponseEntity.status(HttpStatus.CREATED).body(saved);
    }

    // Actualizar
    @PutMapping("/{id}")
    public ResponseEntity<Partido> update(@PathVariable Long id, @RequestBody Partido body) {
        return repo.findById(id).map(existing -> {
            existing.setJornada(body.getJornada());
            existing.setLocal(body.getLocal());
            existing.setVisitante(body.getVisitante());
            existing.setFecha(body.getFecha());
            existing.setHora(body.getHora());
            existing.setLugar(body.getLugar());
            existing.setMarcadorLocal(body.getMarcadorLocal());
            existing.setMarcadorVisitante(body.getMarcadorVisitante());
            existing.setEstado(body.getEstado());
            return ResponseEntity.ok(repo.save(existing));
        }).orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
     public ResponseEntity<Void> delete(@PathVariable Long id) {
      return repo.findById(id)
            .map(p -> {
                repo.delete(p);
                return ResponseEntity.noContent().<Void>build(); 
            })
            .orElse(ResponseEntity.notFound().build());
}

}
