#!/usr/bin/env bash
# Script para macOS / Linux: copiar una imagen desde una ruta temporal al proyecto
# Uso: desde la raíz del repo: ./frontend/tools/copy_voice_image.sh ["/ruta/origen/miImagen.jpg"]

set -euo pipefail

SOURCE_DEFAULT="$HOME/Downloads/Sin título-1.jpg"
SOURCE=${1:-$SOURCE_DEFAULT}
DEST_DIR="$(cd "$(dirname "$0")/.." && pwd)/assets/images"
DEST="$DEST_DIR/voice_page.png"

echo "Fuente: $SOURCE"
echo "Destino: $DEST"

if [ ! -f "$SOURCE" ]; then
  echo "ERROR: no se encontró el archivo fuente: $SOURCE" >&2
  exit 1
fi

mkdir -p "$DEST_DIR"
cp -f "$SOURCE" "$DEST"

if [ $? -eq 0 ]; then
  echo "Imagen copiada correctamente a: $DEST"
  exit 0
else
  echo "Error al copiar la imagen" >&2
  exit 2
fi
