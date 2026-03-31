# Messprotokolle – BA IaC-Experiment

---

# Messprotokoll – Variante 1 (Manuell)
## Metadaten – Durchlauf 1
- Datum: 05.03.2026
- Durchlauf-Nr.: 1
- Region: Germany West Central

## 1. Zeitmessung
- Startzeit (Beginn der Arbeit): 20:15
- Endzeit (alle Ressourcen stehen + funktionsfähig): 21:00
- **Gesamtdauer: 45 Minuten**

## 2. Policy-Compliance (direkt nach Deployment)
| Policy                              | Status (Compliant/Non-Compliant) | Schweregrad |
|--------------------------------------|----------------------------------|-------------|
| Tag "Environment" vorhanden          | Compliant                        | Deny        |
| Tag "Owner" vorhanden                | Compliant                        | Deny        |
| NSG: Kein 0.0.0.0/0 auf RDP (3389)  | Compliant                        | Audit       |
| NSG: Linux-VM nur aus User-Subnet    | Compliant                        | Audit       |
| Keine Public IP auf Linux-VM NIC     | Compliant                        | Audit       |

## 3. Qualitative Beobachtungen
- Aufgetretene Fehler: Keine
- Notwendige Nacharbeiten: Keine
- Besonderheiten: Höchste Gesamtdauer der drei manuellen Durchläufe; Orientierung in den Portalmasken und Reihenfolge der Arbeitsschritte musste erarbeitet werden (Lerneffekt). Kein maschinenlesbares Konfigurationsartefakt erzeugt. SSH-Zugriff aus dem Internet auf Linux-VM schlug wie erwartet fehl. RDP-Verbindung zur Windows-VM erfolgreich.


---

# Messprotokoll – Variante 1 (Manuell)
## Metadaten – Durchlauf 2
- Datum: 10.03.2026
- Durchlauf-Nr.: 2
- Region: Germany West Central

## 1. Zeitmessung
- Startzeit (Beginn der Arbeit): 20:00
- Endzeit (alle Ressourcen stehen + funktionsfähig): 20:38
- **Gesamtdauer: 38 Minuten**


## 2. Policy-Compliance (direkt nach Deployment)
| Policy                              | Status (Compliant/Non-Compliant) | Schweregrad |
|--------------------------------------|----------------------------------|-------------|
| Tag "Environment" vorhanden          | Compliant                        | Deny        |
| Tag "Owner" vorhanden                | Compliant                        | Deny        |
| NSG: Kein 0.0.0.0/0 auf RDP (3389)  | Compliant                        | Audit       |
| NSG: Linux-VM nur aus User-Subnet    | Compliant                        | Audit       |
| Keine Public IP auf Linux-VM NIC     | Compliant                        | Audit       |

## 3. Qualitative Beobachtungen
- Aufgetretene Fehler: Keine
- Notwendige Nacharbeiten: Keine
- Besonderheiten: Zeitreduktion gegenüber Durchlauf 1 durch Lerneffekt (Reihenfolge und Portalnavigation bereits verinnerlicht). Namenskonventionen, Tags und Netzwerksegmentierung korrekt umgesetzt. SSH aus Internet auf Linux-VM blockiert. RDP-Verbindung erfolgreich.


---

# Messprotokoll – Variante 1 (Manuell)
## Metadaten – Durchlauf 3
- Datum: 12.03.2026
- Durchlauf-Nr.: 3
- Region: Germany West Central

## 1. Zeitmessung
- Startzeit (Beginn der Arbeit): 22:15
- Endzeit (alle Ressourcen stehen + funktionsfähig): 22:51
- **Gesamtdauer: 36 Minuten**

## 2. Policy-Compliance (direkt nach Deployment)
| Policy                              | Status (Compliant/Non-Compliant) | Schweregrad |
|--------------------------------------|----------------------------------|-------------|
| Tag "Environment" vorhanden          | Compliant                        | Deny        |
| Tag "Owner" vorhanden                | Compliant                        | Deny        |
| NSG: Kein 0.0.0.0/0 auf RDP (3389)  | Compliant                        | Audit       |
| NSG: Linux-VM nur aus User-Subnet    | Compliant                        | Audit       |
| Keine Public IP auf Linux-VM NIC     | Compliant                        | Audit       |

## 3. Qualitative Beobachtungen
- Aufgetretene Fehler: Keine
- Notwendige Nacharbeiten: Keine
- Besonderheiten: Kürzester manueller Durchlauf. Lerneffekt voll ausgeprägt. Alle Governance-Vorgaben eingehalten. Kein maschinenlesbares Konfigurationsartefakt vorhanden — Infrastruktur existiert nur im Azure-Portal, keine Versionierung oder automatisierte Reproduktion möglich.


---
