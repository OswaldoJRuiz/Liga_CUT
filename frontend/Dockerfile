# Imagen base de Nginx para servir archivos estáticos
FROM nginx:alpine

# Copiamos todos los archivos del frontend a la carpeta que Nginx sirve
COPY . /usr/share/nginx/html

# Exponemos el puerto 80
EXPOSE 80
