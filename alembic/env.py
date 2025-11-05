# alembic/env.py
from __future__ import annotations
import os, sys
from pathlib import Path
from logging.config import fileConfig
from alembic import context
from sqlalchemy import engine_from_config, pool
from dotenv import load_dotenv

config = context.config
if config.config_file_name:
    fileConfig(config.config_file_name)

BASE_DIR = Path(__file__).resolve().parent.parent  # raíz del repo (donde está alembic.ini)
SRC_DIR = BASE_DIR / "Liga_CUT" / "src"
sys.path.insert(0, str(SRC_DIR))  # <-- clave

# .env con DATABASE_URL y PYTHONPATH opcional
load_dotenv(BASE_DIR / ".env")
if os.getenv("DATABASE_URL"):
    config.set_main_option("sqlalchemy.url", os.getenv("DATABASE_URL"))

# Usa EXACTAMENTE los mismos imports que en tus modelos
from database.base import Base
from auth import models  # noqa: F401  (efecto secundario para registrar tablas)
target_metadata = Base.metadata

def run_migrations_offline():
    url = config.get_main_option("sqlalchemy.url")
    context.configure(url=url, target_metadata=target_metadata, literal_binds=True)
    with context.begin_transaction():
        context.run_migrations()

def run_migrations_online():
    connectable = engine_from_config(
        config.get_section(config.config_ini_section, {}),
        prefix="sqlalchemy.",
        poolclass=pool.NullPool,
    )
    with connectable.connect() as connection:
        context.configure(connection=connection, target_metadata=target_metadata)
        with context.begin_transaction():
            context.run_migrations()

if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()
