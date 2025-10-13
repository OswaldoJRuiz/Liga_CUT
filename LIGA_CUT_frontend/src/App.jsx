import React, { useState, useEffect } from 'react';

// --- Icon Components (SVG) ---
// Usamos componentes SVG para los iconos, lo que evita cargar fuentes externas.
const TrophyIcon = () => (
    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="h-5 w-5 mr-2 text-yellow-400">
        <path d="M6 9H4.5a2.5 2.5 0 0 1 0-5H6" />
        <path d="M18 9h1.5a2.5 2.5 0 0 0 0-5H18" />
        <path d="M4 22h16" />
        <path d="M10 14.66V17c0 .55-.47.98-.97 1.21C7.87 18.75 7 20.24 7 22" />
        <path d="M14 14.66V17c0 .55.47.98.97 1.21C16.13 18.75 17 20.24 17 22" />
        <path d="M18 2H6v7a6 6 0 0 0 12 0V2Z" />
    </svg>
);

const AlertTriangleIcon = () => (
    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="h-6 w-6 mr-3 text-red-500">
        <path d="m21.73 18-8-14a2 2 0 0 0-3.46 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z" />
        <path d="M12 9v4" />
        <path d="M12 17h.01" />
    </svg>
);

// --- Helper Components ---

// Muestra un mensaje de carga mientras se obtienen los datos.
const LoadingSpinner = () => (
    <div className="flex flex-col items-center justify-center p-12 text-gray-500 dark:text-gray-400">
        <svg className="animate-spin h-8 w-8 text-blue-500 mb-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
            <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
            <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
        </svg>
        <p className="text-lg">Cargando tabla de posiciones...</p>
    </div>
);

// Muestra un mensaje de error si la API falla.
const ErrorMessage = ({ message }) => (
    <div className="bg-red-50 dark:bg-red-900/20 border-l-4 border-red-400 p-6 rounded-r-lg" role="alert">
        <div className="flex items-center">
            <AlertTriangleIcon />
            <div>
                <p className="font-bold text-red-800 dark:text-red-300">Ocurrió un Error</p>
                <p className="text-sm text-red-700 dark:text-red-400">{message}</p>
            </div>
        </div>
    </div>
);

// --- Main Application Component ---
export default function App() {
    // Definimos los estados para guardar los datos, el estado de carga y los errores.
    const [posiciones, setPosiciones] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    const API_URL = 'http://localhost:8080/api/tabla';

    // useEffect se ejecuta cuando el componente se monta por primera vez.
    // Es el lugar perfecto para hacer llamadas a APIs.
    useEffect(() => {
        const fetchPosiciones = async () => {
            try {
                setLoading(true);
                setError(null);
                
                const response = await fetch(API_URL);
                if (!response.ok) {
                    throw new Error(`Error ${response.status}: No se pudo obtener la información. ¿Está el backend corriendo?`);
                }
                const data = await response.json();
                setPosiciones(data);
            } catch (err) {
                setError(err.message);
            } finally {
                setLoading(false);
            }
        };

        fetchPosiciones();
    }, []); // El array vacío asegura que este efecto se ejecute solo una vez.

    // Función para renderizar el contenido principal basado en el estado.
    const renderContent = () => {
        if (loading) {
            return <LoadingSpinner />;
        }
        if (error) {
            return <ErrorMessage message={error} />;
        }
        if (posiciones.length === 0) {
            return <ErrorMessage message="No hay datos de posiciones disponibles para mostrar en este momento." />;
        }
        return (
            <div className="overflow-x-auto">
                <table className="min-w-full divide-y divide-gray-200 dark:divide-gray-700">
                    <thead className="bg-gray-50 dark:bg-gray-800">
                        <tr>
                            {['Pos', 'Equipo', 'PJ', 'PG', 'PE', 'PP', 'GF', 'GC', 'DG', 'Pts'].map((header, index) => (
                                <th key={header} scope="col" className={`px-4 py-3 text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider ${index > 1 ? 'text-center' : 'text-left'}`}>
                                    {header}
                                </th>
                            ))}
                        </tr>
                    </thead>
                    <tbody className="bg-white dark:bg-gray-900 divide-y divide-gray-200 dark:divide-gray-700">
                        {posiciones.map((equipo) => (
                            <tr key={equipo.equipoId} className="hover:bg-gray-50 dark:hover:bg-gray-800/50 transition-colors">
                                <td className="px-4 py-4 whitespace-nowrap text-sm font-semibold text-gray-900 dark:text-white text-center">{equipo.posicion}</td>
                                <td className="px-4 py-4 whitespace-nowrap text-sm font-medium text-gray-900 dark:text-white flex items-center">
                                    {equipo.posicion === 1 && <TrophyIcon />}
                                    {equipo.nombre}
                                </td>
                                <td className="px-4 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-400 text-center">{equipo.partidosJugados}</td>
                                <td className="px-4 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-400 text-center">{equipo.ganados}</td>
                                <td className="px-4 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-400 text-center">{equipo.empatados}</td>
                                <td className="px-4 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-400 text-center">{equipo.perdidos}</td>
                                <td className="px-4 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-400 text-center">{equipo.golesFavor}</td>
                                <td className="px-4 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-400 text-center">{equipo.golesContra}</td>
                                <td className="px-4 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-400 text-center">{equipo.diferenciaGoles}</td>
                                <td className="px-4 py-4 whitespace-nowrap text-sm font-bold text-gray-900 dark:text-white text-center">{equipo.puntos}</td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            </div>
        );
    };

    return (
        <div className="bg-gray-100 dark:bg-gray-900 min-h-screen font-sans text-gray-800 dark:text-gray-200 p-4 sm:p-6 lg:p-8">
            <div className="max-w-7xl mx-auto">
                <header className="text-center mb-8">
                    <h1 className="text-4xl sm:text-5xl font-bold text-gray-900 dark:text-white tracking-tight">
                        Tabla de Posiciones
                    </h1>
                    <p className="text-lg text-gray-600 dark:text-gray-400 mt-2">Liga Universitaria CUT</p>
                </header>

                <main className="bg-white dark:bg-gray-800/50 rounded-2xl shadow-lg ring-1 ring-black ring-opacity-5">
                    {renderContent()}
                </main>
                
                <footer className="text-center mt-8 text-sm text-gray-500 dark:text-gray-400">
                    <p>&copy; {new Date().getFullYear()} Resultados Liga CUT. Todos los derechos reservados.</p>
                </footer>
            </div>
        </div>
    );
}