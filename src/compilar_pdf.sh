#!/bin/bash

# 1. Definir la raíz del proyecto de forma dinámica (A prueba de fallos)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(dirname "$SCRIPT_DIR")"

# 2. Configuración de rutas absolutas basadas en la estructura del laboratorio
OUT_DIR="$BASE_DIR/output"
METADATA="$BASE_DIR/config/metadata.yaml"

# 3. Comprobar si se pasó un archivo
if [ -z "$1" ]; then
    echo "Uso: ./compilar_pdf.sh archivo.md"
    exit 1
fi

# 4. Variables dinámicas
INPUT_FILE="$1"
FILENAME=$(basename -- "$INPUT_FILE")
NAME_ONLY="${FILENAME%.*}"
OUTPUT_NAME="${OUT_DIR}/${NAME_ONLY}_ES.pdf"

# 5. Asegurar que el directorio de salida existe
mkdir -p "$OUT_DIR"

echo ">>> Iniciando compilación de $INPUT_FILE a $OUTPUT_NAME..."
echo ">>> Usando metadatos de: $METADATA"

# 6. Ejecución de Pandoc con motor XeLaTeX y metadatos dinámicos
# Cada línea termina en '\' para que Bash las reconozca como un solo comando
pandoc "$INPUT_FILE" -o "$OUTPUT_NAME" \
    --pdf-engine=xelatex \
    --metadata-file="$METADATA" \
    -V lang=es-ES \
    -V mainfont="DejaVu Serif" \
    -V monofont="DejaVu Sans Mono" \
    -V fontsize=11pt \
    -V geometry:margin=1in \
    -V colorlinks=true \
    -V linkcolor=blue \
    --toc \
    --toc-depth=3 \
    --number-sections \
    --highlight-style=monochrome

# 7. Verificación de salida
if [ $? -eq 0 ]; then
    echo "✅ Éxito: PDF generado en $OUTPUT_NAME"
    # xdg-open "$OUTPUT_NAME" & # Descomenta para abrir al terminar
else
    echo "❌ Error en la compilación con Pandoc."
    exit 1
fi
