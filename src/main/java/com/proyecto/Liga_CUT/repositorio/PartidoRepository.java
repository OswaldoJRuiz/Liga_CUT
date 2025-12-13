package com.proyecto.Liga_CUT.repositorio;

import com.proyecto.Liga_CUT.modelo.Partido;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PartidoRepository extends JpaRepository<Partido, Integer> {
    
    /**
     * Busca todos los partidos que coincidan con un estado específico.
     * Spring Data JPA implementa este método automáticamente por su nombre.
     * @param estado El estado del partido a buscar (ej. "finalizado").
     * @return Una lista de partidos.
     */
    List<Partido> findAllByEstado(String estado);
}