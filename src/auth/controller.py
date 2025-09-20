# Liga_CUT/src/auth/controller.py
from fastapi import APIRouter, Depends, status
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.ext.asyncio import AsyncSession
from auth.dependencies import get_current_user, User
from exceptions import UserAlreadyExistsError, InvalidCredentialsError, WeakPasswordError

from database.sessions import get_db
from auth.schemas import UserCreate, RegisterResponse, UserLogin, Token, UserWithPermissions
from auth.service import (
    get_user_by_email,
    create_user,
    authenticate_user,
    issue_token_for_user,
    validate_password,
) # HELPERS, validate_password es una funcion para el minimo de contraseña

"""
se esta manejando desde el backend que el email sea
en minusculas y la password tenga un minimo de 8 caracteres
"""

router = APIRouter(prefix="/auth", tags=["Auth"])


# -----------------------------
# Register
# -----------------------------
@router.post("/register", response_model=RegisterResponse, status_code=status.HTTP_201_CREATED)
async def register(payload: UserCreate, db: AsyncSession = Depends(get_db)):
    # verificar duplicado
    existing_user = await get_user_by_email(db, payload.email)
    if existing_user:
        raise UserAlreadyExistsError()

    # crear usuario (con validación de password)
    try:
        user = await create_user(db, payload.email, payload.password)
    except ValueError as e:
        raise WeakPasswordError(str(e))

    return {
        "message": "Correo registrado correctamente",
        "user": user
    }

@router.post("/login", response_model=Token)
async def login(payload: UserLogin, db: AsyncSession = Depends(get_db)):
    user = await authenticate_user(db, payload.email, payload.password)
    if not user:
        raise InvalidCredentialsError("Invalid email or password")

    access_token = await issue_token_for_user(user)
    return {"access_token": access_token, "token_type": "bearer"}


@router.post("/token", response_model=Token)
async def token(form_data: OAuth2PasswordRequestForm = Depends(),
                db: AsyncSession = Depends(get_db)):
    # OAuth2 usa "username": lo tratamos como email
    user = await authenticate_user(db, form_data.username, form_data.password)
    access = await issue_token_for_user(user)
    return {"access_token": access, "token_type": "bearer"}


@router.get("/me", response_model=UserWithPermissions)
async def me(current_user = Depends(get_current_user)):
    return current_user


