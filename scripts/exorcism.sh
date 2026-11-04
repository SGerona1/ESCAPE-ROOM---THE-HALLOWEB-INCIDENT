#!/bin/bash

# ============================================
# EXORCISM - Script de Aislamiento de Red
# Agent 2 - projecte/defense-script (hotfix/protocol-update)
# ============================================

CSV_FILE="data/ghost_hosts.csv"
LOG_FILE="reports/exorcism_log.txt"

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

echo -e "${YELLOW}[*] Analizando hosts y puertos infectados...${NC}"
echo ""

# Función para verificar si un puerto es crítico
# Puertos críticos de servicios o puertos reservados del sistema (<= 1024)
es_port_critic() {
    local p="$1"
    if [ -z "$p" ]; then
        return 1
    fi
    case "$p" in
        21|22|80|443|3306|8080)
            return 0
            ;;
        *)
            if [ "$p" -le 1024 ] 2>/dev/null; then
                return 0
            else
                return 1
            fi
            ;;
    esac
}

# Leer el CSV saltando la cabecera (ahora con 6 columnas: incluye port)
tail -n +2 "$CSV_FILE" | while IFS=',' read -r id ip nom nivell estat port; do

    # Limpiar espacios
    id=$(echo "$id" | xargs)
    ip=$(echo "$ip" | xargs)
    nom=$(echo "$nom" | xargs)
    nivell=$(echo "$nivell" | xargs)
    estat=$(echo "$estat" | xargs)
    port=$(echo "$port" | xargs)

    # Solo aislamos Infectat y Sospitos
    if [[ "$estat" == "Infectat" || "$estat" == "Sospitos" ]]; then
        # Comprobar la Issue del profesor: descartar puertos no críticos
        if es_port_critic "$port"; then
            echo -e "${RED}[AMENAZA CRÍTICA]${NC} $nom ($ip) - Nivel: $nivell - Estado: $estat - Puerto crítico: $port"
            echo "  → Aislando host $ip en puerto $port ..."
            echo "$(date) - AISLADO: $ip ($nom) - Nivel: $nivell - Puerto: $port" >> "$LOG_FILE"
            echo -e "  ${GREEN}[OK] Host aislado correctamente${NC}"
            echo ""
        else
            echo -e "${BLUE}[DESCARTADO]${NC} $nom ($ip) - Puerto: ${port:-Sin puerto} no es crítico → Descartado según protocolo"
            echo "$(date) - DESCARTADO: $ip ($nom) - Puerto: $port no crítico" >> "$LOG_FILE"
            echo ""
        fi
    else
        echo -e "${GREEN}[LIMPIO]${NC} $nom ($ip) - Estado: $estat → sin acción"
        echo ""
    fi

done

echo -e "${YELLOW}========================================${NC}"
echo -e "${GREEN}Proceso completado${NC}"
echo "Log guardado en: $LOG_FILE"
echo -e "${YELLOW}========================================${NC}"