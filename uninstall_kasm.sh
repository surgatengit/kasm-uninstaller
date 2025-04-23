#!/bin/bash

LOG_FILE="/tmp/kasm_uninstall.log"
exec > >(tee -a "$LOG_FILE") 2>&1

set -e

echo "[INFO] $(date) - Iniciando desinstalación de Kasm..."

echo "[INFO] Deteniendo Kasm..."
if [ -x /opt/kasm/current/bin/stop ]; then
  sudo /opt/kasm/current/bin/stop || true
fi

echo "[INFO] Eliminando contenedores Kasm..."
docker_containers=$(sudo docker container ls -qa --filter="label=kasm.kasmid")
if [ -n "$docker_containers" ]; then
  sudo docker rm -f $docker_containers || true
fi

echo "[INFO] Obteniendo UID/GID de kasm..."
export KASM_UID=$(id -u kasm 2>/dev/null || echo "")
export KASM_GID=$(id -g kasm 2>/dev/null || echo "")

echo "[INFO] Eliminando servicios con Docker Compose..."
if [ -f /opt/kasm/current/docker/docker-compose.yaml ]; then
  sudo -E docker compose -f /opt/kasm/current/docker/docker-compose.yaml rm -sf || true
fi

echo "[INFO] Eliminando redes Docker..."
sudo docker network rm kasm_default_network 2>/dev/null || true
if sudo docker network inspect kasm_sidecar_network &>/dev/null; then
  plugin_name=$(sudo docker network inspect kasm_sidecar_network --format '{{.Driver}}')
  sudo docker network rm kasm_sidecar_network || true
  sudo docker plugin disable "$plugin_name" || true
  sudo docker plugin rm "$plugin_name" || true
fi

echo "[INFO] Eliminando directorios de sidecar..."
sudo rm -rf /var/log/kasm-sidecar /var/run/kasm-sidecar

echo "[INFO] Detectando versión de Kasm instalada..."
KASM_VERSION=$(basename /opt/kasm/current 2>/dev/null || echo "")
if [ -n "$KASM_VERSION" ]; then
  sudo docker volume rm "kasm_db_${KASM_VERSION}" 2>/dev/null || true

  echo "[INFO] Eliminando imágenes específicas de Kasm..."
  sudo docker rmi redis:5-alpine postgres:14-alpine kasmweb/nginx:latest \
    kasmweb/share:$KASM_VERSION kasmweb/agent:$KASM_VERSION \
    kasmweb/manager:$KASM_VERSION kasmweb/api:$KASM_VERSION 2>/dev/null || true
fi

echo "[INFO] Eliminando imágenes marcadas por Kasm..."
kasm_images=$(sudo docker images --filter "label=com.kasmweb.image=true" -q)
if [ -n "$kasm_images" ]; then
  sudo docker rmi $kasm_images || true
fi

echo "[INFO] Eliminando directorio de instalación y usuarios..."
sudo rm -rf /opt/kasm/
sudo deluser --remove-home kasm_db 2>/dev/null || true
sudo deluser --remove-home kasm 2>/dev/null || true

echo "[OK] $(date) - Kasm desinstalado completamente. Log disponible en $LOG_FILE"
