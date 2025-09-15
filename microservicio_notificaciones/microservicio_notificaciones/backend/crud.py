from sqlalchemy.orm import Session
from . import models, schemas
from sqlalchemy import desc
from datetime import datetime

def get_notificaciones(db: Session, skip: int = 0, limit: int = 10):
    # Return notifications ordered by newest first
    return db.query(models.Notificacion).order_by(desc(models.Notificacion.fecha_creacion)).offset(skip).limit(limit).all()

def create_notificacion(db: Session, notificacion: schemas.NotificacionCreate):
    db_notificacion = models.Notificacion(
        titulo=notificacion.titulo,
        mensaje=notificacion.mensaje,
        tipo=notificacion.tipo
    )
    db.add(db_notificacion)
    db.commit()
    db.refresh(db_notificacion)
    return db_notificacion

def mark_as_read(db: Session, notificacion_id: int):
    notif = db.query(models.Notificacion).filter(models.Notificacion.id == notificacion_id).first()
    if not notif:
        return None
    notif.leido = True
    db.commit()
    db.refresh(notif)
    return notif

def get_grouped_by_date(db: Session, skip: int = 0, limit: int = 50):
    # Fetch a page of notifications and group them by date (YYYY-MM-DD)
    notifs = get_notificaciones(db, skip=skip, limit=limit)
    grouped = {}
    for n in notifs:
        key = n.fecha_creacion.date().isoformat()
        grouped.setdefault(key, []).append(n)
    return grouped
