import { useEffect, useState } from 'react';

// Formulario
function FormularioPartido({ onPartidoAgregado }) {
  const [idLocal, setIdLocal] = useState('');
  const [idVisitante, setIdVisitante] = useState('');
  const [golesLocal, setGolesLocal] = useState(0);
  const [golesVisitante, setGolesVisitante] = useState(0);
  const [estado, setEstado] = useState('finalizado');
  
  const [error, setError] = useState(null);
  const [success, setSuccess] = useState(null);

  const handleSubmit = (e) => {
    e.preventDefault();
    setError(null);
    setSuccess(null);

    const partidoData = {
      idEquipoLocal: parseInt(idLocal),
      idEquipoVisitante: parseInt(idVisitante),
      golesLocal: parseInt(golesLocal),
      golesVisitante: parseInt(golesVisitante),
      estado: estado,
      fechaPlay: new Date().toISOString()
    };

    // Ruta relativa /api/partidos
    fetch('/api/partidos', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(partidoData),
    })
    .then(response => {
      if (!response.ok) {
        throw new Error('Error al registrar el partido.');
      }
      return response.json();
    })
    .then(() => {
      setSuccess('¡Partido registrado con éxito!');
      setIdLocal('');
      setIdVisitante('');
      setGolesLocal(0);
      setGolesVisitante(0);
      setEstado('finalizado');
      onPartidoAgregado();
    })
    .catch(err => {
      setError(err.message);
    });
  };

  return (
    <div className="bg-gray-800 p-6 rounded-lg shadow-lg">
      <h2 className="text-2xl font-bold text-white mb-6">Registrar Resultado</h2>
      <form onSubmit={handleSubmit} className="space-y-4">
        <div className="flex flex-col sm:flex-row space-y-4 sm:space-y-0 sm:space-x-4">
          <div className="flex-1">
            <label className="block text-sm font-medium text-gray-300">ID Local</label>
            <input type="number" value={idLocal} onChange={(e) => setIdLocal(e.target.value)} className="mt-1 block w-full bg-gray-700 border-gray-700 text-white rounded-md p-2" required />
          </div>
          <div className="flex-1">
            <label className="block text-sm font-medium text-gray-300">ID Visitante</label>
            <input type="number" value={idVisitante} onChange={(e) => setIdVisitante(e.target.value)} className="mt-1 block w-full bg-gray-700 border-gray-700 text-white rounded-md p-2" required />
          </div>
        </div>
        <div className="flex space-x-4">
          <div className="flex-1">
            <label className="block text-sm font-medium text-gray-300">Goles Local</label>
            <input type="number" value={golesLocal} onChange={(e) => setGolesLocal(e.target.value)} className="mt-1 block w-full bg-gray-700 border-gray-700 text-white rounded-md p-2" required />
          </div>
          <div className="flex-1">
            <label className="block text-sm font-medium text-gray-300">Goles Visitante</label>
            <input type="number" value={golesVisitante} onChange={(e) => setGolesVisitante(e.target.value)} className="mt-1 block w-full bg-gray-700 border-gray-700 text-white rounded-md p-2" required />
          </div>
        </div>
        <div>
          <label className="block text-sm font-medium text-gray-300">Estado</label>
          <select value={estado} onChange={(e) => setEstado(e.target.value)} className="mt-1 block w-full bg-gray-700 border-gray-700 text-white rounded-md p-2">
            <option value="finalizado">Finalizado</option>
            <option value="en_juego">En Juego</option>
            <option value="pendiente">Pendiente</option>
          </select>
        </div>
        <button type="submit" className="w-full bg-blue-500 hover:bg-blue-600 text-white font-bold py-2 px-4 rounded-lg transition-colors">Guardar Partido</button>
        {success && <p className="text-green-400 text-center">{success}</p>}
        {error && <p className="text-red-400 text-center">{error}</p>}
      </form>
    </div>
  );
}

