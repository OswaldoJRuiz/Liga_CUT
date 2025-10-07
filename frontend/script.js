const API_URL = "http://127.0.0.1:8000";

// ==================== EQUIPOS ====================
document.getElementById("formEquipo").addEventListener("submit", async (e) => {
  e.preventDefault();

  const equipo = {
    id: parseInt(document.getElementById("idEquipo").value),
    nombre: document.getElementById("nombreEquipo").value,
    num_jugadores: parseInt(document.getElementById("numJugadores").value)
  };

  console.log("📤 Enviando equipo:", equipo);

  try {
    const res = await fetch(`${API_URL}/equipos`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(equipo)
    });

    if (!res.ok) {
      const errorData = await res.json();
      throw new Error(`Error ${res.status}: ${errorData.detail}`);
    }

    const equipoCreado = await res.json();
    console.log(" Equipo agregado:", equipoCreado);
    
    e.target.reset();
    await cargarEquipos();
    alert(" Equipo agregado correctamente");

  } catch (err) {
    console.error(" Error al agregar equipo:", err);
    alert("No se pudo agregar el equipo: " + err.message);
  }
});

async function cargarEquipos() {
  try {
    const res = await fetch(`${API_URL}/equipos`);
    
    if (!res.ok) {
      throw new Error(`Error ${res.status} al cargar equipos`);
    }
    
    const equipos = await res.json();
    const tbody = document.getElementById("tablaEquipos");
    tbody.innerHTML = "";

    if (equipos.length === 0) {
      tbody.innerHTML = `<tr><td colspan="4" class="p-3 text-center">No hay equipos registrados</td></tr>`;
      return;
    }

    equipos.forEach(eq => {
      const fila = document.createElement("tr");
      fila.innerHTML = `
        <td class="p-3 border-b border-[#3b82f6]/30">${eq.id}</td>
        <td class="p-3 border-b border-[#3b82f6]/30 font-semibold">${eq.nombre}</td>
        <td class="p-3 border-b border-[#3b82f6]/30">${eq.num_jugadores}</td>
        <td class="p-3 border-b border-[#3b82f6]/30">Sin logo</td>
      `;
      tbody.appendChild(fila);
    });
  } catch (err) {
    console.error("⚠️ Error al cargar equipos:", err);
    const tbody = document.getElementById("tablaEquipos");
    tbody.innerHTML = `<tr><td colspan="4" class="p-3 text-center text-red-400">Error al cargar equipos: ${err.message}</td></tr>`;
  }
}

// ==================== JUGADORES ====================
document.getElementById("formJugador").addEventListener("submit", async (e) => {
  e.preventDefault();

  const jugador = {
    id: parseInt(document.getElementById("id").value),
    nombre: document.getElementById("nombre").value,
    posicion: document.getElementById("posicion").value,
    dorsal: parseInt(document.getElementById("dorsal").value),
    goles: parseInt(document.getElementById("goles").value) || 0,
    equipo_id: parseInt(document.getElementById("equipo_id").value)
  };

  console.log("📤 Enviando jugador:", jugador);

  try {
    const res = await fetch(`${API_URL}/jugadores`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(jugador)
    });

    if (!res.ok) {
      const errorData = await res.json();
      throw new Error(`Error ${res.status}: ${errorData.detail}`);
    }

    const jugadorCreado = await res.json();
    console.log(" Jugador agregado:", jugadorCreado);

    e.target.reset();
    await cargarJugadores();
    alert(" Jugador agregado correctamente");

  } catch (err) {
    console.error(" No se pudo agregar el jugador:", err);
    alert("No se pudo agregar el jugador: " + err.message);
  }
});

async function cargarJugadores() {
  try {
    const res = await fetch(`${API_URL}/jugadores`);
    
    if (!res.ok) {
      throw new Error(`Error ${res.status} al cargar jugadores`);
    }
    
    const jugadores = await res.json();
    const tbody = document.getElementById("tablaJugadores");
    tbody.innerHTML = "";

    if (jugadores.length === 0) {
      tbody.innerHTML = `<tr><td colspan="6" class="p-3 text-center">No hay jugadores registrados</td></tr>`;
      return;
    }

    jugadores.forEach(j => {
      const fila = document.createElement("tr");
      fila.innerHTML = `
        <td class="p-3 border-b border-[#3b82f6]/30">${j.id}</td>
        <td class="p-3 border-b border-[#3b82f6]/30">${j.nombre}</td>
        <td class="p-3 border-b border-[#3b82f6]/30">${j.posicion}</td>
        <td class="p-3 border-b border-[#3b82f6]/30">${j.dorsal}</td>
        <td class="p-3 border-b border-[#3b82f6]/30">${j.goles}</td>
        <td class="p-3 border-b border-[#3b82f6]/30">${j.equipo_id}</td>
      `;
      tbody.appendChild(fila);
    });
  } catch (err) {
    console.error(" Error al cargar jugadores:", err);
    const tbody = document.getElementById("tablaJugadores");
    tbody.innerHTML = `<tr><td colspan="6" class="p-3 text-center text-red-400">Error al cargar jugadores: ${err.message}</td></tr>`;
  }
}

// ==================== CARGA INICIAL ====================
document.addEventListener('DOMContentLoaded', () => {
  console.log(" Cargando datos iniciales...");
  cargarEquipos();
  cargarJugadores();
});