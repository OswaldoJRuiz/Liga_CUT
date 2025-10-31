import time
import psycopg2
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT

def wait_for_db():
    """Espera a que la base de datos esté lista"""
    print("Esperando a que la base de datos esté lista...")
    
    for i in range(30):  # 30 intentos máximo
        try:
            # Configuración para Docker - usa 'db' como host
            conn = psycopg2.connect(
                host="db",  # Nombre del servicio en docker-compose
                database="liga_cut",
                user="postgres",
                password="oswaldo",
                port=5432
            )
            conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
            conn.close()
            print("Base de datos conectada exitosamente!")
            return True
        except Exception as e:
            print(f"Intento {i+1}/30: Base de datos no disponible... ({e})")
            time.sleep(2)
    
    print("No se pudo conectar a la base de datos después de 30 intentos")
    return False

if __name__ == "__main__":
    wait_for_db()