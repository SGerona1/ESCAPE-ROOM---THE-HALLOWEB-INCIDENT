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
