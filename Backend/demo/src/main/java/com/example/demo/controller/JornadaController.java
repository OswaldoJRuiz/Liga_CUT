package com.example.demo.controller;

import com.example.demo.model.Jornada;
import com.example.demo.repository.JornadaRepository;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/jornadas")  
public class JornadaController {

    private final JornadaRepository repo;

    public JornadaController(JornadaRepository repo) {
        this.repo = repo;
    }

    // --- Listar todo ---
    @GetMapping
    public List<Jornada> getAll() {
        return repo.findAll();
    }

    // --- Obtener por id ---
    @GetMapping("/{id}")
    public ResponseEntity<Jornada> getById(@PathVariable Long id) {
        return repo.findById(id).map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // --- Crear ---
    @PostMapping
    public ResponseEntity<?> create(@RequestBody Jornada body) {
        // (Opcional) evita números de jornada duplicados
        if (repo.existsByNumero(body.getNumero())) {
            return ResponseEntity.status(HttpStatus.CONFLICT)
                    .body("Ya existe una jornada con numero=" + body.getNumero());
        }
        Jornada saved = repo.save(body);
        return ResponseEntity.status(HttpStatus.CREATED).body(saved);
    }

    // --- Actualizar ---
    @PutMapping("/{id}")
    public ResponseEntity<?> update(@PathVariable Long id, @RequestBody Jornada body) {
        // (Opcional) si quieres que el número de jornada sea único
        if (repo.existsByNumero(body.getNumero())) {
            // Permite el mismo número si es la misma jornada
            return repo.findById(id).map(existing -> {
                if (existing.getNumero() != body.getNumero()) {
                    return ResponseEntity.status(HttpStatus.CONFLICT)
                            .body("Ya existe una jornada con numero=" + body.getNumero());
                }
                return null; // placeholder, no se usa
            }).orElse(ResponseEntity.notFound().build());
        }

        return repo.findById(id).map(j -> {
            j.setNumero(body.getNumero());
            j.setFechaInicio(body.getFechaInicio());
            j.setFechaFin(body.getFechaFin());
            return ResponseEntity.ok(repo.save(j));
        }).orElse(ResponseEntity.notFound().build());
    }

    // --- Eliminar ---
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        return repo.findById(id).map(j -> {
            repo.delete(j);
            return ResponseEntity.noContent().<Void>build();
        }).orElse(ResponseEntity.notFound().build());
    }
}
