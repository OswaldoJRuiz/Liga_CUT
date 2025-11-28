from sqlalchemy import Column, Integer, String, ForeignKey, Boolean, DateTime
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from database import Base


class Equipo(Base):
    __tablename__ = "equipos"

    id = Column(Integer, primary_key=True, index=True)
    nombre = Column(String, unique=True, nullable=False)
    num_jugadores = Column(Integer, nullable=False)
    logo = Column(String)

    jugadores = relationship("Jugador", back_populates="equipo", cascade="all, delete")


class Jugador(Base):
    __tablename__ = "jugadores"

    id = Column(Integer, primary_key=True, index=True)
    nombre = Column(String, nullable=False)
    posicion = Column(String, nullable=False)
    dorsal = Column(Integer, nullable=False, unique=True)
    goles = Column(Integer, default=0)

    equipo_id = Column(Integer, ForeignKey("equipos.id"), nullable=False)
    equipo = relationship("Equipo", back_populates="jugadores")


# NUEVOS MODELOS PARA AUTH
class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, nullable=False, index=True)
    password = Column(String, nullable=False)
    is_active = Column(Boolean, default=True)
    is_admin = Column(Boolean, default=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())


class Admin(Base):
    __tablename__ = "admins"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, nullable=False, index=True)
    password = Column(String, nullable=False)
    role = Column(String, default="admin")  # 'admin' o 'capitan'
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())


class Calendario(Base):
    __tablename__ = "calendario"

    id = Column(Integer, primary_key=True, index=True)
    local_team_id = Column(Integer, ForeignKey("equipos.id"), nullable=False)
    visitor_team_id = Column(Integer, ForeignKey("equipos.id"), nullable=False)
    local_score = Column(Integer, default=0)
    visitor_score = Column(Integer, default=0)
    location = Column(String, default="CUT")
    date = Column(String, nullable=False)  # YYYY-MM-DD
    time = Column(String, nullable=False)  # HH:MM
    year = Column(Integer, nullable=False)
    status = Column(String, default="pending")  # pending, in-progress, finished, cancelled
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    
    # Relaciones
    local_team = relationship("Equipo", foreign_keys=[local_team_id])
    visitor_team = relationship("Equipo", foreign_keys=[visitor_team_id])