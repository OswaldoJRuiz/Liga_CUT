from fastapi import Depends
from exceptions import ForbiddenError
from sqlalchemy.ext.asyncio import AsyncSession
from auth.dependencies import get_current_user
from auth.models import User
from database.sessions import get_db

"""
Esta es un dependencia creada que nos sirve para inyectar a los 
endpoints y protegerlos, pidiendo de una autenticacion de usuario
para hacer uso de los endpoints por ejemplo los de permisos
"""


async def require_panel_access(
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    if not any(p.name == "admin:panel.access" for p in current_user.permissions):
        # Nosotros tenemos nuestro manejo de errores y lo importamos de exceptions.py
        raise ForbiddenError("No tienes acceso a este panel!")
    return current_user