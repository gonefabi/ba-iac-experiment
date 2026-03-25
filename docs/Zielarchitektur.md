Ressourcengruppe: rg-kmu-experiment
Region: Germany West Central (Frankfurt)
│
├── Virtual Network: vnet-kmu-main
│   Adressraum: 10.0.0.0/16
│   │
│   ├── Subnet: snet-user (10.0.1.0/24)
│   │   └── Windows VM: vm-kmu-jumpbox
│   │       - Größe: Standard_B2s
│   │       - OS: Windows Server 2022
│   │       - Public IP: Ja (für RDP-Zugriff)
│   │       - NSG: nsg-user
│   │           → Inbound: RDP (3389) nur von DEINER IP
│   │           → Outbound: Allow All
│   │
│   └── Subnet: snet-app (10.0.2.0/24)
│       └── Linux VM: vm-kmu-app
│           - Größe: Standard_B1s
│           - OS: Ubuntu 22.04 LTS
│           - Public IP: Nein
│           - NSG: nsg-app
│               → Inbound: SSH (22) + HTTP (80) nur aus 10.0.1.0/24
│               → Outbound: Allow All
│
├── Tags (auf ALLEN Ressourcen):
│   - Environment: "Development"
│   - Owner: "Fabian Klein"
│   - Project: "BA-IaC-Experiment"
│
└── Azure Policies (auf Ressourcengruppen-Ebene):
    - Require "Environment" Tag          → Effekt: Deny
    - Require "Owner" Tag                → Effekt: Deny
    - Audit: Keine Public IP auf App-VMs → Effekt: Audit
    - Audit: NSG-Regeln mit 0.0.0.0/0   → Effekt: Audit