from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from . import models
from .database import engine
from .notificaciones import router as notificaciones_router
import os

# Crear tablas en la BD (si no existen)
models.Base.metadata.create_all(bind=engine)

app = FastAPI(title="Microservicio de Notificaciones")

# Permitir CORS para desarrollo (ajustar en producción)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Incluir las rutas de la API
app.include_router(notificaciones_router)

# Opcional: servir el frontend estático si se coloca en frontend/ (útil para pruebas)
frontend_path = os.path.join(os.path.dirname(__file__), "..", "frontend")
if os.path.isdir(frontend_path):
    app.mount("/static", StaticFiles(directory=frontend_path), name="static")
