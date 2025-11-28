const API_URL = "http://127.0.0.1:8000";
let currentUser = null;
let token = localStorage.getItem('auth_token');

// ==================== AUTH FUNCTIONS ====================
function showLoginModal() {
    document.getElementById('loginModal').classList.remove('hidden');
}

function hideLoginModal() {
    document.getElementById('loginModal').classList.add('hidden');
}

function showRegisterModal() {
    document.getElementById('registerModal').classList.remove('hidden');
}

function hideRegisterModal() {
    document.getElementById('registerModal').classList.add('hidden');
}

function toggleAuthForms() {
    document.getElementById('loginForm').classList.toggle('hidden');
    document.getElementById('registerForm').classList.toggle('hidden');
}

// DEBUG: Función para decodificar el token JWT
function decodeJWT(token) {
    try {
        const base64Url = token.split('.')[1];
        const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
        const jsonPayload = decodeURIComponent(atob(base64).split('').map(function(c) {
            return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
        }).join(''));
        
        return JSON.parse(jsonPayload);
    } catch (error) {
        console.error('Error decodificando JWT:', error);
        return null;
    }
}

// 🔧 PARCHE CRÍTICO - Inicializar currentUser desde token
function initializeCurrentUser() {
    if (!currentUser && token) {
        console.log("🔧 Inicializando currentUser desde token...");
        try {
            const payload = JSON.parse(atob(token.split('.')[1]));
            currentUser = {
                email: payload.sub,
                user_type: payload.user_type
            };
            console.log(" currentUser inicializado desde token:", currentUser);
        } catch (e) {
            console.error(" Error inicializando currentUser:", e);
        }
    }
}

// Función mejorada para verificar token
async function verifyToken() {
    if (!token) {
        console.log(" No hay token disponible");
        currentUser = null;
        updateUIForUser();
        return false;
    }

    try {
        console.log("🔐 Verificando token...");
        
        // Decodificar token primero para debug
        const tokenData = decodeJWT(token);
        console.log("🔓 Token decodificado:", tokenData);
        
        const response = await fetch(`${API_URL}/auth/me`, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });

        if (response.ok) {
            const userData = await response.json();
            currentUser = userData;
            console.log(" Usuario autenticado:", currentUser);
            updateUIForUser();
            return true;
        } else {
            console.log(" Token inválido, limpiando...");
            localStorage.removeItem('auth_token');
            token = null;
            currentUser = null;
            updateUIForUser();
            return false;
        }
    } catch (error) {
        console.error(' Error verificando token:', error);
        localStorage.removeItem('auth_token');
        token = null;
        currentUser = null;
        updateUIForUser();
        return false;
    }
}

// ==================== FUNCIÓN CRÍTICA - AGREGAR PARTIDO ====================
function abrirModalAgregarPartido() {
    console.log('Función abrirModalAgregarPartido ejecutada');
    
    if (!currentUser || currentUser.user_type !== 'admin') {
        alert('Solo los administradores pueden registrar partidos');
        return;
    }
    
    const modal = document.getElementById('addMatchModal');
    if (modal) {
        modal.style.display = 'block';
        console.log('Modal abierto correctamente');
    } else {
        console.error('No se encontró el modal addMatchModal');
    }
}

window.abrirModalAgregarPartido = abrirModalAgregarPartido;

// Función mejorada para login
async function loginUser(email, password) {
    try {
        console.log(" Intentando login...");
        const response = await fetch(`${API_URL}/auth/login`, {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
            },
            body: JSON.stringify({ email, password })
        });

        if (!response.ok) {
            const errorData = await response.json();
            throw new Error(errorData.detail || 'Credenciales incorrectas');
        }

        const data = await response.json();
        console.log(" Login exitoso, datos:", data);
        
        localStorage.setItem('auth_token', data.access_token);
        token = data.access_token;
        currentUser = {
            email: data.email,
            user_type: data.user_type
        };

        // Verificar token inmediatamente después del login
        await verifyToken();
        updateUIForUser();
        hideLoginModal();
        alert(' Inicio de sesión exitoso');
        
    } catch (error) {
        console.error(' Error en login:', error);
        alert(' Error al iniciar sesión: ' + error.message);
    }
}

// Función mejorada para registro
async function registerUser(email, password) {
    try {
        console.log("📝 Intentando registro...");
        const response = await fetch(`${API_URL}/auth/register`, {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
            },
            body: JSON.stringify({ email, password })
        });

        if (!response.ok) {
            const errorData = await response.json();
            throw new Error(errorData.detail || 'Error en el registro');
        }

        const data = await response.json();
        console.log(" Registro exitoso, datos:", data);
        
        localStorage.setItem('auth_token', data.access_token);
        token = data.access_token;
        currentUser = {
            email: data.email,
            user_type: data.user_type
        };

        await verifyToken();
        updateUIForUser();
        hideRegisterModal();
        alert(' Registro exitoso');
        
    } catch (error) {
        console.error(' Error en registro:', error);
        alert(' Error en el registro: ' + error.message);
    }
}

function logout() {
    localStorage.removeItem('auth_token');
    token = null;
    currentUser = null;
    updateUIForUser();
    alert('🔒 Sesión cerrada');
}

