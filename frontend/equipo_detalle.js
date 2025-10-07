const API_EQUIPOS = "http://127.0.0.1:8000/equipos";
const API_JUGADORES = "http://127.0.0.1:8000/jugadores";

async function cargarDetalle() {
  const params = new URLSearchParams(window.location.search);
  const id = params.get("id");

  const resEquipo = await fetch(`${API_EQUIPOS}/${id}`);
  const equipo = await resEquipo.json();

  const resJugadores = await fetch(API_JUGADORES);
  const jugadores = await resJugadores.json();

  const jugadoresEquipo = jugadores.filter(j => j.equipo_id === equipo.id);

  document.getElementById("equipoDetalle").innerHTML = `
    <div class="bg-[#1e293b] rounded-xl shadow-lg p-6">
      <img src="${equipo.logo}" alt="Logo" class="w-24 h-24 mx-auto mb-4 rounded-full object-contain">
      <h1 class="text-3xl font-bold text-center mb-6">${equipo.nombre}</h1>
      <p class="mb-4 text-center italic">"Somos un equipo que le gusta jugar ofensivo y vamos a ganar la liga del CUT."</p>
      <h2 class="text-xl font-semibold mb-2">Jugadores</h2>
      <ul class="space-y-1">
        ${jugadoresEquipo.map(j => `<li>${j.nombre} - ${j.posicion} (#${j.dorsal})</li>`).join("")}
      </ul>
    </div>
  `;
}

cargarDetalle();
