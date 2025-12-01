package com.proyecto.Liga_CUT.servicio;

import com.proyecto.Liga_CUT.cliente.EquipoServiceCliente;
import com.proyecto.Liga_CUT.dto.EquipoDTO;
import com.proyecto.Liga_CUT.dto.PartidoRequestDTO;
import com.proyecto.Liga_CUT.dto.PosicionDTO;
import com.proyecto.Liga_CUT.modelo.Partido;
import com.proyecto.Liga_CUT.repositorio.PartidoRepository;

import jakarta.persistence.EntityNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class ServicioTabla {

    private final PartidoRepository partidoRepository;
    private final EquipoServiceCliente equipoServiceCliente;

    public ServicioTabla(PartidoRepository partidoRepository, EquipoServiceCliente equipoServiceCliente) {
        this.partidoRepository = partidoRepository;
        this.equipoServiceCliente = equipoServiceCliente;
    }

    @Transactional
    public Partido crearPartido(PartidoRequestDTO partidoDTO) {
        Partido nuevoPartido = new Partido();
        nuevoPartido.setIdEquipoLocal(partidoDTO.getIdEquipoLocal());
        nuevoPartido.setIdEquipoVisitante(partidoDTO.getIdEquipoVisitante());
        nuevoPartido.setFechaPlay(partidoDTO.getFechaPlay());
        nuevoPartido.setGolesLocal(partidoDTO.getGolesLocal());
        nuevoPartido.setGolesVisitante(partidoDTO.getGolesVisitante());
        nuevoPartido.setEstado(partidoDTO.getEstado());

        return partidoRepository.save(nuevoPartido);
    }

    @Transactional
    public Partido actualizarPartido(Integer id, PartidoRequestDTO partidoDTO) {
        Partido partidoExistente = partidoRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("No se encontró el partido con el ID: " + id));

        partidoExistente.setIdEquipoLocal(partidoDTO.getIdEquipoLocal());
        partidoExistente.setIdEquipoVisitante(partidoDTO.getIdEquipoVisitante());
        partidoExistente.setFechaPlay(partidoDTO.getFechaPlay());
        partidoExistente.setGolesLocal(partidoDTO.getGolesLocal());
        partidoExistente.setGolesVisitante(partidoDTO.getGolesVisitante());
        partidoExistente.setEstado(partidoDTO.getEstado());

        return partidoRepository.save(partidoExistente);
    }


    @Transactional(readOnly = true)
    public List<PosicionDTO> obtenerTabla() {
        // --- USANDO DATOS DE PRUEBA PARA EQUIPOS ---
        System.out.println("--- USANDO DATOS DE PRUEBA PARA EQUIPOS ---");
        List<EquipoDTO> todosLosEquipos = equipoServiceCliente.obtenerTodosLosEquipos();
        // --- FIN DE DATOS DE PRUEBA ---
        
        // Descomenta la siguiente línea para integración real
        // List<EquipoDTO> todosLosEquipos = equipoServiceCliente.obtenerTodosLosEquipos();

        List<Partido> partidosFinalizados = partidoRepository.findAllByEstado("finalizado");

        Map<Integer, PosicionDTO> estadisticas = todosLosEquipos.stream()
            .collect(Collectors.toMap(
                EquipoDTO::getIdEquipo,
                equipo -> new PosicionDTO(0, equipo.getIdEquipo().longValue(), equipo.getNombre(), 0, 0, 0, 0, 0, 0, 0, 0)
            ));

        for (Partido partido : partidosFinalizados) {
            PosicionDTO localStats = estadisticas.get(partido.getIdEquipoLocal());
            PosicionDTO visitanteStats = estadisticas.get(partido.getIdEquipoVisitante());

            if (localStats == null || visitanteStats == null) {
                continue; 
            }

            localStats.setPartidosJugados(localStats.getPartidosJugados() + 1);
            visitanteStats.setPartidosJugados(visitanteStats.getPartidosJugados() + 1);
            localStats.setGolesFavor(localStats.getGolesFavor() + partido.getGolesLocal());
            localStats.setGolesContra(localStats.getGolesContra() + partido.getGolesVisitante());
            visitanteStats.setGolesFavor(visitanteStats.getGolesFavor() + partido.getGolesVisitante());
            visitanteStats.setGolesContra(visitanteStats.getGolesContra() + partido.getGolesLocal());

            if (partido.getGolesLocal() > partido.getGolesVisitante()) {
                localStats.setGanados(localStats.getGanados() + 1);
                localStats.setPuntos(localStats.getPuntos() + 3);
                visitanteStats.setPerdidos(visitanteStats.getPerdidos() + 1);
            } else if (partido.getGolesVisitante() > partido.getGolesLocal()) {
                visitanteStats.setGanados(visitanteStats.getGanados() + 1);
                visitanteStats.setPuntos(visitanteStats.getPuntos() + 3);
                localStats.setPerdidos(localStats.getPerdidos() + 1);
            } else {
                localStats.setEmpatados(localStats.getEmpatados() + 1);
                localStats.setPuntos(localStats.getPuntos() + 1);
                visitanteStats.setEmpatados(visitanteStats.getEmpatados() + 1);
                visitanteStats.setPuntos(visitanteStats.getPuntos() + 1);
            }
        }

        List<PosicionDTO> tablaFinal = estadisticas.values().stream()
            .peek(dto -> dto.setDiferenciaGoles(dto.getGolesFavor() - dto.getGolesContra()))
            .sorted(
                Comparator.comparing(PosicionDTO::getPuntos).reversed()
                .thenComparing(PosicionDTO::getDiferenciaGoles, Comparator.reverseOrder())
                .thenComparing(PosicionDTO::getGolesFavor, Comparator.reverseOrder())
                .thenComparing(PosicionDTO::getNombre)
            )
            .collect(Collectors.toList());
        
        int pos = 1;
        for (PosicionDTO dto : tablaFinal) {
            dto.setPosicion(pos++);
        }

        return tablaFinal;
    }
}