function updateUIForUser() {
    const authSection = document.getElementById('authSection');
    const userSection = document.getElementById('userSection');
    const registroLink = document.getElementById('registroLink');
    const formsContainer = document.getElementById('formsContainer');
    const adminOnlyMessage = document.getElementById('adminOnlyMessage');

    if (currentUser) {
        console.log("🔄 Actualizando UI para usuario:", currentUser);
        
        // Ocultar botones de login/register
        if (authSection) authSection.classList.add('hidden');
        if (userSection) {
            userSection.classList.remove('hidden');
            document.getElementById('userEmail').textContent = currentUser.email;
        }

        // Mostrar/ocultar enlace de registro según el tipo de usuario
        if (registroLink) {
            if (currentUser.user_type === 'admin') {
                registroLink.classList.remove('hidden');
                console.log('🔓 Mostrando enlace Registro para admin');
            } else {
                registroLink.classList.add('hidden');
                console.log('🔒 Ocultando enlace Registro para usuario normal');
            }
        }

        // Mostrar/ocultar formularios de registro según el tipo de usuario
        if (formsContainer) {
            if (currentUser.user_type === 'admin') {
                formsContainer.classList.remove('hidden');
                if (adminOnlyMessage) adminOnlyMessage.classList.add('hidden');
                console.log('🔓 Mostrando formularios para admin');
            } else {
                formsContainer.classList.add('hidden');
                if (adminOnlyMessage) adminOnlyMessage.classList.remove('hidden');
                console.log('🔒 Ocultando formularios para usuario normal');
            }
        }
    } else {
        console.log("🔄 Actualizando UI para usuario no autenticado");
        
        // Mostrar botones de login/register
        if (authSection) authSection.classList.remove('hidden');
        if (userSection) userSection.classList.add('hidden');
        
        // Ocultar enlace de registro
        if (registroLink) registroLink.classList.add('hidden');
        
        // Ocultar formularios de registro
        if (formsContainer) formsContainer.classList.add('hidden');
        if (adminOnlyMessage) adminOnlyMessage.classList.remove('hidden');
    }
}

// 🔄 Función para inicializar tabs en index.html
function inicializarTabsIndex() {
    const tabBtns = document.querySelectorAll('[data-tab]');
    const tabSections = {
        equipos: document.getElementById('tab-equipos'),
        jugadores: document.getElementById('tab-jugadores')
    };

    function cambiarPestaña(tab) {
        Object.keys(tabSections).forEach(key => {
            if (tabSections[key]) {
                tabSections[key].classList.add('hidden');
            }
        });
        if (tabSections[tab]) {
            tabSections[tab].classList.remove('hidden');
        }
        
        // Actualizar estado activo de los botones
        tabBtns.forEach(b => b.classList.remove('ring-2', 'ring-white'));
        const activeBtn = document.getElementById(`tabBtn${tab.charAt(0).toUpperCase() + tab.slice(1)}`);
        if (activeBtn) {
            activeBtn.classList.add('ring-2', 'ring-white');
        }
    }

    // Inicializar con la pestaña de equipos activa
    if (tabSections.equipos) {
        cambiarPestaña('equipos');
    }

    // Agregar event listeners a los botones
    tabBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            const tab = btn.dataset.tab;
            cambiarPestaña(tab);
        });
    });

    console.log("Tabs inicializados correctamente");
}

//  Función para cargar equipos en el select
async function cargarEquiposEnSelect() {
    try {
        const selectEquipo = document.getElementById('equipo_id');
        if (!selectEquipo) {
            console.log(" No se encontró el select de equipos");
            return;
        }
        
        const response = await fetch(`${API_URL}/equipos/`);
        if (!response.ok) {
            throw new Error(`Error ${response.status} al cargar equipos`);
        }
        
        const equipos = await response.json();
        
        // Limpiar opciones excepto la primera
        while (selectEquipo.children.length > 1) {
            selectEquipo.removeChild(selectEquipo.lastChild);
        }
        
        // Agregar equipos
        equipos.forEach(equipo => {
            const option = document.createElement('option');
            option.value = equipo.id;
            option.textContent = `${equipo.nombre} (ID: ${equipo.id})`;
            selectEquipo.appendChild(option);
        });
        
        console.log(` ${equipos.length} equipos cargados en el select`);
    } catch (error) {
        console.error(" Error cargando equipos en select:", error);
    }
}

//  Función para cargar datos en index.html
function cargarDatosIndex() {
    console.log(" Cargando datos para index.html...");
    cargarEquipos();
    cargarJugadores();
    cargarEquiposEnSelect(); // Cargar equipos en el select
}

