# panel/schemas.py
from typing import List, Optional
from pydantic import BaseModel, Field

# Regex para validar el formato del nombre del permiso "re" "r"
_PERMISSION_NAME_RE = r'^[a-z][a-z0-9._-]*:[a-z][a-z0-9._-]*$'

# esquema de creacion de un permiso
class PermissionCreate(BaseModel):
    name: str = Field(
        min_length=3,
        max_length=80,
        pattern=_PERMISSION_NAME_RE,
        description="Formato sugerido: recurso:accion (ej. matches:update)",
    )
    description: Optional[str] = Field(default=None, max_length=255)


class PermissionUpdate(BaseModel):
    # No permitimos renombrar por estabilidad inter-servicios
    description: Optional[str] = Field(default=None, max_length=255)


class PermissionRead(BaseModel):
    id: int
    name: str
    description: Optional[str] = None

    class Config:
        from_attributes = True  # pydantic v2  antes:  orm_mode = True

# Esquema para listar permisos con paginacion
class PermissionList(BaseModel): 
    items: List[PermissionRead]
    total: int
