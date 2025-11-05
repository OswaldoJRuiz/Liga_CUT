FROM node:20-alpine

WORKDIR /app

# Instalar dependencias
COPY package*.json ./
RUN npm install

# Copiar el resto del código
COPY . .

# Exponer el puerto del servidor Next.js
EXPOSE 3000

# Ejecutar en modo desarrollo
CMD ["npm", "run", "dev"]
