# ----- Etapa 1: compilar Angular -----
FROM node:20 AS build
WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
# Usa la configuración por defecto (en tu angular.json defaultConfiguration=production)
RUN npm run build -- --configuration production

# ----- Etapa 2: servir con Nginx -----
FROM nginx:1.27
# OJO: copiamos desde dist/frontend-liga/browser (según tu angular.json)
COPY --from=build /app/dist/frontend-liga/browser/ /usr/share/nginx/html/

# Plantilla y entrypoint para inyectar BACKEND_URL
COPY nginx.conf.template /etc/nginx/templates/default.conf.template
COPY docker-entrypoint.sh /docker-entrypoint.d/99-envsubst.sh
RUN chmod +x /docker-entrypoint.d/99-envsubst.sh

EXPOSE 80
