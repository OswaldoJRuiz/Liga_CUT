-- Crea la tabla 'partido' si no existe.
CREATE TABLE IF NOT EXISTS `partido` (
  `id_partido` int NOT NULL AUTO_INCREMENT,
  `id_equipo_local` int NOT NULL,
  `id_equipo_visitante` int NOT NULL,
  `fecha_play` datetime DEFAULT NULL,
  `goles_local` int NOT NULL DEFAULT '0',
  `goles_visitante` int NOT NULL DEFAULT '0',
  `estado` enum('pendiente','en_juego','finalizado') NOT NULL DEFAULT 'pendiente',
  PRIMARY KEY (`id_partido`),
  KEY `idx_partido_estado` (`estado`),
  KEY `idx_partido_fecha` (`fecha_play`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO `partido` (id_equipo_local, id_equipo_visitante, goles_local, goles_visitante, estado)
VALUES (1, 2, 3, 1, 'finalizado');
INSERT INTO `partido` (id_equipo_local, id_equipo_visitante, goles_local, goles_visitante, estado)
VALUES (3, 1, 2, 2, 'finalizado');