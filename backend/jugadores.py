from fastapi import APIRouter, HTTPException, Depends, status
from pydantic import BaseModel
from typing import List
from sqlalchemy.orm import Session
from fastapi.security import HTTPBearer

from database import SessionLocal
from models import Jugador as JugadorModel
from auth.routes import get_current_user

security = HTTPBearer()
router = APIRouter()

class JugadorSchema(BaseModel):
    id: int
    nombre: str
    posicion: str
    dorsal: int
    goles: int = 0
    equipo_id: int

    class Config:
        from_attributes = True

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# ✅ ENDPOINT PÚBLICO - Todos pueden ver jugadores
@router.get("/", response_model=List[JugadorSchema])
def listar_jugadores(db: Session = Depends(get_db)):
    return db.query(JugadorModel).all()

# 🔒 ENDPOINT PROTEGIDO - Solo admins pueden crear jugadores
@router.post("/", response_model=JugadorSchema)
def agregar_jugador(
    jugador: JugadorSchema, 
    db: Session = Depends(get_db),
    current_user: dict = Depends(get_current_user)
):
    # ✅ CORREGIDO: Usar .get() en lugar de acceso directo
    if current_user.get("user_type") != "admin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="No tienes permisos para crear jugadores. Solo administradores pueden realizar esta acción."
        )
    
    # Verificar si ID o dorsal ya existen
    existente = db.query(JugadorModel).filter(
        (JugadorModel.id == jugador.id) | (JugadorModel.dorsal == jugador.dorsal)
    ).first()
    if existente:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST, 
            detail="ID o dorsal ya existe"
        )
    
    nuevo = JugadorModel(**jugador.dict())
    db.add(nuevo)
    db.commit()
    db.refresh(nuevo)
    return nuevo

# 🔒 ENDPOINT PROTEGIDO - Solo admins pueden actualizar jugadores
@router.put("/{jugador_id}", response_model=JugadorSchema)
def actualizar_jugador(
    jugador_id: int, 
    datos: JugadorSchema, 
    db: Session = Depends(get_db),
    current_user: dict = Depends(get_current_user)
):
    # ✅ CORREGIDO: Usar .get()
    if current_user.get("user_type") != "admin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="No tienes permisos para actualizar jugadores"
        )
    
    jugador = db.query(JugadorModel).filter(JugadorModel.id == jugador_id).first()
    if not jugador:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, 
            detail="Jugador no encontrado"
        )
    
    for key, value in datos.dict().items():
        setattr(jugador, key, value)
    
    db.commit()
    db.refresh(jugador)
    return jugador

# 🔒 ENDPOINT PROTEGIDO - Solo admins pueden eliminar jugadores
@router.delete("/{jugador_id}")
def eliminar_jugador(
    jugador_id: int, 
    db: Session = Depends(get_db),
    current_user: dict = Depends(get_current_user)
):
    # ✅ CORREGIDO: Usar .get()
    if current_user.get("user_type") != "admin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="No tienes permisos para eliminar jugadores"
        )
    
    jugador = db.query(JugadorModel).filter(JugadorModel.id == jugador_id).first()
    if not jugador:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, 
            detail="Jugador no encontrado"
        )
    
    db.delete(jugador)
    db.commit()
    return {"message": "Jugador eliminado"}