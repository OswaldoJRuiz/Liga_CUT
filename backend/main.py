from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from database import engine, Base
from equipos import router as equipos_router
from jugadores import router as jugadores_router

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
app.include_router(equipos_router, prefix="/equipos", tags=["equipos"])
app.include_router(jugadores_router, prefix="/jugadores", tags=["jugadores"])

@app.get("/")
def root():
    return {"message": "API Liga CUT Tonalá"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)