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
            console.log("✅ currentUser inicializado desde token:", currentUser);
        } catch (e) {
            console.error("❌ Error inicializando currentUser:", e);
        }
    }
}

// Función mejorada para verificar token
async function verifyToken() {
    if (!token) {
        console.log("❌ No hay token disponible");
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
            console.log("✅ Usuario autenticado:", currentUser);
            updateUIForUser();
            return true;
        } else {
            console.log("❌ Token inválido, limpiando...");
            localStorage.removeItem('auth_token');
            token = null;
            currentUser = null;
            updateUIForUser();
            return false;
        }
    } catch (error) {
        console.error('❌ Error verificando token:', error);
        localStorage.removeItem('auth_token');
        token = null;
        currentUser = null;
        updateUIForUser();
        return false;
    }
}

// Función mejorada para login
async function loginUser(email, password) {
    try {
        console.log("🔐 Intentando login...");
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
        console.log("✅ Login exitoso, datos:", data);
        
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
        alert('✅ Inicio de sesión exitoso');
        
    } catch (error) {
        console.error('❌ Error en login:', error);
        alert('❌ Error al iniciar sesión: ' + error.message);
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
        console.log("✅ Registro exitoso, datos:", data);
        
        localStorage.setItem('auth_token', data.access_token);
        token = data.access_token;
        currentUser = {
            email: data.email,
            user_type: data.user_type
        };

        await verifyToken();
        updateUIForUser();
        hideRegisterModal();
        alert('✅ Registro exitoso');
        
    } catch (error) {
        console.error('❌ Error en registro:', error);
        alert('❌ Error en el registro: ' + error.message);
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

    console.log("✅ Tabs inicializados correctamente");
}

// 🔄 Función para cargar equipos en el select
async function cargarEquiposEnSelect() {
    try {
        const selectEquipo = document.getElementById('equipo_id');
        if (!selectEquipo) {
            console.log("❌ No se encontró el select de equipos");
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
        
        console.log(`✅ ${equipos.length} equipos cargados en el select`);
    } catch (error) {
        console.error("❌ Error cargando equipos en select:", error);
    }
}

// 🔄 Función para cargar datos en index.html
function cargarDatosIndex() {
    console.log("📊 Cargando datos para index.html...");
    cargarEquipos();
    cargarJugadores();
    cargarEquiposEnSelect(); // ✅ NUEVA LÍNEA - Cargar equipos en el select
}

// ==================== EQUIPOS ====================
document.getElementById("formEquipo")?.addEventListener("submit", async (e) => {
    e.preventDefault();

    console.log("🔄 Intentando crear equipo...");
    
    // Verificar autenticación primero
    const isAuthenticated = await verifyToken();
    if (!isAuthenticated) {
        alert('❌ Debes iniciar sesión para crear equipos');
        if (window.location.pathname.includes('index.html')) {
            window.location.href = 'inicio.html';
        } else {
            showLoginModal();
        }
        return;
    }

    // Verificar si es admin
    if (!currentUser || currentUser.user_type !== 'admin') {
        alert('❌ Solo los administradores pueden crear equipos');
        return;
    }

    const equipo = {
        id: parseInt(document.getElementById("idEquipo").value),
        nombre: document.getElementById("nombreEquipo").value,
        num_jugadores: parseInt(document.getElementById("numJugadores").value)
    };

    // Validar ID
    if (equipo.id > 1000000) {
        alert("❌ El ID es demasiado grande. Usa un número menor a 1,000,000");
        return;
    }

    console.log("📤 Enviando equipo:", equipo);
    console.log("🔑 Token:", token);
    console.log("👤 Usuario:", currentUser);

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
        console.log("✅ Equipo agregado:", equipoCreado);
        
        e.target.reset();
        await cargarEquipos();
        await cargarEquiposEnSelect(); // ✅ ACTUALIZAR SELECT DESPUÉS DE CREAR EQUIPO
        alert("✅ Equipo agregado correctamente");

    } catch (err) {
        console.error("❌ Error completo al agregar equipo:", err);
        alert("❌ No se pudo agregar el equipo: " + err.message);
    }
});

async function cargarEquipos() {
    try {
        console.log("📊 Cargando equipos...");
        const res = await fetch(`${API_URL}/equipos`);
        
        if (!res.ok) {
            throw new Error(`Error ${res.status} al cargar equipos`);
        }
        
        const equipos = await res.json();
        const tbody = document.getElementById("tablaEquipos");
        if (!tbody) {
            console.log("❌ No se encontró tablaEquipos");
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

        console.log(`✅ ${equipos.length} equipos cargados en la tabla`);
    } catch (err) {
        console.error("⚠️ Error al cargar equipos:", err);
        const tbody = document.getElementById("tablaEquipos");
        if (tbody) {
            tbody.innerHTML = `<tr><td colspan="4" class="p-3 text-center text-red-400">Error al cargar equipos: ${err.message}</td></tr>`;
        }
    }
}

// ==================== JUGADORES ====================
document.getElementById("formJugador")?.addEventListener("submit", async (e) => {
    e.preventDefault();

    console.log("🔄 Intentando crear jugador...");
    
    // Verificar autenticación primero
    const isAuthenticated = await verifyToken();
    if (!isAuthenticated) {
        alert('❌ Debes iniciar sesión para crear jugadores');
        if (window.location.pathname.includes('index.html')) {
            window.location.href = 'inicio.html';
        } else {
            showLoginModal();
        }
        return;
    }

    // Verificar si es admin
    if (!currentUser || currentUser.user_type !== 'admin') {
        alert('❌ Solo los administradores pueden crear jugadores');
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
        alert("❌ El ID es demasiado grande. Usa un número menor a 1,000,000");
        return;
    }

    if (!jugador.equipo_id) {
        alert("❌ Debes seleccionar un equipo válido");
        return;
    }

    console.log("📤 Enviando jugador:", jugador);
    console.log("🔑 Token:", token);

    try {
        // ✅ URL CORREGIDA - con barra final
        const res = await fetch(`${API_URL}/jugadores/`, {
            method: "POST",
            headers: { 
                "Content-Type": "application/json",
                "Authorization": `Bearer ${token}`
            },
            body: JSON.stringify(jugador)
        });

        console.log("📥 Respuesta del servidor:", res.status, res.statusText);

        if (!res.ok) {
            let errorMessage = `Error ${res.status}`;
            try {
                const errorData = await res.json();
                errorMessage = errorData.detail || errorMessage;
                
                // Mensajes más específicos
                if (errorMessage.includes('equipo_id') || errorMessage.includes('ForeignKeyViolation')) {
                    errorMessage = "❌ El equipo seleccionado no existe o fue eliminado. Recarga la página.";
                }
                if (errorMessage.includes('dorsal')) {
                    errorMessage = "❌ El dorsal ya está en uso por otro jugador.";
                }
                if (errorMessage.includes('ID')) {
                    errorMessage = "❌ El ID del jugador ya existe.";
                }
            } catch (e) {
                const errorText = await res.text();
                errorMessage = errorText || errorMessage;
            }
            throw new Error(errorMessage);
        }

        const jugadorCreado = await res.json();
        console.log("✅ Jugador agregado:", jugadorCreado);

        e.target.reset();
        await cargarJugadores();
        alert("✅ Jugador agregado correctamente");

    } catch (err) {
        console.error("❌ No se pudo agregar el jugador:", err);
        
        // Mensaje más específico para "Failed to fetch"
        if (err.message.includes('Failed to fetch')) {
            alert("❌ Error de conexión con el servidor. Verifica que el backend esté funcionando.");
        } else {
            alert("❌ No se pudo agregar el jugador: " + err.message);
        }
    }
});

async function cargarJugadores() {
    try {
        console.log("📊 Cargando jugadores...");
        const res = await fetch(`${API_URL}/jugadores`);
        
        if (!res.ok) {
            throw new Error(`Error ${res.status} al cargar jugadores`);
        }
        
        const jugadores = await res.json();
        const tbody = document.getElementById("tablaJugadores");
        if (!tbody) {
            console.log("❌ No se encontró tablaJugadores");
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

        console.log(`✅ ${jugadores.length} jugadores cargados en la tabla`);
    } catch (err) {
        console.error("❌ Error al cargar jugadores:", err);
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