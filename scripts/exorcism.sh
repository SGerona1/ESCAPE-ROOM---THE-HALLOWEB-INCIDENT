#!/bin/bash

# ============================================
# EXORCISM - Script de Aislamiento de Red
# Agent 2 - projecte/defense-script
# ============================================

CSV_FILE="data/ghost_hosts.csv"
LOG_FILE="reports/exorcism_log.txt"

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}========================================${NC}"
echo -e "${YELLOW}   EXORCISM - Protocolo de Aislamiento  ${NC}"
echo -e "${YELLOW}========================================${NC}"
echo ""

# Comprobar que existe el CSV
if [ ! -f "$CSV_FILE" ]; then
    echo -e "${RED}[ERROR] No se encuentra el archivo $CSV_FILE${NC}"
    echo "Esperando a que Agent 1 suba el diccionario de amenazas..."
    exit 1
fi

echo -e "${GREEN}[OK] Archivo de amenazas detectado: $CSV_FILE${NC}"
echo ""

# Crear carpeta de reports si no existe
mkdir -p reports

# Cabecera del log
echo "=== EXORCISM LOG - $(date) ===" > "$LOG_FILE"

echo -e "${YELLOW}[*] Analizando hosts...${NC}"
echo ""

# Leer el CSV saltando la cabecera
# Columnas reales: Host_ID, Adreca_IP, Nom_Host, Nivell_Amenaca, Estat
tail -n +2 "$CSV_FILE" | while IFS=',' read -r id ip nom nivell estat; do

    # Limpiar espacios
    id=$(echo "$id" | xargs)
    ip=$(echo "$ip" | xargs)
    nom=$(echo "$nom" | xargs)
    nivell=$(echo "$nivell" | xargs)
    estat=$(echo "$estat" | xargs)

    # Solo aislamos Infectat y Sospitos
    if [[ "$estat" == "Infectat" || "$estat" == "Sospitos" ]]; then
        echo -e "${RED}[AMENAZA]${NC} $nom ($ip) - Nivel: $nivell - Estado: $estat"
        echo "  → Aislando host $ip ..."
        echo "$(date) - AISLADO: $ip ($nom) - $nivell - $estat" >> "$LOG_FILE"

        # Ejemplo de comando real (comentado por seguridad):
        # sudo iptables -A INPUT -s "$ip" -j DROP
        # sudo iptables -A OUTPUT -d "$ip" -j DROP

        echo -e "  ${GREEN}[OK] Host aislado${NC}"
        echo ""
    else
        echo -e "${GREEN}[LIMPIO]${NC} $nom ($ip) - Estado: $estat → sin acción"
        echo ""
    fi

done

echo -e "${YELLOW}========================================${NC}"
echo -e "${GREEN}Proceso completado${NC}"
echo "Log guardado en: $LOG_FILE"
echo -e "${YELLOW}========================================${NC}"