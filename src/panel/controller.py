from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from database.sessions import get_db
from auth.dependencies import get_current_user
from exceptions import ForbiddenError

""" 
estamos reutilizando una dependencia creada por nosotros en depedencies.py de auth
misma que se utilizada para el endpoint /token (POST) en auth/controller.py
"""

router = APIRouter(prefix="/admin", tags=["admin"])

async def require_panel_access(
    current_user = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    if not any(p.name == "admin:panel.access" for p in current_user.permissions):
        raise ForbiddenError("No tienes acceso a este panel!")  # Nosotros tenemos nuestro manejo de errores y lo importamos de exceptions.py
    return current_user

@router.get("/dashboard", dependencies=[Depends(require_panel_access)])
async def dashboard():
    return {"ok": True}
