from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List

app = FastAPI(title="Liga CUT Tonalá")

# Configurar CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ==================== MODELOS ====================
class Equipo(BaseModel):
    id: int
    nombre: str
    num_jugadores: int

class Jugador(BaseModel):
    id: int
    nombre: str
    posicion: str
    dorsal: int
    goles: int = 0
    equipo_id: int

# ==================== BASE DE DATOS EN MEMORIA ====================
equipos_db = []
jugadores_db = []

# ==================== ENDPOINTS EQUIPOS ====================
@app.get("/equipos/", response_model=List[Equipo])
def listar_equipos():
    return equipos_db

@app.post("/equipos/", response_model=Equipo)
def agregar_equipo(equipo: Equipo):
    # Verificar si el ID ya existe
    if any(eq["id"] == equipo.id for eq in equipos_db):
        raise HTTPException(status_code=400, detail="ID ya existe")
    
    equipo_dict = equipo.dict()
    equipos_db.append(equipo_dict)
    return equipo_dict

# ==================== ENDPOINTS JUGADORES ====================
@app.get("/jugadores/", response_model=List[Jugador])
def listar_jugadores():
    return jugadores_db

@app.post("/jugadores/", response_model=Jugador)
def agregar_jugador(jugador: Jugador):
    # Verificar si el ID ya existe
    if any(j["id"] == jugador.id for j in jugadores_db):
        raise HTTPException(status_code=400, detail="ID ya existe")
    
    # Verificar si el dorsal ya existe
    if any(j["dorsal"] == jugador.dorsal for j in jugadores_db):
        raise HTTPException(status_code=400, detail="Dorsal ya existe")
    
    # Verificar que el equipo exista
    if not any(eq["id"] == jugador.equipo_id for eq in equipos_db):
        raise HTTPException(status_code=400, detail="El equipo no existe")
    
    jugador_dict = jugador.dict()
    jugadores_db.append(jugador_dict)
    return jugador_dict

@app.get("/")
def root():
    return {"message": "API Liga CUT Tonalá"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)