import requests
import re
import os
import sys
from concurrent.futures import ThreadPoolExecutor

# CONFIGURACIÓN ABSOLUTA - NVMe 2TB
OLLAMA_URL = "http://localhost:11434/api/generate"
MODEL = "traductor_cyber"
BASE_DIR = "/home/kosdays/Proyectos/IA_Traduccion"

# CORRECCIÓN: El origen debe ser un archivo que realmente exista
INPUT_FILE = os.path.join(BASE_DIR, "output/libro_FINAL.md") # O el MD generado por convertir.sh
OUTPUT_FILE = os.path.join(BASE_DIR, "output/libro_TRADUCIDO.md")

SYSTEM_PROMPT = (
    "Eres un traductor técnico experto en ciberseguridad. "
    "Traduce al español neutro. NO traduzcas nombres de herramientas (nmap, metasploit), "
    "comandos de terminal, ni código. Mantén el formato Markdown intacto."
)

def traducir_segmento(segmento):
    if not segmento.strip() or len(segmento) < 3: return segmento
    
    payload = {
        "model": MODEL, 
        "system": SYSTEM_PROMPT,
        "prompt": segmento, 
        "stream": False,
        "options": {"num_predict": 4096, "temperature": 0} # Temperatura 0 para precisión técnica
    }
    
    try:
        response = requests.post(OLLAMA_URL, json=payload, timeout=300)
        return response.json().get('response', segmento)
    except Exception as e:
        return f"\n[ERROR]: {segmento}\n"

def main():
    if not os.path.exists(INPUT_FILE):
        print(f"FATAL: No existe {INPUT_FILE} en el directorio output."); sys.exit(1)

    with open(INPUT_FILE, "r", encoding="utf-8") as f:
        # Dividir por párrafos dobles para no perder contexto
        segmentos = [s.strip() for s in f.read().split('\n\n') if s.strip()]
    
    print(f"--- RYZEN 9 / RX 7600 XT PIPELINE ACTIVADO ---")
    print(f"Procesando {len(segmentos)} bloques de texto...")

    # Limpiamos el archivo de salida antes de empezar para evitar duplicados
    with open(OUTPUT_FILE, "w", encoding="utf-8") as f_out:
        pass

    with open(OUTPUT_FILE, "a", encoding="utf-8") as f_out:
        with ThreadPoolExecutor(max_workers=6) as executor:
            for i, resultado in enumerate(executor.map(traducir_segmento, segmentos)):
                f_out.write(resultado + "\n\n")
                if i % 5 == 0: # Flush estratégico cada 5 segmentos para no estresar el bus del NVMe
                    f_out.flush()
                    os.fsync(f_out.fileno())
                print(".", end="", flush=True) 

    print(f"\n¡ÉXITO! Resultado en: {OUTPUT_FILE}")

if __name__ == "__main__":
    main()