# Escape Room Git – Forensic Software

## Equip
- Agent 1 (Admin/Dades): Sergi Gerona
- Agent 2 (Scripting/Lògica): Joan Osuna

## Bitàcola
### Fase 1

- [Agent 1] Creat el repositori i protegida la branca main.
- [Agent 1] Definit l'esquema de data/ghost_hosts.csv (contracte de dades amb l'Agent 2).


## Fase 1 - Agent 2 (Scripting/Lògica)

- He creado la rama `projecte/defense-script`
- He creado la estructura de carpetas `scripts/`
- He creado el esqueleto inicial del script de aislamiento: `scripts/exorcism.sh`
- El script está preparado para leer el archivo `data/ghost_hosts.csv`
- Pendiente: recibir el contrato de datos / estructura del CSV de Agent 1 para adaptar el script


### Fase 2
- [Agent 1] Simulada la branca infectada feature/nightmare-code (no l'havia creada el professor). Commit infectat: 96201c7.
- [Agent 1] L'script scripts/nightmare.sh desactiva el tallafocs, obre el port 6666 i envia dades a un servidor extern.
- [Agent 1] Branca aïllada: no s'integra a main. No cal revertir perquè el codi no ha arribat mai a main.
- [Agent 1] Afegida la columna Port_Infectat al CSV (branca hotfix/protocol-updtae). Issue tancada i tag v0.2-beta publicada.
### Fase 3
