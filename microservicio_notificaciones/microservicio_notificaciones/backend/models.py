from sqlalchemy import Column, Integer, String, DateTime, Boolean
from datetime import datetime
from .database import Base

class Notificacion(Base):
    __tablename__ = "notificaciones"

    id = Column(Integer, primary_key=True, index=True)
    titulo = Column(String, nullable=False)
    mensaje = Column(String, nullable=False)
    tipo = Column(String, default="info")  # info, alerta, partido, etc.
    fecha_creacion = Column(DateTime, default=datetime.utcnow)
    leido = Column(Boolean, default=False)
