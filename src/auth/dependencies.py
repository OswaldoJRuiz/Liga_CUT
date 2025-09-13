from fastapi import Depends
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.ext.asyncio import AsyncSession
from jose import JWTError
from database.sessions import get_db
from auth.service import decode_token
from auth.models import User
from sqlalchemy import select
from exceptions import InvalidCredentialsError

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/auth/token")  # solo para docs

"""
dependencia usada en /token POST y en panel/controller.py como dependencia para 
pedir acceso al panel de admin
"""

async def get_current_user(
    token: str = Depends(oauth2_scheme),
    db: AsyncSession = Depends(get_db),
) -> User:
    try:
        claims = decode_token(token)
        user_id = int(claims.get("sub"))
    except (JWTError, ValueError, TypeError):
        raise InvalidCredentialsError("No se pudo validar las credenciales del token")

    res = await db.execute(select(User).where(User.id == user_id))
    user = res.scalar_one_or_none()
    if not user or not user.is_active:
        raise InvalidCredentialsError("Usuario no encontrado o inactivo")
    return user
