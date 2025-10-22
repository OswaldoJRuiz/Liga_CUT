# Imagen base de Python
FROM python:3.13-slim

# Configurar directorio de trabajo
WORKDIR /app

# Copiar los archivos del backend al contenedor
COPY . /app

# Instalar dependencias
RUN pip install --no-cache-dir fastapi uvicorn sqlalchemy psycopg2-binary

# Exponer el puerto del backend
EXPOSE 8000

# Comando para ejecutar FastAPI
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