// Tabla 
function TablaPosiciones({ tabla, loading, error }) {
  if (loading) return <div className="text-center text-xl text-gray-300">Cargando...</div>;
  if (error) return <div className="bg-red-900 border border-red-500 text-red-200 px-4 py-3 rounded-lg text-center"><strong className="font-bold">Error:</strong> {error}</div>;

  return (
    <div className="overflow-x-auto rounded-lg shadow-lg bg-gray-800">
      <table className="w-full text-sm sm:text-base text-left">
        <thead className="bg-gray-700 text-gray-300 uppercase tracking-wider">
          <tr>
            <th className="p-3 sm:p-4 text-center">Pos</th>
            <th className="p-3 sm:p-4">Equipo</th>
            <th className="p-3 sm:p-4 text-center">PJ</th>
            <th className="p-3 sm:p-4 text-center">G</th>
            <th className="p-3 sm:p-4 text-center">E</th>
            <th className="p-3 sm:p-4 text-center">P</th>
            <th className="p-3 sm:p-4 text-center">GF</th>
            <th className="p-3 sm:p-4 text-center">GC</th>
            <th className="p-3 sm:p-4 text-center" title="Diferencia de Goles">DG</th>
            <th className="p-3 sm:p-4 text-center font-bold">Pts</th>
          </tr>
        </thead>
        <tbody className="divide-y divide-gray-700">
          {tabla.length === 0 ? (
            <tr><td colSpan="10" className="p-4 text-center text-gray-400">No hay partidos finalizados.</td></tr>
          ) : (
            tabla.map((equipo) => (
              <tr key={equipo.equipoId} className="hover:bg-gray-700 transition-colors duration-200">
                <td className="p-3 sm:p-4 font-bold text-center text-gray-300">{equipo.posicion}</td>
                <td className="p-3 sm:p-4 font-medium text-white">{equipo.nombre}</td>
                <td className="p-3 sm:p-4 text-center text-gray-300">{equipo.partidosJugados}</td>
                <td className="p-3 sm:p-4 text-center text-green-400">{equipo.ganados}</td>
                <td className="p-3 sm:p-4 text-center text-yellow-400">{equipo.empatados}</td>
                <td className="p-3 sm:p-4 text-center text-red-400">{equipo.perdidos}</td>
                <td className="p-3 sm:p-4 text-center text-gray-300">{equipo.golesFavor}</td>
                <td className="p-3 sm:p-4 text-center text-gray-300">{equipo.golesContra}</td>
                <td className="p-3 sm:p-4 text-center text-gray-300">{equipo.diferenciaGoles}</td>
                <td className="p-3 sm:p-4 font-extrabold text-center text-blue-400">{equipo.puntos}</td>
              </tr>
            ))
          )}
        </tbody>
      </table>
    </div>
  );
}

//App Principal
function App() {
  const [tabla, setTabla] = useState([]);
  const [error, setError] = useState(null);
  const [loading, setLoading] = useState(true);
  const [tablaKey, setTablaKey] = useState(0);

  const fetchTabla = () => {
    setLoading(true);
    fetch('/api/tabla')
      .then(response => {
        if (!response.ok) throw new Error('Error de red o backend no disponible.');
        return response.json();
      })
      .then(data => {
        setTabla(data);
        setError(null);
      })
      .catch(error => setError(error.message))
      .finally(() => setLoading(false));
  };

  useEffect(() => { fetchTabla(); }, [tablaKey]);

  const handlePartidoAgregado = () => setTablaKey(prev => prev + 1);

  return (
    <div className="bg-transparent text-white min-h-screen p-4 sm:p-8 font-sans">
      <div className="max-w-7xl mx-auto">
        <header className="text-center mb-8">
          <h1 className="text-4xl sm:text-5xl font-bold text-blue-400">Panel de Resultados</h1>
          <p className="text-lg text-gray-400 mt-2">Liga CUT</p>
        </header>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          <div className="md:col-span-1"><FormularioPartido onPartidoAgregado={handlePartidoAgregado} /></div>
          <div className="md:col-span-2"><TablaPosiciones tabla={tabla} loading={loading} error={error} /></div>
        </div>
      </div>
    </div>
  );
}

export default App;