// ==================== EQUIPOS ====================
document.getElementById("formEquipo")?.addEventListener("submit", async (e) => {
    e.preventDefault();

    console.log(" Intentando crear equipo...");
    
    // Verificar autenticación primero
    const isAuthenticated = await verifyToken();
    if (!isAuthenticated) {
        alert(' Debes iniciar sesión para crear equipos');
        if (window.location.pathname.includes('index.html')) {
            window.location.href = 'inicio.html';
        } else {
            showLoginModal();
        }
        return;
    }

    // Verificar si es admin
    if (!currentUser || currentUser.user_type !== 'admin') {
        alert(' Solo los administradores pueden crear equipos');
        return;
    }

    const equipo = {
        id: parseInt(document.getElementById("idEquipo").value),
        nombre: document.getElementById("nombreEquipo").value,
        num_jugadores: parseInt(document.getElementById("numJugadores").value)
    };

    // Validar ID
    if (equipo.id > 1000000) {
        alert(" El ID es demasiado grande. Usa un número menor a 1,000,000");
        return;
    }

    console.log(" Enviando equipo:", equipo);
    console.log(" Token:", token);
    console.log(" Usuario:", currentUser);

    try {
        const res = await fetch(`${API_URL}/equipos`, {
            method: "POST",
            headers: { 
                "Content-Type": "application/json",
                "Authorization": `Bearer ${token}`
            },
            body: JSON.stringify(equipo)
        });

        console.log("📥 Respuesta del servidor:", res.status, res.statusText);

        if (!res.ok) {
            let errorMessage = `Error ${res.status}`;
            try {
                const errorData = await res.json();
                errorMessage = errorData.detail || errorMessage;
            } catch (e) {
                const errorText = await res.text();
                errorMessage = errorText || errorMessage;
            }
            throw new Error(errorMessage);
        }

        const equipoCreado = await res.json();
        console.log(" Equipo agregado:", equipoCreado);
        
        e.target.reset();
        await cargarEquipos();
        await cargarEquiposEnSelect(); //  ACTUALIZAR SELECT DESPUÉS DE CREAR EQUIPO
        alert(" Equipo agregado correctamente");

    } catch (err) {
        console.error(" Error completo al agregar equipo:", err);
        alert(" No se pudo agregar el equipo: " + err.message);
    }
});

async function cargarEquipos() {
    try {
        console.log(" Cargando equipos...");
        const res = await fetch(`${API_URL}/equipos`);
        
        if (!res.ok) {
            throw new Error(`Error ${res.status} al cargar equipos`);
        }
        
        const equipos = await res.json();
        const tbody = document.getElementById("tablaEquipos");
        if (!tbody) {
            console.log(" No se encontró tablaEquipos");
            return;
        }

        tbody.innerHTML = "";

        if (equipos.length === 0) {
            tbody.innerHTML = `<tr><td colspan="4" class="p-3 text-center text-gray-400">No hay equipos registrados</td></tr>`;
            return;
        }

        equipos.forEach(eq => {
            const fila = document.createElement("tr");
            fila.className = "hover:bg-gray-700 transition-colors";
            fila.innerHTML = `
                <td class="p-3 border-b border-gray-600">${eq.id}</td>
                <td class="p-3 border-b border-gray-600 font-semibold">${eq.nombre}</td>
                <td class="p-3 border-b border-gray-600">${eq.num_jugadores}</td>
                <td class="p-3 border-b border-gray-600">${eq.logo || 'Sin logo'}</td>
            `;
            tbody.appendChild(fila);
        });

        console.log(` ${equipos.length} equipos cargados en la tabla`);
    } catch (err) {
        console.error(" Error al cargar equipos:", err);
        const tbody = document.getElementById("tablaEquipos");
        if (tbody) {
            tbody.innerHTML = `<tr><td colspan="4" class="p-3 text-center text-red-400">Error al cargar equipos: ${err.message}</td></tr>`;
        }
    }
}

// ==================== JUGADORES ====================
document.getElementById("formJugador")?.addEventListener("submit", async (e) => {
    e.preventDefault();

    console.log(" Intentando crear jugador...");
    
    // Verificar autenticación primero
    const isAuthenticated = await verifyToken();
    if (!isAuthenticated) {
        alert(' Debes iniciar sesión para crear jugadores');
        if (window.location.pathname.includes('index.html')) {
            window.location.href = 'inicio.html';
        } else {
            showLoginModal();
        }
        return;
    }

    // Verificar si es admin
    if (!currentUser || currentUser.user_type !== 'admin') {
        alert(' Solo los administradores pueden crear jugadores');
        return;
    }

    const jugador = {
        id: parseInt(document.getElementById("id").value),
        nombre: document.getElementById("nombre").value,
        posicion: document.getElementById("posicion").value,
        dorsal: parseInt(document.getElementById("dorsal").value),
        goles: parseInt(document.getElementById("goles").value) || 0,
        equipo_id: parseInt(document.getElementById("equipo_id").value)
    };

    // Validaciones
    if (jugador.id > 1000000) {
        alert(" El ID es demasiado grande. Usa un número menor a 1,000,000");
        return;
    }

    if (!jugador.equipo_id) {
        alert(" Debes seleccionar un equipo válido");
        return;
    }

    console.log(" Enviando jugador:", jugador);
    console.log(" Token:", token);

    try {
        //  URL CORREGIDA - con barra final
        const res = await fetch(`${API_URL}/jugadores/`, {
            method: "POST",
            headers: { 
                "Content-Type": "application/json",
                "Authorization": `Bearer ${token}`
            },
            body: JSON.stringify(jugador)
        });

        console.log(" Respuesta del servidor:", res.status, res.statusText);

        if (!res.ok) {
            let errorMessage = `Error ${res.status}`;
            try {
                const errorData = await res.json();
                errorMessage = errorData.detail || errorMessage;
                
                // Mensajes más específicos
                if (errorMessage.includes('equipo_id') || errorMessage.includes('ForeignKeyViolation')) {
                    errorMessage = " El equipo seleccionado no existe o fue eliminado. Recarga la página.";
                }
                if (errorMessage.includes('dorsal')) {
                    errorMessage = " El dorsal ya está en uso por otro jugador.";
                }
                if (errorMessage.includes('ID')) {
                    errorMessage = " El ID del jugador ya existe.";
                }
            } catch (e) {
                const errorText = await res.text();
                errorMessage = errorText || errorMessage;
            }
            throw new Error(errorMessage);
        }

        const jugadorCreado = await res.json();
        console.log(" Jugador agregado:", jugadorCreado);

        e.target.reset();
        await cargarJugadores();
        alert(" Jugador agregado correctamente");
    } catch (err) {
        console.error(" Error al agregar el jugador:", err);
        
        // Mensaje más específico para "Failed to fetch"
        if (err.message.includes('Failed to fetch')) {
            alert(" Error de conexión con el servidor. Verifica que el backend esté funcionando.");
        } else {
            alert(" Error al agregar el jugador: " + err.message);
        }
    }
});

