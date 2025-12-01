#!/usr/bin/env sh
set -eu
# Valor por defecto si no pasas BACKEND_URL desde Compose
: "${BACKEND_URL:=http://backend:8080/}"

# Reemplaza la variable en la plantilla y genera la conf final
envsubst '${BACKEND_URL}' < /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf
