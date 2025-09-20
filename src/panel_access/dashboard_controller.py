from fastapi import APIRouter, Depends
from panel_access.dependencies import require_panel_access

"""
Controlador para el panel de administración
"""
router = APIRouter(prefix="/admin", tags=["Admin"])

"""
ruta protegida que requiere acceso al panel de administración
esta ruta es mera prueba para los usuarios que si estan con permiso
"""

@router.get("/dashboard", dependencies=[Depends(require_panel_access)])
async def dashboard():
    return {"message": "Bienvenido al panel de administración"}