async function cargarJugadores() {
    try {
        console.log(" Cargando jugadores...");
        const res = await fetch(`${API_URL}/jugadores`);
        
        if (!res.ok) {
            throw new Error(`Error ${res.status} al cargar jugadores`);
        }
        
        const jugadores = await res.json();
        const tbody = document.getElementById("tablaJugadores");
        if (!tbody) {
            console.log(" No se encontró tablaJugadores");
            return;
        }

        tbody.innerHTML = "";

        if (jugadores.length === 0) {
            tbody.innerHTML = `<tr><td colspan="6" class="p-3 text-center text-gray-400">No hay jugadores registrados</td></tr>`;
            return;
        }

        jugadores.forEach(j => {
            const fila = document.createElement("tr");
            fila.className = "hover:bg-gray-700 transition-colors";
            fila.innerHTML = `
                <td class="p-3 border-b border-gray-600">${j.id}</td>
                <td class="p-3 border-b border-gray-600">${j.nombre}</td>
                <td class="p-3 border-b border-gray-600">${j.posicion}</td>
                <td class="p-3 border-b border-gray-600">${j.dorsal}</td>
                <td class="p-3 border-b border-gray-600">${j.goles}</td>
                <td class="p-3 border-b border-gray-600">${j.equipo_id}</td>
            `;
            tbody.appendChild(fila);
        });

        console.log(` ${jugadores.length} jugadores cargados en la tabla`);
    } catch (err) {
        console.error(" Error al cargar jugadores:", err);
        const tbody = document.getElementById("tablaJugadores");
        if (tbody) {
            tbody.innerHTML = `<tr><td colspan="6" class="p-3 text-center text-red-400">Error al cargar jugadores: ${err.message}</td></tr>`;
        }
    }
}

// ==================== EVENT LISTENERS ====================
document.addEventListener('DOMContentLoaded', function() {
    console.log("🚀 Inicializando aplicación...");
    console.log("📍 Página actual:", window.location.pathname);
    
    // Inicializar currentUser desde token si existe
    initializeCurrentUser();
    
    // Verificar si hay token al cargar la página
    if (token) {
        verifyToken();
    } else {
        updateUIForUser();
    }
    
    // Event listeners para login/register (solo en inicio.html)
    document.getElementById('loginBtn')?.addEventListener('click', showLoginModal);
    document.getElementById('registerBtn')?.addEventListener('click', showRegisterModal);
    document.getElementById('showRegister')?.addEventListener('click', toggleAuthForms);
    document.getElementById('showLogin')?.addEventListener('click', toggleAuthForms);
    document.getElementById('closeLoginModal')?.addEventListener('click', hideLoginModal);
    document.getElementById('closeRegisterModal')?.addEventListener('click', hideRegisterModal);
    document.getElementById('logoutBtn')?.addEventListener('click', logout);

    // Form submissions (solo en inicio.html)
    document.getElementById('loginForm')?.addEventListener('submit', function(e) {
        e.preventDefault();
        const email = document.getElementById('loginEmail').value;
        const password = document.getElementById('loginPassword').value;
        loginUser(email, password);
    });

    document.getElementById('registerForm')?.addEventListener('submit', function(e) {
        e.preventDefault();
        const email = document.getElementById('registerEmail').value;
        const password = document.getElementById('registerPassword').value;
        registerUser(email, password);
    });

    // Inicializar tabs (solo en index.html)
    if (document.querySelector('[data-tab]')) {
        console.log("📑 Inicializando tabs...");
        inicializarTabsIndex();
    }

    // Cargar datos (solo en index.html)
    if (document.getElementById('tablaEquipos') || document.getElementById('tablaJugadores')) {
        console.log("📊 Cargando datos iniciales...");
        cargarDatosIndex();
    }
});

