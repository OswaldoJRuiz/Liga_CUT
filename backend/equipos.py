import os
import shutil
from fastapi import APIRouter, HTTPException, Depends, UploadFile, File, Form
from pydantic import BaseModel
from typing import List, Optional
from sqlalchemy.orm import Session

from backend.database import SessionLocal
from backend.models import Equipo as EquipoDB

router = APIRouter()

# Carpeta donde guardaremos los logos
UPLOAD_DIR = "static/logos"
os.makedirs(UPLOAD_DIR, exist_ok=True)

# Modelo Pydantic para respuestas
class Equipo(BaseModel):
    id: int
    nombre: str
    num_jugadores: int
    logo: Optional[str]  # puede ser None si no sube imagen

    class Config:
        from_attributes = True

# Dependencia para obtener la sesión
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# Listar equipos
@router.get("/", response_model=List[Equipo])
def listar_equipos(db: Session = Depends(get_db)):
    return db.query(EquipoDB).all()

# Obtener equipo por ID
@router.get("/{equipo_id}", response_model=Equipo)
def obtener_equipo(equipo_id: int, db: Session = Depends(get_db)):
    equipo = db.query(EquipoDB).filter(EquipoDB.id == equipo_id).first()
    if not equipo:
        raise HTTPException(status_code=404, detail="Equipo no encontrado")
    return equipo

# Agregar equipo con imagen
@router.post("/", response_model=Equipo)
def agregar_equipo(
    id: int = Form(...),
    nombre: str = Form(...),
    num_jugadores: int = Form(...),
    logo: UploadFile = File(None),  # logo puede ser opcional
    db: Session = Depends(get_db)
):
    # Validar si ya existe
    existente = db.query(EquipoDB).filter(
        (EquipoDB.id == id) | (EquipoDB.nombre == nombre)
    ).first()
    if existente:
        raise HTTPException(status_code=400, detail="ID o nombre ya existe")

    logo_path = None
    if logo:
        ext = logo.filename.split(".")[-1]
        filename = f"equipo_{id}.{ext}"
        file_path = os.path.join(UPLOAD_DIR, filename)
        with open(file_path, "wb") as buffer:
            shutil.copyfileobj(logo.file, buffer)
        logo_path = f"/{UPLOAD_DIR}/{filename}"  # ruta accesible

    nuevo = EquipoDB(
        id=id,
        nombre=nombre,
        num_jugadores=num_jugadores,
        logo=logo_path
    )
    db.add(nuevo)
    db.commit()
    db.refresh(nuevo)
    return nuevo

# Actualizar equipo
@router.put("/{equipo_id}", response_model=Equipo)
def actualizar_equipo(
    equipo_id: int,
    nombre: str = Form(...),
    num_jugadores: int = Form(...),
    logo: UploadFile = File(None),
    db: Session = Depends(get_db)
):
    equipo = db.query(EquipoDB).filter(EquipoDB.id == equipo_id).first()
    if not equipo:
        raise HTTPException(status_code=404, detail="Equipo no encontrado")

    equipo.nombre = nombre
    equipo.num_jugadores = num_jugadores

    if logo:
        ext = logo.filename.split(".")[-1]
        filename = f"equipo_{equipo_id}.{ext}"
        file_path = os.path.join(UPLOAD_DIR, filename)
        with open(file_path, "wb") as buffer:
            shutil.copyfileobj(logo.file, buffer)
        equipo.logo = f"/{UPLOAD_DIR}/{filename}"

    db.commit()
    db.refresh(equipo)
    return equipo

# Eliminar equipo
@router.delete("/{equipo_id}")
def eliminar_equipo(equipo_id: int, db: Session = Depends(get_db)):
    equipo = db.query(EquipoDB).filter(EquipoDB.id == equipo_id).first()
    if not equipo:
        raise HTTPException(status_code=404, detail="Equipo no encontrado")

    # Eliminar logo físico si existe
    if equipo.logo:
        try:
            os.remove(equipo.logo.lstrip("/"))
        except FileNotFoundError:
            pass

    db.delete(equipo)
    db.commit()
    return {"message": "Equipo Eliminado"}
