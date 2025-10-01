// URL de los backends
const API_JUGADORES = "http://127.0.0.1:8000/jugadores";
const API_EQUIPOS   = "http://127.0.0.1:8000/equipos";

/* ============== TABS ============== */
function setActiveTab(tabName) {
  const btnJug = document.getElementById("tabBtnJugadores");
  const btnEqp = document.getElementById("tabBtnEquipos");
  const secJug = document.getElementById("tab-jugadores");
  const secEqp = document.getElementById("tab-equipos");

  const activeClasses = "font-semibold border-blue-500 text-blue-700";
  const inactiveClasses = "font-normal text-gray-600";

  if (tabName === "jugadores") {
    secJug.classList.remove("hidden");
    secEqp.classList.add("hidden");
    btnJug.classList.add(...activeClasses.split(" "));
    btnEqp.classList.remove(...activeClasses.split(" "));
    btnEqp.classList.add(...inactiveClasses.split(" "));
  } else {
    secEqp.classList.remove("hidden");
    secJug.classList.add("hidden");
    btnEqp.classList.add(...activeClasses.split(" "));
    btnJug.classList.remove(...activeClasses.split(" "));
    btnJug.classList.add(...inactiveClasses.split(" "));
  }
}

document.getElementById("tabBtnJugadores").addEventListener("click", () => setActiveTab("jugadores"));
document.getElementById("tabBtnEquipos").addEventListener("click", () => setActiveTab("equipos"));

/* ============== JUGADORES (TABLA) ============== */
async function cargarJugadores() {
  try {
    const res = await fetch(API_JUGADORES);
    const data = await res.json();
    const tabla = document.getElementById("tablaJugadores");
    tabla.innerHTML = "";
    data.forEach(j => {
      tabla.innerHTML += `
        <tr class="border-b">
          <td class="p-2">${j.id}</td>
          <td class="p-2">${j.nombre}</td>
          <td class="p-2">${j.posicion}</td>
          <td class="p-2">${j.dorsal}</td>
        </tr>`;
    });
  } catch (e) {
    console.error(e);
    alert("No se pudo cargar la lista de jugadores");
  }
}

document.getElementById("formJugador").addEventListener("submit", async (e) => {
  e.preventDefault();
  const jugador = {
    id: parseInt(document.getElementById("id").value),
    nombre: document.getElementById("nombre").value,
    posicion: document.getElementById("posicion").value,
    dorsal: parseInt(document.getElementById("dorsal").value),
    goles: 0,
    equipo_id: parseInt(document.getElementById("equipoJugador").value) || null // si tienes select de equipo
  };
  try {
    await fetch(API_JUGADORES, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(jugador)
    });
    e.target.reset();
    cargarJugadores();
    cargarEquiposTarjetas(); // refrescar vista de equipos
  } catch (err) {
    console.error(err);
    alert("No se pudo agregar el jugador");
  }
});

/* ============== EQUIPOS (TABLA) ============== */
async function cargarEquipos() {
  try {
    const res = await fetch(API_EQUIPOS);
    const data = await res.json();
    const tabla = document.getElementById("tablaEquipos");
    tabla.innerHTML = "";
    data.forEach(eq => {
      tabla.innerHTML += `
        <tr class="border-b">
          <td class="p-2">${eq.id}</td>
          <td class="p-2">${eq.nombre}</td>
          <td class="p-2">${eq.num_jugadores}</td>
          <td class="p-2">
            ${eq.logo ? `<img src="${eq.logo}" alt="logo" class="w-12 h-12 object-contain">` : "-"}
          </td>
        </tr>`;
    });
  } catch (e) {
    console.error(e);
    alert("No se pudo cargar la lista de equipos");
  }
}

document.getElementById("formEquipo").addEventListener("submit", async (e) => {
  e.preventDefault();

  const formData = new FormData();
  formData.append("id", document.getElementById("idEquipo").value);
  formData.append("nombre", document.getElementById("nombreEquipo").value);
  formData.append("num_jugadores", document.getElementById("numJugadores").value);
  formData.append("logo", document.getElementById("logo").files[0]); 

  try {
    await fetch(API_EQUIPOS, {
      method: "POST",
      body: formData
    });
    e.target.reset();
    cargarEquipos();
    cargarEquiposTarjetas(); // refrescar vista de equipos
  } catch (err) {
    console.error(err);
    alert("No se pudo agregar el equipo");
  }
});

/* ============== EQUIPOS (TARJETAS CON JUGADORES) ============== */
async function cargarEquiposTarjetas() {
  try {
    const resEquipos = await fetch(API_EQUIPOS);
    const equipos = await resEquipos.json();

    const resJugadores = await fetch(API_JUGADORES);
    const jugadores = await resJugadores.json();

    const container = document.getElementById("equiposContainer");
    if (!container) return; // por si no existe en esta página

    container.innerHTML = "";

    equipos.forEach(eq => {
      const jugadoresEquipo = jugadores.filter(j => j.equipo_id === eq.id);

      const jugadoresHtml = jugadoresEquipo.map(j =>
        `<li class="text-sm">${j.nombre} - ${j.posicion} (#${j.dorsal})</li>`
      ).join("");

      container.innerHTML += `
        <div onclick="verEquipo(${eq.id})"
          class="bg-[#1e293b] rounded-xl shadow-lg p-6 cursor-pointer hover:scale-105 transition">
          <img src="${eq.logo}" alt="Logo" class="w-20 h-20 mx-auto mb-4 rounded-full object-contain">
          <h2 class="text-xl font-semibold text-center mb-2">${eq.nombre}</h2>
          <ul class="text-center space-y-1">${jugadoresHtml || "<li>Sin jugadores</li>"}</ul>
        </div>
      `;
    });
  } catch (err) {
    console.error(err);
    alert("No se pudo cargar las tarjetas de equipos");
  }
}

function verEquipo(id) {
  window.location.href = `equipo_detalle.html?id=${id}`;
}

/* ============== INICIAL ============== */
setActiveTab("jugadores"); 
cargarJugadores();
cargarEquipos();
cargarEquiposTarjetas();
