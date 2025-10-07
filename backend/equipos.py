from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel
from typing import List
from sqlalchemy.orm import Session

from backend.database import SessionLocal
from backend.models import Equipo as EquipoDB

router = APIRouter()

class Equipo(BaseModel):
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

@router.get("/", response_model=List[Equipo])
def listar_equipos(db: Session = Depends(get_db)):
    return db.query(EquipoDB).all()

@router.post("/", response_model=Equipo)
def agregar_equipo(equipo: Equipo, db: Session = Depends(get_db)):
    # Validar si ya existe
    existente = db.query(EquipoDB).filter(
        (EquipoDB.id == equipo.id) | (EquipoDB.nombre == equipo.nombre)
    ).first()
    if existente:
        raise HTTPException(status_code=400, detail="ID o nombre ya existe")

    nuevo = EquipoDB(
        id=equipo.id,
        nombre=equipo.nombre,
        num_jugadores=equipo.num_jugadores,
        logo=None  # Sin logo por ahora
    )
    
    db.add(nuevo)
    db.commit()
    db.refresh(nuevo)
    return nuevo

@router.put("/{equipo_id}", response_model=Equipo)
def actualizar_equipo(equipo_id: int, equipo: Equipo, db: Session = Depends(get_db)):
    equipo_db = db.query(EquipoDB).filter(EquipoDB.id == equipo_id).first()
    if not equipo_db:
        raise HTTPException(status_code=404, detail="Equipo no encontrado")

    equipo_db.nombre = equipo.nombre
    equipo_db.num_jugadores = equipo.num_jugadores

    db.commit()
    db.refresh(equipo_db)
    return equipo_db

@router.delete("/{equipo_id}")
def eliminar_equipo(equipo_id: int, db: Session = Depends(get_db)):
    equipo = db.query(EquipoDB).filter(EquipoDB.id == equipo_id).first()
    if not equipo:
        raise HTTPException(status_code=404, detail="Equipo no encontrado")

    db.delete(equipo)
    db.commit()
    return {"message": "Equipo Eliminado"}