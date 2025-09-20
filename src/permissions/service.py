# panel/service.py
"""
Lógica de negocio para CRUD de permisos.
- Mantén este módulo libre de FastAPI (sin HTTPException). 
- Lanza errores de dominio para que el controller los traduzca a códigos HTTP.

Requiere en exceptions.py (si no existen, créalos):
class PermissionAlreadyExistsError(Exception): ...
class PermissionNotFoundError(Exception): ...
"""

from __future__ import annotations

import re
from typing import List, Optional, Tuple

from sqlalchemy import func, select, delete, update
from sqlalchemy.ext.asyncio import AsyncSession

from auth.models import Permission
from exceptions import PermissionAlreadyExistsError, PermissionNotFoundError

# ---------- Validaciones / helpers ----------

_PERMISSION_NAME_RE = re.compile(r'^[a-z][a-z0-9._-]*:[a-z][a-z0-9._-]*$')

def normalize_permission_name(name: str) -> str:
    """normaliza a minúsculas y quita espacios."""
    return name.strip().lower()

def validate_permission_name(name: str) -> None:
    """valida formato recurso:accion."""
    if not _PERMISSION_NAME_RE.match(name):
        raise ValueError(
            "Nombre de permiso inválido. Usa formato 'recurso:accion', "
            "solo minúsculas y [a-z0-9._-]. Ej: matches:update"
        )

# ---------- Servicios ----------

async def list_permissions(
    db: AsyncSession,
    search: Optional[str] = None,
    limit: int = 50,
    offset: int = 0,
) -> Tuple[List[Permission], int]:
    """
    Lista permisos con paginación y búsqueda por nombre (ILIKE).
    Retorna (items, total)
    """
    q = select(Permission)
    qc = select(func.count(Permission.id))

    if search:
        pattern = f"%{search.strip().lower()}%"
        q = q.where(func.lower(Permission.name).ilike(pattern))
        qc = qc.where(func.lower(Permission.name).ilike(pattern))

    q = q.order_by(Permission.name).limit(limit).offset(offset)

    res_items = await db.execute(q)
    items = res_items.scalars().all()

    res_total = await db.execute(qc)
    total = res_total.scalar_one()

    return items, total


async def get_permission_by_id(db: AsyncSession, permission_id: int) -> Permission:
    """Obtiene un permiso por id o lanza PermissionNotFoundError."""
    res = await db.execute(select(Permission).where(Permission.id == permission_id))
    perm = res.scalar_one_or_none()
    if not perm:
        raise PermissionNotFoundError(f"Permiso id={permission_id} no existe")
    return perm


async def get_permission_by_name(db: AsyncSession, name: str) -> Optional[Permission]:
    """Busca un permiso por nombre normalizado."""
    norm = normalize_permission_name(name)
    res = await db.execute(select(Permission).where(Permission.name == norm))
    return res.scalar_one_or_none()


async def create_permission(
    db: AsyncSession,
    name: str,
    description: Optional[str] = None,
) -> Permission:
    """
    Crea un permiso nuevo.
    - name normalizado y validado
    - unicidad por name
    """
    norm = normalize_permission_name(name)
    validate_permission_name(norm)

    existing = await get_permission_by_name(db, norm)
    if existing:
        raise PermissionAlreadyExistsError(f"El permiso '{norm}' ya existe")

    perm = Permission(name=norm, description=description)
    db.add(perm)
    await db.commit()
    await db.refresh(perm)
    return perm


async def update_permission_description(
    db: AsyncSession,
    permission_id: int,
    description: Optional[str],
) -> Permission:
    """
    Actualiza solo la descripción del permiso (recomendado para estabilidad).
    """
    # Verifica existencia primero
    await get_permission_by_id(db, permission_id)

    stmt = (
        update(Permission)
        .where(Permission.id == permission_id)
        .values(description=description)
        .returning(Permission.id, Permission.name, Permission.description)
    )
    res = await db.execute(stmt)
    await db.commit()

    row = res.first()
    # reconstruye objeto liviano (o reconsulta si prefieres)
    perm = Permission(id=row.id, name=row.name, description=row.description)
    return perm


async def delete_permission(db: AsyncSession, permission_id: int) -> None:
    """
    Elimina un permiso por id. (borrado duro)
    user_permissions se limpia vía FK CASCADE.
    """
    # Verifica existencia primero para retornar 404 si no existe
    await get_permission_by_id(db, permission_id)

    stmt = delete(Permission).where(Permission.id == permission_id)
    await db.execute(stmt)
    await db.commit()
