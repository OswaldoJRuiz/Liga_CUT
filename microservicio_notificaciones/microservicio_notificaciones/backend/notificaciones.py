from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from . import schemas, crud
from .database import SessionLocal

router = APIRouter(prefix="/notificaciones", tags=["Notificaciones"])

# Dependencia para obtener la sesión de BD
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.get("/", response_model=list[schemas.NotificacionResponse])
def listar_notificaciones(skip: int = 0, limit: int = 10, db: Session = Depends(get_db)):
    return crud.get_notificaciones(db, skip=skip, limit=limit)

@router.get("/agrupadas", response_model=dict)
def listar_agrupadas(skip: int = 0, limit: int = 50, db: Session = Depends(get_db)):
    # Devuelve un diccionario: { "YYYY-MM-DD": [Notificacion, ...], ... }
    grouped = crud.get_grouped_by_date(db, skip=skip, limit=limit)
    # Convertir objetos ORM a dicts serializables
    result = {}
    for k, v in grouped.items():
        result[k] = [{
            "id": n.id,
            "titulo": n.titulo,
            "mensaje": n.mensaje,
            "tipo": n.tipo,
            "fecha_creacion": n.fecha_creacion.isoformat(),
            "leido": n.leido
        } for n in v]
    return result

@router.post("/", response_model=schemas.NotificacionResponse)
def crear_notificacion(notificacion: schemas.NotificacionCreate, db: Session = Depends(get_db)):
    return crud.create_notificacion(db, notificacion)

@router.patch("/{notificacion_id}/leer", response_model=schemas.NotificacionResponse)
def marcar_como_leida(notificacion_id: int, db: Session = Depends(get_db)):
    notif = crud.mark_as_read(db, notificacion_id)
    if not notif:
        raise HTTPException(status_code=404, detail="Notificación no encontrada")
    return notif
