# Lab DevOps — Terraform + GitOps + CI/CD no Homelab

Laboratório prático de DevOps rodando 100% em ambiente próprio (Pop!_OS + Windows/WSL2),
sem depender de nuvem paga. Cobre o ciclo completo de infraestrutura como código: módulo
Terraform versionado no Git, state remoto, validação automática pré-commit, pipeline de
CI/CD com aprovação manual, e um loop de reconciliação estilo GitOps.

## Arquitetura

```
┌─────────────────────────┐         ┌──────────────────────────┐
│   Windows (WSL2)         │         │   Pop!_OS                 │
│   estação de controle    │ ------> │   nó de infraestrutura    │
│                           │  rede   │                            │
│  - Terraform              │  local  │  - Docker (API remota)    │
│  - Git                    │         │  - MinIO (state S3)       │
│  - pre-commit             │         │  - GitHub Actions runner  │
└─────────────────────────┘         └──────────────────────────┘
```

## O que este repositório demonstra

- **IaC modular**: infraestrutura definida em módulo Terraform próprio, versionado e
  consumido via tag Git (`git::...?ref=v1.0.0`)
- **State remoto**: sem `.tfstate` local, backend S3-compatible via MinIO
- **Shift-left de segurança**: `tfsec` e `checkov` rodando antes de qualquer commit chegar
  ao repositório, via pre-commit hooks
- **CI/CD com controle**: plan automático em pull request, apply em produção só após
  aprovação manual
- **GitOps fora do Kubernetes**: reconciliação automática entre o estado declarado no Git
  e o ambiente real, via `systemd timer`
- **Docker vs Podman**: comparação prática de isolamento e modelo rootless

## Estrutura do repositório

```
.
├── terraform-projeto/          # projeto principal que consome o módulo
│   ├── main.tf
│   ├── backend.tf
│   └── variables.tf
├── terraform-modules/          # módulos reutilizáveis (também publicados como tags)
│   └── docker-nginx/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── scripts/
│   └── reconcile.sh            # script de reconciliação GitOps
├── .github/
│   └── workflows/
│       └── terraform.yml       # pipeline de CI/CD
├── docs/
│   └── setup.md                # passo a passo de instalação e configuração
├── .pre-commit-config.yaml
├── .gitignore
└── README.md
```

## Pré-requisitos

- Pop!_OS (ou qualquer Linux) com Docker instalado
- Windows com WSL2 (Ubuntu) com Terraform, Git e pre-commit instalados
- Conta no GitHub

Passo a passo completo de instalação em [`docs/setup.md`](docs/setup.md).

## Como usar

```bash
cd terraform-projeto
terraform init
terraform plan
terraform apply
```

## Stack

Terraform · Docker · MinIO · GitHub Actions · pre-commit · tfsec · checkov · Podman

## Autor

Pedro — [github.com/Pedroaql](https://github.com/Pedroaql)