// Función para debuggear el estado de auth
function debugAuth() {
    console.log("🔍 DEBUG AUTH:");
    console.log("Token:", token);
    console.log("Current User:", currentUser);
    console.log("User Type:", currentUser?.user_type);
    
    if (token) {
        const tokenData = decodeJWT(token);
        console.log("🔓 Token decodificado:", tokenData);
    }
}

// Ejecutar debug al cargar (opcional)
setTimeout(debugAuth, 2000);


// ==================== CALENDARIO FUNCTIONS ====================
let teams = [];
let matches = [];
let currentFilter = 'all';

// Función para verificar autenticación antes de acciones de admin
async function verificarAuthAdmin() {
    if (!token) {
        alert(' Debes iniciar sesión para realizar esta acción');
        showLoginModal();
        return false;
    }
    
    if (!currentUser) {
        await verifyToken();
    }
    
    if (!currentUser || currentUser.user_type !== 'admin') {
        alert(' Solo los administradores pueden realizar esta acción');
        return false;
    }
    
    return true;
}

// Función para obtener iniciales
function getInitials(name) {
    if (!name) return '??';
    return name.split(' ').map(word => word[0]).join('').toUpperCase().substring(0, 2);
}

// Función para formatear fecha
function formatDate(dateString) {
    const options = { year: 'numeric', month: 'long', day: 'numeric' };
    return new Date(dateString).toLocaleDateString('es-ES', options);
}

// Función para formatear fecha en formato YYYY-MM-DD
function formatearFechaParaInput(fecha) {
    const date = new Date(fecha);
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
}

// Función para cargar equipos en selects del calendario
async function cargarEquiposCalendario() {
    try {
        const response = await fetch(`${API_URL}/equipos/`);
        if (!response.ok) throw new Error('Error cargando equipos');
        teams = await response.json();
        poblarSelectsEquipos();
    } catch (error) {
        console.error('Error cargando equipos para calendario:', error);
    }
}

// Función para poblar los selects de equipos
function poblarSelectsEquipos() {
    const localSelect = document.getElementById('localTeam');
    const visitorSelect = document.getElementById('visitorTeam');
    
    if (!localSelect || !visitorSelect) return;
    
    localSelect.innerHTML = '<option value="">Seleccionar equipo local</option>';
    visitorSelect.innerHTML = '<option value="">Seleccionar equipo visitante</option>';
    
    teams.forEach(team => {
        const option = `<option value="${team.id}">${team.nombre}</option>`;
        localSelect.innerHTML += option;
        visitorSelect.innerHTML += option;
    });
}

// Función para cargar partidos desde la API
async function cargarPartidos() {
    const loadingState = document.getElementById('loadingState');
    const matchesContainer = document.getElementById('matchesContainer');
    const noMatchesMessage = document.getElementById('noMatchesMessage');
    const errorMessage = document.getElementById('errorMessage');

    if (!loadingState || !matchesContainer) return;

    loadingState.classList.remove('hidden');
    matchesContainer.classList.add('hidden');
    if (noMatchesMessage) noMatchesMessage.classList.add('hidden');
    if (errorMessage) errorMessage.classList.add('hidden');

    try {
        const response = await fetch(`${API_URL}/calendario/`);
        if (!response.ok) {
            throw new Error(`Error ${response.status}: ${response.statusText}`);
        }
        
        matches = await response.json();
        renderizarPartidos();
        
    } catch (error) {
        console.error('Error cargando partidos:', error);
        if (errorMessage) {
            document.getElementById('errorText').textContent = error.message;
            errorMessage.classList.remove('hidden');
        }
    } finally {
        loadingState.classList.add('hidden');
    }
}

