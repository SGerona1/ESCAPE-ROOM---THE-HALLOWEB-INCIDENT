# Matriu de Monitoratge – Halloweb Incident

| Host | IP | Amenaça | Estat | Port | Acció |
|---|---|---|---|---|---|
| srv-web-01 | 192.168.1.10 | Alt | Infectat | 3389 | 🔒 Aïllat |
| srv-db-02 | 192.168.1.22 | Mitja | Sospitós | 445 | 🔒 Aïllat |
| pc-admin-03 | 192.168.1.35 | Baix | Net | 8080 | ✅ Descartat |

**Ports crítics:** 22, 23, 445, 3389
**Elaborat per:** Agent 1 (dades) i Agent 2 (accions de l'script)