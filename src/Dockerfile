FROM python:3.11-slim

WORKDIR /app

# Instalar Poetry
RUN pip install --no-cache-dir poetry

# Copiar archivos de dependencias desde la raíz del proyecto
COPY pyproject.toml poetry.lock ./

# Instalar dependencias sin las de desarrollo
RUN poetry install --no-root --without dev

# Copiar el código fuente del backend (FastAPI)
COPY ./src .

EXPOSE 8000

CMD ["poetry", "run", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
