package com.example.demo.repository;

import com.example.demo.model.Jornada;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface JornadaRepository extends JpaRepository<Jornada, Long> {
    boolean existsByNumero(int numero); 
}
