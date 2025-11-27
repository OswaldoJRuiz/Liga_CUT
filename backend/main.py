from fastapi import FastAPI, Depends
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import HTTPBearer
from database import engine, Base
from equipos import router as equipos_router
from jugadores import router as jugadores_router
from auth.routes import router as auth_router, get_current_user

# Crear tablas en la base de datos
Base.metadata.create_all(bind=engine)

app = FastAPI(title="Liga CUT Tonalá")

# Configurar CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Incluir los routers
app.include_router(auth_router, prefix="/auth", tags=["authentication"])
app.include_router(equipos_router, prefix="/equipos", tags=["equipos"])
app.include_router(jugadores_router, prefix="/jugadores", tags=["jugadores"])

security = HTTPBearer()

@app.get("/")
def root():
    return {"message": "API Liga CUT Tonalá"}

@app.get("/protected")
def protected_route(current_user: dict = Depends(get_current_user)):
    return {
        "message": "Esta es una ruta protegida", 
        "user": current_user
    }

# ✅ ENDPOINT DEBUG - AGREGAR ESTO
@app.get("/debug-current-user")
def debug_current_user(current_user: dict = Depends(get_current_user)):
    return {
        "current_user_received": current_user,
        "user_type": current_user.get("user_type"),
        "is_admin": current_user.get("user_type") == "admin",
        "has_user_type": "user_type" in current_user
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)