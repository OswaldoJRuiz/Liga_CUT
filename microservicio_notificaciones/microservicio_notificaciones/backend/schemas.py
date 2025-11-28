from pydantic import BaseModel
from datetime import datetime

class NotificacionBase(BaseModel):
    titulo: str
    mensaje: str
    tipo: str = "info"

class NotificacionCreate(NotificacionBase):
    pass

class NotificacionResponse(NotificacionBase):
    id: int
    fecha_creacion: datetime
    leido: bool

    class Config:
        orm_mode = True
