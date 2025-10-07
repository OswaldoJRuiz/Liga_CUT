from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from .database import Base


class Equipo(Base):
    __tablename__ = "equipos"

    id = Column(Integer, primary_key=True, index=True)
    nombre = Column(String, unique=True, nullable=False)
    num_jugadores = Column(Integer, nullable=False)
    logo = Column(String)

    # Relación con jugadores
    jugadores = relationship("Jugador", back_populates="equipo", cascade="all, delete")


class Jugador(Base):
    __tablename__ = "jugadores"

    id = Column(Integer, primary_key=True, index=True)
    nombre = Column(String, nullable=False)
    posicion = Column(String, nullable=False)
    dorsal = Column(Integer, nullable=False, unique=True)
    goles = Column(Integer, default=0)

    # Relación con equipo (obligatoria)
    equipo_id = Column(Integer, ForeignKey("equipos.id"), nullable=False)

    equipo = relationship("Equipo", back_populates="jugadores")
