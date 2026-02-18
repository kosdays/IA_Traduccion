#!/bin/bash

# 1. Definir rutas dinámicas basadas en la ubicación del script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(dirname "$SCRIPT_DIR")"
OUT_DIR="$BASE_DIR/output"
VERSION=$(date +%Y%m%d)

# 2. Identificar el PDF más reciente en la carpeta output
PDF_FILE=$(ls -t "$OUT_DIR"/*.pdf 2>/dev/null | head -n 1)

if [ -z "$PDF_FILE" ]; then
    echo "❌ ERROR: No se encontró ningún PDF en $OUT_DIR. Ejecuta primero compilar_pdf.sh."
    exit 1
fi

PDF_NAME=$(basename "$PDF_FILE")
ARCHIVE="Translation_Project_v$VERSION.tar.gz"

# 3. VALIDACIÓN DE INTEGRIDAD (Blindaje para Git)
# Definimos los archivos que DEBEN estar presentes para un bundle válido
FILES_TO_CHECK=(
    "$PDF_FILE"
    "$BASE_DIR/src/run_translation.py"
    "$BASE_DIR/config/Modelfile"
    "$BASE_DIR/config/metadata.yaml"
)

echo "🔍 Verificando integridad de los componentes..."
for f in "${FILES_TO_CHECK[@]}"; do
    if [ ! -f "$f" ]; then
        echo "❌ ERROR CRÍTICO: No se encuentra el archivo indispensable: $(basename "$f")"
        echo "Ruta fallida: $f"
        exit 1
    fi
done

echo ">>> Iniciando empaquetado del laboratorio..."
echo ">>> PDF detectado: $PDF_NAME"

# 4. Crear el paquete comprimido (.tar.gz)
# Usamos rutas absolutas con -C para asegurar que el contenido del tar sea limpio
tar -czvf "$BASE_DIR/$ARCHIVE" \
    -C "$OUT_DIR" "$PDF_NAME" \
    -C "$BASE_DIR/src" "run_translation.py" \
    -C "$BASE_DIR/config" "Modelfile" "metadata.yaml"

# 5. Generar Hash SHA256 para verificar la integridad del archivo
echo ">>> Generando Hash SHA256..."
sha256sum "$BASE_DIR/$ARCHIVE" > "$BASE_DIR/${ARCHIVE}.sha256"

echo "---------------------------------------------------"
echo "✅ ÉXITO: Paquete creado en la raíz del proyecto."
echo "📦 Archivo: $ARCHIVE"
echo "🔐 Checksum: ${ARCHIVE}.sha256"
echo "---------------------------------------------------"
