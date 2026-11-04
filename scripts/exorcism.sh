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

echo -e "${YELLOW}[*] Analizando hosts infectados...${NC}"
echo ""

TOTAL=0
AISLADOS=0

# Leer el CSV saltando la cabecera
tail -n +2 "$CSV_FILE" | while IFS=',' read -r ip hostname amenaza severidad puerto; do

    # Limpiar espacios
    ip=$(echo "$ip" | xargs)
    hostname=$(echo "$hostname" | xargs)
    amenaza=$(echo "$amenaza" | xargs)
    severidad=$(echo "$severidad" | xargs)
    puerto=$(echo "$puerto" | xargs)

    TOTAL=$((TOTAL + 1))

    echo -e "${RED}[INFECTADO]${NC} $hostname ($ip)"
    echo "           Amenaza: $amenaza | Severidad: $severidad | Puerto: $puerto"

    # === LÓGICA DE AISLAMIENTO ===
    echo "  → Aislando host $ip ..."
    echo "$(date) - AISLADO: $ip ($hostname) - $amenaza" >> "$LOG_FILE"

    # Ejemplo de comando real (comentado por seguridad):
    # sudo iptables -A INPUT -s "$ip" -j DROP
    # sudo iptables -A OUTPUT -d "$ip" -j DROP

    AISLADOS=$((AISLADOS + 1))
    echo -e "  ${GREEN}[OK] Host aislado${NC}"
    echo ""

done

echo -e "${YELLOW}========================================${NC}"
echo -e "${GREEN}Proceso completado${NC}"
echo "Hosts procesados: $TOTAL"
echo "Log guardado en: $LOG_FILE"
echo -e "${YELLOW}========================================${NC}"