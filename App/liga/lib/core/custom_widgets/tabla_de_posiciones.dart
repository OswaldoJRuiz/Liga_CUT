import 'package:flutter/material.dart';
import 'package:liga/data/db_equipos_helper.dart';
import 'package:liga/models/equipos_model.dart';

class TablaDePosiciones extends StatefulWidget {
  const TablaDePosiciones({super.key});

  @override
  State<TablaDePosiciones> createState() => _TablaDePosicionesState();
}

class _TablaDePosicionesState extends State<TablaDePosiciones> {
  late Future<List<Equipo>> _equiposFuture;

  @override
  void initState() {
    super.initState();
    _equiposFuture = DBEquiposHelper.getEquipos();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Encabezado tipo barra
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Row(
              children: const [
                Icon(Icons.table_chart, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  "Tabla de posiciones",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),

          FutureBuilder<List<Equipo>>(
            future: _equiposFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text(
                  "Error: ${snapshot.error}",
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text(
                  "No hay equipos registrados",
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                );
              }

              final equipos = snapshot.data!;
              equipos.sort((a, b) {
                if (b.puntos != a.puntos) {
                  return b.puntos.compareTo(a.puntos);
                }
                final difA = a.golesAFavor - a.golesEnContra;
                final difB = b.golesAFavor - b.golesEnContra;
                return difB.compareTo(difA);
              });

              return SizedBox(
                width: screenWidth,
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2C3E50) : Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(12),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: DataTable(
                    columnSpacing: 10,
                    horizontalMargin: 10,
                    headingRowHeight: 36,
                    headingTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    columns: const [
                      DataColumn(label: Text("Pos")),
                      DataColumn(label: Text("Equipo")),
                      DataColumn(label: Text("PJ")),
                      DataColumn(label: Text("V")),
                      DataColumn(label: Text("E")),
                      DataColumn(label: Text("D")),
                      DataColumn(label: Text("GF")),
                      DataColumn(label: Text("GC")),
                      DataColumn(label: Text("DG")),
                      DataColumn(label: Text("Pts")),
                    ],
                    rows: List.generate(equipos.length, (index) {
                      final equipo = equipos[index];
                      final dg = equipo.golesAFavor - equipo.golesEnContra;

                      return DataRow(
                        cells: [
                          DataCell(
                            Text(
                              "${index + 1}",
                              style: TextStyle(
                                color: isDark ? Colors.white70 : Colors.black87,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              equipo.nombre,
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              "${equipo.partidosJugados}",
                              style: TextStyle(
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              "${equipo.victorias}",
                              style: TextStyle(
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              "${equipo.empates}",
                              style: TextStyle(
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              "${equipo.derrotas}",
                              style: TextStyle(
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              "${equipo.golesAFavor}",
                              style: TextStyle(
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              "${equipo.golesEnContra}",
                              style: TextStyle(
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              "$dg",
                              style: TextStyle(
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              "${equipo.puntos}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.greenAccent
                                    : Colors.green[700],
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
