#!/bin/bash

# 1. Rutas y Entorno
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(dirname "$SCRIPT_DIR")"
LOG_FILE="$BASE_DIR/pipeline.log"

# Limpiar log anterior
echo "--- INICIO DEL PIPELINE: $(date) ---" > "$LOG_FILE"

echo "🔥 [1/3] TRADUCCIÓN: Activando 6 workers en RX 7600 XT..." | tee -a "$LOG_FILE"
python3 "$SCRIPT_DIR/run_translation.py"
if [ $? -ne 0 ]; then echo "❌ FALLO EN TRADUCCIÓN"; exit 1; fi

echo "📚 [2/3] MAQUETACIÓN: Compilando PDF con el Ryzen 9..." | tee -a "$LOG_FILE"
# Buscamos el archivo generado (ajusta el nombre si es necesario)
bash "$SCRIPT_DIR/compilar_pdf.sh" "$BASE_DIR/output/libro_FINAL.md"
if [ $? -ne 0 ]; then echo "❌ FALLO EN COMPILACIÓN"; exit 1; fi

echo "📦 [3/3] EMPAQUETADO: Creando archivo .tar.gz y SHA256..." | tee -a "$LOG_FILE"
bash "$SCRIPT_DIR/convertir.sh"
if [ $? -ne 0 ]; then echo "❌ FALLO EN EMPAQUETADO"; exit 1; fi

echo "✅ PROCESO COMPLETADO EXITOSAMENTE" | tee -a "$LOG_FILE"