// Función para renderizar partidos
function renderizarPartidos() {
    const container = document.getElementById('matchesContainer');
    const noMatchesMessage = document.getElementById('noMatchesMessage');
    
    if (!container) return;

    const filteredMatches = currentFilter === 'all' 
        ? matches 
        : matches.filter(match => match.status === currentFilter);

    if (filteredMatches.length === 0) {
        container.classList.add('hidden');
        if (noMatchesMessage) noMatchesMessage.classList.remove('hidden');
        return;
    }

    container.innerHTML = '';
    container.classList.remove('hidden');
    if (noMatchesMessage) noMatchesMessage.classList.add('hidden');

    filteredMatches.forEach(match => {
        const localTeam = teams.find(t => t.id === match.local_team_id);
        const visitorTeam = teams.find(t => t.id === match.visitor_team_id);
        
        if (!localTeam || !visitorTeam) return;

        const matchCard = document.createElement('div');
        matchCard.className = 'match-card bg-gray-800 rounded-2xl shadow-lg border border-gray-700 overflow-hidden';
        
        // Determinar qué botones mostrar según permisos
        const isAdmin = currentUser && currentUser.user_type === 'admin';
        let actionButtons = '';
        
        if (isAdmin) {
            if (match.status === 'pending') {
                actionButtons = `
                    <button onclick="iniciarPartido(${match.id})" class="bg-blue-600 hover:bg-blue-700 text-white px-3 py-1 rounded text-sm transition-colors">
                        Iniciar Partido
                    </button>
                `;
            } else if (match.status === 'in-progress') {
                actionButtons = `
                    <button onclick="abrirModalActualizarMarcador(${match.id})" class="bg-yellow-600 hover:bg-yellow-700 text-white px-3 py-1 rounded text-sm transition-colors">
                        Actualizar Marcador
                    </button>
                    <button onclick="finalizarPartido(${match.id})" class="bg-green-600 hover:bg-green-700 text-white px-3 py-1 rounded text-sm transition-colors">
                        Finalizar
                    </button>
                `;
            } else if (match.status === 'finished') {
                actionButtons = `
                    <button onclick="abrirModalActualizarMarcador(${match.id})" class="bg-gray-600 hover:bg-gray-700 text-white px-3 py-1 rounded text-sm transition-colors">
                        Ver Detalles
                    </button>
                `;
            }
        } else {
            // Usuarios normales solo ven información
            actionButtons = `
                <span class="text-gray-400 text-sm">Solo lectura</span>
            `;
        }

        matchCard.innerHTML = `
            <div class="p-6">
                <!-- Encabezado con estado -->
                <div class="flex justify-between items-center mb-4">
                    <span class="status-${match.status} text-white px-3 py-1 rounded-full text-xs font-semibold">
                        ${obtenerTextoEstado(match.status)}
                    </span>
                    <span class="text-gray-400 text-sm">${formatDate(match.date)}</span>
                </div>

                <!-- Equipos y marcador -->
                <div class="text-center mb-4">
                    <div class="flex items-center justify-between mb-4">
                        <div class="text-center flex-1">
                            <div class="bg-blue-500 rounded-full w-12 h-12 flex items-center justify-center text-white font-bold mx-auto mb-2">
                                ${getInitials(localTeam.nombre)}
                            </div>
                            <h3 class="font-semibold text-sm">${localTeam.nombre}</h3>
                            <div class="text-2xl font-bold mt-1">${match.local_score}</div>
                        </div>
                        
                        <div class="mx-4">
                            <div class="text-gray-400 text-sm">VS</div>
                            <div class="text-gray-500 text-xs">${match.time}</div>
                        </div>
                        
                        <div class="text-center flex-1">
                            <div class="bg-red-500 rounded-full w-12 h-12 flex items-center justify-center text-white font-bold mx-auto mb-2">
                                ${getInitials(visitorTeam.nombre)}
                            </div>
                            <h3 class="font-semibold text-sm">${visitorTeam.nombre}</h3>
                            <div class="text-2xl font-bold mt-1">${match.visitor_score}</div>
                        </div>
                    </div>
                    
                    <div class="text-gray-400 text-sm">
                        <svg class="w-4 h-4 inline mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"></path>
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"></path>
                        </svg>
                        ${match.location}
                    </div>
                </div>

                <!-- Acciones -->
                <div class="flex justify-center space-x-2">
                    ${actionButtons}
                </div>
            </div>
        `;

        container.appendChild(matchCard);
    });
}

// Funciones para el texto del estado
function obtenerTextoEstado(status) {
    const statusMap = {
        'pending': 'Pendiente',
        'in-progress': 'En Juego',
        'finished': 'Finalizado',
        'cancelled': 'Cancelado'
    };
    return statusMap[status] || 'Desconocido';
}

// Funciones de los modales
async function abrirModalActualizarMarcador(matchId) {
    const esAdmin = await verificarAuthAdmin();
    if (!esAdmin) return;

    const match = matches.find(m => m.id === matchId);
    if (!match) return;

    const localTeam = teams.find(t => t.id === match.local_team_id);
    const visitorTeam = teams.find(t => t.id === match.visitor_team_id);

    document.getElementById('editingMatchId').value = matchId;
    document.getElementById('localTeamName').textContent = localTeam.nombre;
    document.getElementById('visitorTeamName').textContent = visitorTeam.nombre;
    document.getElementById('localScore').value = match.local_score;
    document.getElementById('visitorScore').value = match.visitor_score;

    // Cambiar el texto del botón según el estado
    const submitButton = document.querySelector('#scoreForm button[type="submit"]');
    if (match.status === 'finished') {
        submitButton.textContent = 'Actualizar Marcador (Partido Finalizado)';
        submitButton.className = 'bg-gray-600 hover:bg-gray-700 text-white px-4 py-2 rounded-lg transition-colors';
    } else {
        submitButton.textContent = 'Actualizar Marcador';
        submitButton.className = 'bg-green-600 hover:bg-green-700 text-white px-4 py-2 rounded-lg transition-colors';
    }

    document.getElementById('updateScoreModal').style.display = 'block';
}

function cerrarModalAgregarPartido() {
    document.getElementById('addMatchModal').style.display = 'none';
    document.getElementById('matchForm').reset();
}

