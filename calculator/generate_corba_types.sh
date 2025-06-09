#!/bin/bash
set -euo pipefail

SRC_DIR="${1:-.}"                  # Directorio donde están los .idl
OUT_DIR="${2:-./generated}"        # Directorio donde se generan los archivos

mkdir -p "$OUT_DIR"

# Detectar ejecutables
TAO_IDL=$(command -v tao_idl)

if [ -z "$TAO_IDL"]; then
  echo "ERROR: No se encontraron 'tao_idl' y/o 'opendds_idl' en el PATH."
  exit 1
fi

# Iterar sobre todos los .idl en el directorio fuente
for idl_path in "$SRC_DIR"/*.idl; do
  [ -e "$idl_path" ] || continue  # Saltar si no hay .idl

  base_name=$(basename "$idl_path" .idl)
  echo "Procesando: $base_name.idl"

  # Paso 1: generar stubs CORBA
  $TAO_IDL  -I"$TAO_ROOT" "$idl_path" -o "$OUT_DIR"
done

echo "✓ Generación completa en: $OUT_DIR"
