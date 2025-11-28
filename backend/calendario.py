from fastapi import APIRouter, HTTPException, Depends, status
from pydantic import BaseModel
from typing import List
from sqlalchemy.orm import Session
from fastapi.security import HTTPBearer

from database import SessionLocal
from models import Calendario as CalendarioModel, Equipo
from auth.routes import get_current_user

security = HTTPBearer()
router = APIRouter()

class CalendarioSchema(BaseModel):
    id: int
    local_team_id: int
    visitor_team_id: int
    local_score: int = 0
    visitor_score: int = 0
    location: str = "CUT"
    date: str
    time: str
    year: int
    status: str = "pending"

    class Config:
        from_attributes = True

class CalendarioCreate(BaseModel):
    local_team_id: int
    visitor_team_id: int
    location: str = "CUT"
    date: str
    time: str
    year: int

class CalendarioUpdate(BaseModel):
    local_score: int = 0
    visitor_score: int = 0
    status: str = "pending"

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# ✅ ENDPOINT PÚBLICO - Todos pueden ver el calendario
@router.get("/", response_model=List[CalendarioSchema])
def listar_partidos(db: Session = Depends(get_db)):
    return db.query(CalendarioModel).all()

# 🔒 ENDPOINT PROTEGIDO - Solo admins pueden crear partidos
@router.post("/", response_model=CalendarioSchema)
def agregar_partido(
    partido: CalendarioCreate,
    db: Session = Depends(get_db),
    current_user: dict = Depends(get_current_user)
):
    if current_user.get("user_type") != "admin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="No tienes permisos para crear partidos. Solo administradores pueden realizar esta acción."
        )
    
    # Verificar que los equipos existan
    local_team = db.query(Equipo).filter(Equipo.id == partido.local_team_id).first()
    visitor_team = db.query(Equipo).filter(Equipo.id == partido.visitor_team_id).first()
    
    if not local_team or not visitor_team:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Uno o ambos equipos no existen"
        )
    
    # Verificar que no sean el mismo equipo
    if partido.local_team_id == partido.visitor_team_id:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Los equipos no pueden ser iguales"
        )
    
    # Generar ID automático
    last_partido = db.query(CalendarioModel).order_by(CalendarioModel.id.desc()).first()
    new_id = (last_partido.id + 1) if last_partido else 1

    nuevo_partido = CalendarioModel(
        id=new_id,
        local_team_id=partido.local_team_id,
        visitor_team_id=partido.visitor_team_id,
        location=partido.location,
        date=partido.date,
        time=partido.time,
        year=partido.year,
        status="pending"
    )
    
    db.add(nuevo_partido)
    db.commit()
    db.refresh(nuevo_partido)
    return nuevo_partido

# 🔒 ENDPOINT PROTEGIDO - Solo admins pueden actualizar partidos
@router.put("/{partido_id}", response_model=CalendarioSchema)
def actualizar_partido(
    partido_id: int,
    datos: CalendarioUpdate,
    db: Session = Depends(get_db),
    current_user: dict = Depends(get_current_user)
):
    if current_user.get("user_type") != "admin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="No tienes permisos para actualizar partidos"
        )
    
    partido = db.query(CalendarioModel).filter(CalendarioModel.id == partido_id).first()
    if not partido:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Partido no encontrado"
        )
    
    partido.local_score = datos.local_score
    partido.visitor_score = datos.visitor_score
    partido.status = datos.status
    
    db.commit()
    db.refresh(partido)
    return partido

# 🔒 ENDPOINT PROTEGIDO - Solo admins pueden eliminar partidos
@router.delete("/{partido_id}")
def eliminar_partido(
    partido_id: int,
    db: Session = Depends(get_db),
    current_user: dict = Depends(get_current_user)
):
    if current_user.get("user_type") != "admin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="No tienes permisos para eliminar partidos"
        )
    
    partido = db.query(CalendarioModel).filter(CalendarioModel.id == partido_id).first()
    if not partido:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Partido no encontrado"
        )
    
    db.delete(partido)
    db.commit()
    return {"message": "Partido eliminado"}