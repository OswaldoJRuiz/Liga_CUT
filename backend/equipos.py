from fastapi import APIRouter, HTTPException, Depends, status
from pydantic import BaseModel
from typing import List
from sqlalchemy.orm import Session
from fastapi.security import HTTPBearer
from database import SessionLocal
from models import Equipo as EquipoModel
from auth.routes import get_current_user

security = HTTPBearer()
router = APIRouter()

class EquipoSchema(BaseModel):
    id: int
    nombre: str
    num_jugadores: int

    class Config:
        from_attributes = True

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# ✅ ENDPOINT PÚBLICO - Todos pueden ver equipos
@router.get("/", response_model=List[EquipoSchema])
def listar_equipos(db: Session = Depends(get_db)):
    return db.query(EquipoModel).all()

# 🔒 ENDPOINT PROTEGIDO - Solo admins pueden crear equipos
@router.post("/", response_model=EquipoSchema)
def agregar_equipo(
    equipo: EquipoSchema, 
    db: Session = Depends(get_db),
    current_user: dict = Depends(get_current_user)
):
    # ✅ CORREGIDO: Usar .get() en lugar de acceso directo
    if current_user.get("user_type") != "admin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="No tienes permisos para crear equipos. Solo administradores pueden realizar esta acción."
        )
    
    # Verificar si el ID o nombre ya existen
    existente = db.query(EquipoModel).filter(
        (EquipoModel.id == equipo.id) | (EquipoModel.nombre == equipo.nombre)
    ).first()
    if existente:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST, 
            detail="ID o nombre ya existe"
        )

    nuevo = EquipoModel(
        id=equipo.id,
        nombre=equipo.nombre,
        num_jugadores=equipo.num_jugadores,
        logo=None
    )
    
    db.add(nuevo)
    db.commit()
    db.refresh(nuevo)
    return nuevo

# 🔒 ENDPOINT PROTEGIDO - Solo admins pueden actualizar equipos
@router.put("/{equipo_id}", response_model=EquipoSchema)
def actualizar_equipo(
    equipo_id: int, 
    equipo: EquipoSchema, 
    db: Session = Depends(get_db),
    current_user: dict = Depends(get_current_user)
):
    # ✅ CORREGIDO: Usar .get()
    if current_user.get("user_type") != "admin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="No tienes permisos para actualizar equipos"
        )
    
    equipo_db = db.query(EquipoModel).filter(EquipoModel.id == equipo_id).first()
    if not equipo_db:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, 
            detail="Equipo no encontrado"
        )

    equipo_db.nombre = equipo.nombre
    equipo_db.num_jugadores = equipo.num_jugadores

    db.commit()
    db.refresh(equipo_db)
    return equipo_db

# 🔒 ENDPOINT PROTEGIDO - Solo admins pueden eliminar equipos
@router.delete("/{equipo_id}")
def eliminar_equipo(
    equipo_id: int, 
    db: Session = Depends(get_db),
    current_user: dict = Depends(get_current_user)
):
    # ✅ CORREGIDO: Usar .get()
    if current_user.get("user_type") != "admin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="No tienes permisos para eliminar equipos"
        )
    
    equipo = db.query(EquipoModel).filter(EquipoModel.id == equipo_id).first()
    if not equipo:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, 
            detail="Equipo no encontrado"
        )

    db.delete(equipo)
    db.commit()
    return {"message": "Equipo Eliminado"}