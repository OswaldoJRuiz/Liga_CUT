from fastapi import HTTPException, status

"""
Fabricaremos excepciones personalizadas para manejar errores comunes
por ejemplo de autenticacion, autorizacion y validacion de datos, haremos 
tambien excepciones para manejar errores de base de datos y otros errores comunes.
"""

# exceptions.py
from fastapi import HTTPException, status

class UserAlreadyExistsError(HTTPException):
    def __init__(self):
        super().__init__(status_code=status.HTTP_409_CONFLICT, detail="Email already registered")

class InvalidCredentialsError(HTTPException):
    def __init__(self):
        super().__init__(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid email or password", headers={"WWW-Authenticate": "Bearer"},)

class WeakPasswordError(HTTPException):
    def __init__(self, msg: str = "Weak password"):
        super().__init__(status_code=status.HTTP_422_UNPROCESSABLE_ENTITY, detail=msg)

class ForbiddenError(HTTPException):
    def __init__(self, msg: str = "Forbidden"):
        super().__init__(status_code=status.HTTP_403_FORBIDDEN, detail=msg)

class NotFoundError(HTTPException):
    def __init__(self, msg: str = "Not found"):
        super().__init__(status_code=status.HTTP_404_NOT_FOUND, detail=msg)
