# ============================================
# EXORCISM - Script de Aislamiento de Red
# Agent 2 - projecte/defense-script
# ============================================

$CsvFile = "data/ghost_hosts.csv"
$LogFile = "reports/exorcism_log.txt"

Write-Host "========================================" -ForegroundColor Yellow
Write-Host "   EXORCISM - Protocolo de Aislamiento  " -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Yellow
Write-Host ""

# Comprobar que existe el CSV
if (-not (Test-Path $CsvFile)) {
    Write-Host "[ERROR] No se encuentra el archivo $CsvFile" -ForegroundColor Red
    Write-Host "Esperando a que Agent 1 suba el diccionario de amenazas..."
    exit 1
}

Write-Host "[OK] Archivo de amenazas detectado: $CsvFile" -ForegroundColor Green
Write-Host ""

# Crear carpeta de reports si no existe
New-Item -ItemType Directory -Force -Path "reports" | Out-Null

# Cabecera del log
"=== EXORCISM LOG - $(Get-Date) ===" | Out-File -FilePath $LogFile

Write-Host "[*] Analizando hosts infectados..." -ForegroundColor Yellow
Write-Host ""

# Leer el CSV
$hosts = Import-Csv -Path $CsvFile

$Total = 0
$Aislados = 0

foreach ($host in $hosts) {
    $Total++

    $ip        = $host.IP
    $hostname  = $host.Hostname
    $amenaza   = $host.Amenaza
    $severidad = $host.Severidad
    $puerto    = $host.Port_Infectat   # Se usará más adelante con la Issue del profesor

    Write-Host "[INFECTADO] $hostname ($ip)" -ForegroundColor Red
    Write-Host "           Amenaza: $amenaza | Severidad: $severidad | Puerto: $puerto"

    # === LÓGICA DE AISLAMIENTO ===
    Write-Host "  → Aislando host $ip ..."
    "$(Get-Date) - AISLADO: $ip ($hostname) - $amenaza" | Out-File -FilePath $LogFile -Append

    # Ejemplo de comando real (comentado por seguridad):
    # New-NetFirewallRule -DisplayName "Block $ip" -Direction Inbound -RemoteAddress $ip -Action Block
    # New-NetFirewallRule -DisplayName "Block $ip Out" -Direction Outbound -RemoteAddress $ip -Action Block

    $Aislados++
    Write-Host "  [OK] Host aislado" -ForegroundColor Green
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Yellow
Write-Host "Proceso completado" -ForegroundColor Green
Write-Host "Hosts procesados: $Total"
Write-Host "Log guardado en: $LogFile"
Write-Host "========================================" -ForegroundColor Yellow