Lab DevOps — Terraform + GitOps + CI/CD no Homelab

Laboratório prático de DevOps rodando 100% em ambiente próprio (Pop!_OS), sem depender
de nuvem paga. Cobre o ciclo completo de infraestrutura como código: módulo Terraform
versionado no Git, state remoto, validação automática pré-commit, pipeline de CI/CD com
runner self-hosted, e testado de ponta a ponta com um Pull Request real.

Status: ciclo completo validado ✅

Este projeto não é só teoria — o fluxo abaixo foi executado e testado na prática:


Módulo Terraform criado e versionado com tag v1.0.0
Projeto principal consumindo o módulo via git::...?ref=v1.0.0
State remoto migrado para backend S3-compatible (MinIO)
Pre-commit hooks validando fmt, validate, trivy e checkov antes de cada commit
Runner self-hosted registrado e pipeline de CI/CD configurado no GitHub Actions
Pull Request de teste aberto → job plan executado automaticamente → merge → job
apply executado automaticamente → infraestrutura alterada de verdade


Arquitetura

┌───────────────────────────────────────────────┐
│                    Pop!_OS                    │
│                                               │
│  - Docker (com API remota habilitada)         │
│  - MinIO (backend S3 para state do Terraform) │
│  - GitHub Actions runner self-hosted          │
│  - Terraform, Git, pre-commit                 │
└───────────────────────────────────────────────┘

O que este repositório demonstra


IaC modular: infraestrutura definida em módulo Terraform próprio, versionado e
consumido via tag Git
State remoto: sem .tfstate local, backend S3-compatible via MinIO
Shift-left de segurança: trivy e checkov rodando antes de qualquer commit
chegar ao repositório, via pre-commit hooks
Exceção de segurança documentada: o módulo usa tag semântica (v1.0.0) em vez de
hash de commit fixo (CKV_TF_1), uma troca consciente entre legibilidade/manutenção e
segurança máxima — aceitável para este contexto, documentada explicitamente na
configuração do checkov em vez de ignorada silenciosamente
CI/CD real, testado com PR: plan automático em pull request, apply automático
após merge na main, rodando num runner self-hosted no próprio homelab
GitOps fora do Kubernetes: reconciliação possível via script + systemd timer
Docker vs Podman: comparação prática de isolamento e modelo rootless


Estrutura do repositório


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
│       └── terraform.yml       # pipeline de CI/CD (plan em PR, apply em merge)
├── docs/
│   ├── setup.md                # passo a passo de instalação e configuração
│   └── publicar-no-github.md   # tutorial de publicação do zero
├── .pre-commit-config.yaml
├── .gitignore
└── README.md

Pré-requisitos


Linux (testado em Pop!_OS) com Docker instalado
Terraform, Git e pre-commit
Conta no GitHub


Passo a passo completo de instalação em docs/setup.md.

Como usar

bashcd terraform-projeto
terraform init
terraform plan
terraform apply

Lições da implementação

Vale registrar: nenhuma etapa saiu perfeita na primeira tentativa, e isso faz parte do
processo real de DevOps. Entre os ajustes feitos durante a implementação:


Migração de tfsec (descontinuado) para trivy no pre-commit
Ajuste de sintaxe do backend S3 (endpoint → endpoints, force_path_style →
use_path_style) para compatibilidade com a versão atual do provider
Containers configurados com --restart unless-stopped após perceber que reinícios do
host derrubavam os serviços
Correção da ordem de eventos do pipeline: o workflow precisa existir na branch main
antes de um PR conseguir disparar os checks


Stack

Terraform · Docker · MinIO · GitHub Actions · pre-commit · Trivy · Checkov

Autor

Pedro — github.com/Pedroaql
