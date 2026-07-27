⚡ Kosdays Translation Pipeline (RDNA 3 / Ryzen 9)

Orquestador local de alto rendimiento para traducción y maquetación técnica automática en EndeavourOS.

🛠 Stack Tecnológico & Optimizaciones

    Engine: Ollama (16,384 tokens).

    Parallelism: 6 hilos concurrentes (RX 7600 XT - 16GB VRAM).

    Typography: Pandoc + XeLaTeX.

    Kernel Fix: HSA_OVERRIDE_GFX_VERSION=11.0.3 para RDNA 3.

📂 Arquitectura del Sistema

    src/: Motores de traducción y scripts de empaquetado (SHA256).

    config/: Plantillas metadata.yaml y Modelfile.

    docs/: Documentación técnica en Ryzen 9 5900X.

⚡ Ejecución Rápida
    
    ```bash
    # Preparar permisos:
    chmod +x src/*.sh
    
    # Lanzar Pipeline Maestro:
    ./src/auto_pipeline.sh
    ```

🛡️ Privacidad y Seguridad

    input/: Documentos originales protegidos (Locales).

    output/: Resultados finales excluidos del repositorio.

    temp/: Limpieza automática de logs y temporales.
    

⚖️ Auditoría de Ingeniería

    Integridad: Validación obligatoria mediante SHA256 para asegurar la consistencia de los paquetes generados.
