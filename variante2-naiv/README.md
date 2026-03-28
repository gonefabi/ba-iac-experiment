# Azure-Infrastruktur – Terraform

Kleine Produktionsumgebung mit Windows- und Linux-VM in Germany West Central.

## Architektur

```
Internet
   │
   │  RDP (3389) – nur von Firmen-IP
   ▼
┌──────────────────────────────────────────────────┐
│  vnet-firma  (10.0.0.0/16)                       │
│                                                  │
│  ┌─────────────────────┐  ┌────────────────────┐ │
│  │ snet-benutzer       │  │ snet-anwendung     │ │
│  │ 10.0.1.0/24         │  │ 10.0.2.0/24        │ │
│  │                     │  │                    │ │
│  │  ┌───────────────┐  │  │  ┌──────────────┐  │ │
│  │  │ Windows-VM    │──│──│─▶│ Linux-VM     │  │ │
│  │  │ (RDP, Public) │  │  │  │ (nur intern) │  │ │
│  │  └───────────────┘  │  │  └──────────────┘  │ │
│  └─────────────────────┘  └────────────────────┘ │
└──────────────────────────────────────────────────┘
```

## Firewall-Regeln

| Subnetz    | Richtung  | Regel                                       |
|------------|-----------|---------------------------------------------|
| Benutzer   | Eingehend | RDP (3389) nur von `allowed_rdp_source_ip`  |
| Benutzer   | Eingehend | Alles andere → Deny                         |
| Anwendung  | Eingehend | SSH (22) nur aus dem Benutzer-Subnetz        |
| Anwendung  | Eingehend | VNet-intern → Allow                         |
| Anwendung  | Eingehend | Alles andere → Deny                         |
| Anwendung  | Ausgehend | VNet-intern → Allow                         |
| Anwendung  | Ausgehend | Internet → **Deny**                         |

## Voraussetzungen

- Terraform ≥ 1.5
- Azure CLI (`az login` vor dem ersten Lauf)

## Verwendung

```bash
# 1. Beispiel-Variablen kopieren und anpassen
cp terraform.tfvars.example terraform.tfvars
#    → Passwörter und Firmen-IP eintragen

# 2. Initialisieren
terraform init

# 3. Plan prüfen
terraform plan

# 4. Anwenden
terraform apply

# 5. RDP-Verbindung herstellen
#    (Die öffentliche IP wird als Output angezeigt)
mstsc /v:<win_vm_public_ip>

# 6. Von der Windows-VM zur Linux-VM:
ssh azureadmin@<linux_vm_private_ip>
```

## Aufräumen

```bash
terraform destroy
```
