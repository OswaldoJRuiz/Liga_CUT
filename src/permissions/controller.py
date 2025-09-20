# panel/controller.py
from typing import Optional
from fastapi import APIRouter, Depends, Query, status
from sqlalchemy.ext.asyncio import AsyncSession
from panel_access.dependencies import require_panel_access

from database.sessions import get_db
from exceptions import PermissionAlreadyExistsError, PermissionNotFoundError
from permissions.schemas import PermissionCreate, PermissionUpdate, PermissionRead, PermissionList
from permissions.service import (
    list_permissions, get_permission_by_id, create_permission,
    update_permission_description, delete_permission
)

"""
estamos reutilizando una dependencia creada por nosotros en depedencies.py de auth
misma que se utilizada para el endpoint /token (POST) en auth/controller.py
"""


# =======================
#      CRUD Permisos
# =======================

# Mantenemos el subrouter pero con el MISMO tag para evitar duplicados
perms_router = APIRouter(prefix="/permissions", tags=["Permissions"])

@perms_router.get("/", response_model=PermissionList, dependencies=[Depends(require_panel_access)])
async def permissions_list(
    search: Optional[str] = Query(None, min_length=1),
    limit: int = Query(50, ge=1, le=200),
    offset: int = Query(0, ge=0),
    db: AsyncSession = Depends(get_db),
):
    items, total = await list_permissions(db, search=search, limit=limit, offset=offset)
    return PermissionList(items=items, total=total)

@perms_router.get("/{permission_id}", response_model=PermissionRead, dependencies=[Depends(require_panel_access)])
async def permissions_get(
    permission_id: int,
    db: AsyncSession = Depends(get_db),
):
    perm = await get_permission_by_id(db, permission_id)
    return perm

@perms_router.post("/", response_model=PermissionRead, status_code=status.HTTP_201_CREATED, dependencies=[Depends(require_panel_access)])
async def permissions_create(
    payload: PermissionCreate,
    db: AsyncSession = Depends(get_db),
):
    try:
        return await create_permission(db, name=payload.name, description=payload.description)
    except PermissionAlreadyExistsError as e:
        raise e

@perms_router.put("/{permission_id}", response_model=PermissionRead, dependencies=[Depends(require_panel_access)])
async def permissions_update(
    permission_id: int,
    payload: PermissionUpdate,
    db: AsyncSession = Depends(get_db),
):
    try:
        return await update_permission_description(db, permission_id=permission_id, description=payload.description)
    except PermissionNotFoundError as e:
        raise e

@perms_router.delete("/{permission_id}", status_code=status.HTTP_204_NO_CONTENT, dependencies=[Depends(require_panel_access)])
async def permissions_delete(
    permission_id: int,
    db: AsyncSession = Depends(get_db),
):
    try:
        await delete_permission(db, permission_id)
    except PermissionNotFoundError as e:
        raise e
    return None