async function abrirModalActualizarMarcador(matchId) {
    const esAdmin = await verificarAuthAdmin();
    if (!esAdmin) return;

    const match = matches.find(m => m.id === matchId);
    if (!match) return;

    const localTeam = teams.find(t => t.id === match.local_team_id);
    const visitorTeam = teams.find(t => t.id === match.visitor_team_id);

    document.getElementById('editingMatchId').value = matchId;
    document.getElementById('localTeamName').textContent = localTeam.nombre;
    document.getElementById('visitorTeamName').textContent = visitorTeam.nombre;
    document.getElementById('localScore').value = match.local_score;
    document.getElementById('visitorScore').value = match.visitor_score;

    document.getElementById('updateScoreModal').style.display = 'block';
}

function cerrarModalActualizarMarcador() {
    document.getElementById('updateScoreModal').style.display = 'none';
}

// Funciones de los filtros
function filtrarPartidos(status) {
    currentFilter = status;
    document.querySelectorAll('.filter-btn').forEach(btn => btn.classList.remove('active'));
    event.target.classList.add('active');
    renderizarPartidos();
}

// Funciones para manejar partidos (SOLO ADMINS)
async function agregarPartido(event) {
    event.preventDefault();
    
    const esAdmin = await verificarAuthAdmin();
    if (!esAdmin) return;

    const localTeamId = parseInt(document.getElementById('localTeam').value);
    const visitorTeamId = parseInt(document.getElementById('visitorTeam').value);
    
    if (localTeamId === visitorTeamId) {
        alert(' Los equipos no pueden ser iguales');
        return;
    }

    // Obtener el año de la fecha seleccionada
    const fechaInput = document.getElementById('matchDate').value;
    const year = new Date(fechaInput).getFullYear();

    const nuevoPartido = {
        local_team_id: localTeamId,
        visitor_team_id: visitorTeamId,
        location: document.getElementById('location').value,
        date: fechaInput,
        time: document.getElementById('matchTime').value,
        local_score: 0,      // ⬅ Campo requerido
        visitor_score: 0,    // ⬅ Campo requerido  
        status: "pending",   // ⬅ Campo requerido
        year: year          // ⬅¡ESTE ES EL CAMPO QUE FALTABA!
    };

    console.log(' ENVIANDO CON TODOS LOS CAMPOS REQUERIDOS:', nuevoPartido);

    try {
        const response = await fetch(`${API_URL}/calendario/`, {
            method: "POST",
            headers: { 
                "Content-Type": "application/json",
                "Authorization": `Bearer ${token}`
            },
            body: JSON.stringify(nuevoPartido)
        });

        console.log(' Respuesta del servidor - Status:', response.status);

        if (!response.ok) {
            let errorMessage = `Error ${response.status}: ${response.statusText}`;
            
            try {
                const errorData = await response.json();
                console.log(' Datos de error:', errorData);
                
                if (errorData.detail) {
                    if (typeof errorData.detail === 'string') {
                        errorMessage = errorData.detail;
                    } else if (Array.isArray(errorData.detail)) {
                        errorMessage = errorData.detail.map(err => {
                            if (err.loc && err.msg) {
                                return `Campo ${err.loc[1]}: ${err.msg}`;
                            }
                            return err.msg || JSON.stringify(err);
                        }).join('\n');
                    } else {
                        errorMessage = JSON.stringify(errorData.detail);
                    }
                }
            } catch (parseError) {
                console.error(' Error parseando respuesta de error:', parseError);
                const errorText = await response.text();
                errorMessage = errorText || errorMessage;
            }
            
            throw new Error(errorMessage);
        }

        const partidoCreado = await response.json();
        console.log(' Partido creado exitosamente:', partidoCreado);
        
        cerrarModalAgregarPartido();
        await cargarPartidos();
        alert(' Partido registrado correctamente');
        
    } catch (error) {
        console.error(' Error completo al crear partido:', error);
        alert(' Error al crear partido:\n' + error.message);
    }
}

async function actualizarMarcador(event) {
    event.preventDefault();
    
    const esAdmin = await verificarAuthAdmin();
    if (!esAdmin) return;
    
    const matchId = parseInt(document.getElementById('editingMatchId').value);
    const localScore = parseInt(document.getElementById('localScore').value);
    const visitorScore = parseInt(document.getElementById('visitorScore').value);
    
    // Buscar el partido actual para mantener su estado
    const partidoActual = matches.find(m => m.id === matchId);
    if (!partidoActual) {
        alert(' Error: No se encontró el partido');
        return;
    }
    
    try {
        const response = await fetch(`${API_URL}/calendario/${matchId}`, {
            method: "PUT",
            headers: { 
                "Content-Type": "application/json",
                "Authorization": `Bearer ${token}`
            },
            body: JSON.stringify({
                local_score: localScore,
                visitor_score: visitorScore,
                status: partidoActual.status // ⬅️ MANTENER el estado actual
            })
        });

        if (!response.ok) {
            const errorData = await response.json();
            throw new Error(errorData.detail || 'Error actualizando marcador');
        }

        const partidoActualizado = await response.json();
        console.log(' Marcador actualizado:', partidoActualizado);
        
        cerrarModalActualizarMarcador();
        await cargarPartidos(); // Recargar para ver cambios
        alert(' Marcador actualizado correctamente');
        
    } catch (error) {
        console.error(' Error actualizando marcador:', error);
        alert(' Error al actualizar marcador: ' + error.message);
    }
}
async function iniciarPartido(matchId) {
    const esAdmin = await verificarAuthAdmin();
    if (!esAdmin) return;

    try {
        const response = await fetch(`${API_URL}/calendario/${matchId}`, {
            method: "PUT",
            headers: { 
                "Content-Type": "application/json",
                "Authorization": `Bearer ${token}`
            },
            body: JSON.stringify({
                status: "in-progress"
            })
        });

        if (!response.ok) {
            const errorData = await response.json();
            throw new Error(errorData.detail || 'Error iniciando partido');
        }

        await cargarPartidos();
        alert(' Partido iniciado');
        
    } catch (error) {
        console.error(' Error iniciando partido:', error);
        alert(' Error al iniciar partido: ' + error.message);
    }
}

