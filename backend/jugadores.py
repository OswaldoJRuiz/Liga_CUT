from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel
from typing import List
from sqlalchemy.orm import Session

from database import SessionLocal
from models import Jugador as JugadorModel

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

@router.get("/", response_model=List[JugadorSchema])
def listar_jugadores(db: Session = Depends(get_db)):
    return db.query(JugadorModel).all()

@router.post("/", response_model=JugadorSchema)
def agregar_jugador(jugador: JugadorSchema, db: Session = Depends(get_db)):
    existente = db.query(JugadorModel).filter(
        (JugadorModel.id == jugador.id) | (JugadorModel.dorsal == jugador.dorsal)
    ).first()
    if existente:
        raise HTTPException(status_code=400, detail="ID o dorsal ya existe")
    
    nuevo = JugadorModel(**jugador.dict())
    db.add(nuevo)
    db.commit()
    db.refresh(nuevo)
    return nuevo

@router.put("/{jugador_id}", response_model=JugadorSchema)
def actualizar_jugador(jugador_id: int, datos: JugadorSchema, db: Session = Depends(get_db)):
    jugador = db.query(JugadorModel).filter(JugadorModel.id == jugador_id).first()
    if not jugador:
        raise HTTPException(status_code=404, detail="Jugador no encontrado")
    
    for key, value in datos.dict().items():
        setattr(jugador, key, value)
    
    db.commit()
    db.refresh(jugador)
    return jugador

@router.delete("/{jugador_id}")
def eliminar_jugador(jugador_id: int, db: Session = Depends(get_db)):
    jugador = db.query(JugadorModel).filter(JugadorModel.id == jugador_id).first()
    if not jugador:
        raise HTTPException(status_code=404, detail="Jugador no encontrado")
    
    db.delete(jugador)
    db.commit()
    return {"message": "Jugador eliminado"}