# Imagen base
FROM python:3.11-slim

# Establecer directorio de trabajo dentro del contenedor
WORKDIR /app

# Instalar Poetry
RUN pip install --no-cache-dir poetry

# Copiar archivos de configuración del proyecto
COPY pyproject.toml poetry.lock /app/

# Instalar dependencias sin las de desarrollo
RUN poetry install --no-root --without dev

# Copiar el código fuente del backend
COPY src/ /app/

# Copiar Alembic (para migraciones)
COPY ./alembic.ini /app/
COPY ./alembic /app/alembic

# Exponer el puerto donde correrá FastAPI
EXPOSE 8000

# Comando de ejecución principal
CMD ["poetry", "run", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
