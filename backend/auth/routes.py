# Rutas de autenticación
from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from pydantic import BaseModel
from sqlalchemy.orm import Session
from datetime import timedelta

from database import SessionLocal
from models import User, Admin
from auth.security import verify_password, get_password_hash, create_access_token, verify_token

router = APIRouter()
security = HTTPBearer()

class UserRegister(BaseModel):
    email: str
    password: str

class UserLogin(BaseModel):
    email: str
    password: str

class Token(BaseModel):
    access_token: str
    token_type: str
    user_type: str
    email: str

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

def get_current_user(credentials: HTTPAuthorizationCredentials = Depends(security), db: Session = Depends(get_db)):
    token = credentials.credentials
    user_data = verify_token(token)  # ✅ Ahora verify_token devuelve el objeto completo
    
    if not user_data:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Token inválido"
        )
    
    return user_data  # ✅ Devolver directamente los datos del token

@router.post("/register", response_model=Token)
def register_user(user_data: UserRegister, db: Session = Depends(get_db)):
    # Verificar si el usuario ya existe
    existing_user = db.query(User).filter(User.email == user_data.email).first()
    if existing_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="El correo ya está registrado"
        )
    
    # Crear nuevo usuario
    hashed_password = get_password_hash(user_data.password)
    new_user = User(
        email=user_data.email,
        password=hashed_password,
        is_admin=False
    )
    
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    
    # Crear token de acceso
    access_token = create_access_token(
        data={"sub": new_user.email, "user_type": "user"},  # ✅ AGREGAR user_type
        expires_delta=timedelta(minutes=300)
    )
    
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "user_type": "user",
        "email": new_user.email
    }

@router.post("/login", response_model=Token)
def login_user(user_data: UserLogin, db: Session = Depends(get_db)):
    # Primero buscar en usuarios normales
    user = db.query(User).filter(User.email == user_data.email).first()
    if user:
        if verify_password(user_data.password, user.password):
            access_token = create_access_token(
                data={"sub": user.email, "user_type": "user"},  # ✅ AGREGAR user_type
                expires_delta=timedelta(minutes=300)
            )
            return {
                "access_token": access_token,
                "token_type": "bearer",
                "user_type": "user",
                "email": user.email
            }
    
    # Buscar en admins
    admin = db.query(Admin).filter(Admin.email == user_data.email).first()
    if admin:
        if verify_password(user_data.password, admin.password):
            access_token = create_access_token(
                data={"sub": admin.email, "user_type": "admin"},  # ✅ AGREGAR user_type
                expires_delta=timedelta(minutes=300)
            )
            return {
                "access_token": access_token,
                "token_type": "bearer",
                "user_type": "admin",
                "email": admin.email
            }
    
    raise HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Credenciales incorrectas"
    )

@router.get("/me")
def get_current_user_info(current_user: dict = Depends(get_current_user)):
    return current_user

# FUNCIÓN PARA CREAR ADMINS INICIALES
@router.post("/create-initial-admins")
def create_initial_admins(db: Session = Depends(get_db)):
    # Verificar si ya existen
    existing_admins = db.query(Admin).count()
    if existing_admins > 0:
        return {"message": "Los admins ya existen"}
    
    # Crear admin Oswaldo
    admin1 = Admin(
        email="oswaldo@admin.com",
        password=get_password_hash("oswaldo"),
        role="admin"
    )
    
    # Crear admin Alan
    admin2 = Admin(
        email="alan@admin.com", 
        password=get_password_hash("kanibal"),
        role="admin"
    )
    
    db.add(admin1)
    db.add(admin2)
    db.commit()
    
    return {"message": "Admins creados exitosamente"}