async function finalizarPartido(matchId) {
    const esAdmin = await verificarAuthAdmin();
    if (!esAdmin) return;

    if (!confirm('¿Estás seguro de que quieres finalizar este partido? Esta acción no se puede deshacer.')) {
        return;
    }

    try {
        const response = await fetch(`${API_URL}/calendario/${matchId}`, {
            method: "PUT",
            headers: { 
                "Content-Type": "application/json",
                "Authorization": `Bearer ${token}`
            },
            body: JSON.stringify({
                status: "finished"
            })
        });

        if (!response.ok) {
            const errorData = await response.json();
            throw new Error(errorData.detail || 'Error finalizando partido');
        }

        await cargarPartidos();
        alert(' Partido finalizado correctamente');
        
    } catch (error) {
        console.error(' Error finalizando partido:', error);
        alert(' Error al finalizar partido: ' + error.message);
    }
}

// Cerrar modales al hacer clic fuera
window.onclick = function(event) {
    const addModal = document.getElementById('addMatchModal');
    const scoreModal = document.getElementById('updateScoreModal');
    
    if (event.target === addModal) {
        cerrarModalAgregarPartido();
    }
    if (event.target === scoreModal) {
        cerrarModalActualizarMarcador();
    }
}

// Inicializar calendario cuando se carga la página
function inicializarCalendario() {
    if (document.getElementById('matchesContainer')) {
        console.log(" Inicializando calendario...");
        actualizarUIUsuarioCalendario();
        cargarEquiposCalendario();
        cargarPartidos();
        
        // Establecer fecha actual por defecto
        const dateInput = document.getElementById('matchDate');
        if (dateInput) {
            const today = new Date();
            dateInput.value = formatearFechaParaInput(today);
        }

        // Establecer hora por defecto (próxima hora en punto)
        const timeInput = document.getElementById('matchTime');
        if (timeInput) {
            const now = new Date();
            const nextHour = new Date(now.getTime() + 60 * 60 * 1000);
            const hours = String(nextHour.getHours()).padStart(2, '0');
            const minutes = '00';
            timeInput.value = `${hours}:${minutes}`;
        }
    }
}

// Función específica para actualizar UI en calendario
function actualizarUIUsuarioCalendario() {
    const adminSection = document.getElementById('adminSection');
    const userMessage = document.getElementById('userMessage');

    if (currentUser && currentUser.user_type === 'admin') {
        console.log(" Mostrando botones de admin en calendario");
        if (adminSection) adminSection.classList.remove('hidden');
        if (userMessage) userMessage.classList.add('hidden');
    } else {
        console.log(" Ocultando botones de admin en calendario");
        if (adminSection) adminSection.classList.add('hidden');
        if (userMessage) userMessage.classList.remove('hidden');
    }
}

// Función para notificar al calendario cuando cambia la autenticación
function notificarCambioAuthCalendario() {
    console.log(" Actualizando UI del calendario por cambio de auth");
    actualizarUIUsuarioCalendario();
    if (document.getElementById('matchesContainer')) {
        renderizarPartidos(); // Re-renderizar para mostrar/ocultar botones
    }
}

// Modificar las funciones de auth existentes para notificar al calendario
const originalUpdateUIForUser = updateUIForUser;
updateUIForUser = function() {
    originalUpdateUIForUser();
    notificarCambioAuthCalendario();
};

// Función temporal para debug - ejecuta esto en la consola del navegador
function debugCalendario() {
    console.log('=== DEBUG CALENDARIO ===');
    console.log('Token:', token);
    console.log('Current User:', currentUser);
    console.log('Es admin:', currentUser && currentUser.user_type === 'admin');
    console.log('API URL:', API_URL);
    
    // Verificar que los elementos existan
    console.log('Modal existe:', !!document.getElementById('addMatchModal'));
    console.log('Form existe:', !!document.getElementById('matchForm'));
    
    // Probar la conexión a la API
    fetch(`${API_URL}/calendario/`)
        .then(response => console.log('Conexión calendario:', response.status))
        .catch(error => console.log('Error conexión:', error));
}

// Inicializar calendario automáticamente si estamos en esa página
document.addEventListener('DOMContentLoaded', function() {
    inicializarCalendario();
});