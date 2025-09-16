from pydantic import BaseModel, EmailStr, Field
from typing import Annotated, Optional, List

# Autenticacion creacion de usuario
class UserCreate(BaseModel): # POST auth/register
    email: EmailStr
    password: str = Field(min_length=6, max_length=128)

class UserLogin(BaseModel): # POST auth/login
    email: str
    password: str

# token bearer JWT
class Token(BaseModel): 
    access_token: str
    token_type: str = "bearer"

# Usuario lectura de datos (para respuestas)
class UserRead(BaseModel):
    id: int
    email: EmailStr
    is_active: bool

    class Config:
        from_attributes = True  # Pydantic v2 (antes: orm_mode=True) 
        # esto permite que Pydantic lea datos de objetos ORM directamente y tienen que 
        # tener esta configuracion para que funcione con SQLAlchemy pero en especial para 
        # respuesta al cliente ya que se necesita la conversion de orm a json

# Respuesta al registrar usuario
"""este es un nuevo schema para poder responder con un mensaje y el usuario"""
class RegisterResponse(BaseModel):
    message: str
    user: UserRead


# Permisos

class PermissionRead(BaseModel):
    id: int
    name: str
    description: Optional[str] = None

    class Config:
        from_attributes = True # Pydantic v2 (antes: orm_mode=True)

class PermissionCreate(BaseModel):
    name: Annotated[str, Field(min_length=3, max_length=50)]
    description: Annotated[Optional[str], Field(max_length=255)] = None


# ---------- User <-> Permissions ----------
class PermissionAssign(BaseModel):
    permission_id: int

class PermissionRevoke(BaseModel):
    permission_id: int

class UserWithPermissions(BaseModel):
    id: int
    email: EmailStr
    is_active: bool
    permissions: List[PermissionRead] = []

    class Config:
        from_attributes = True