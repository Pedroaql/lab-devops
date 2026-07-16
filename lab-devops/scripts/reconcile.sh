#!/bin/bash
# Reconciliador GitOps: garante que o ambiente real bate com o que está no Git.
# Roda via systemd timer no nó de infraestrutura (Pop!_OS), ou manualmente sob demanda.
set -e

cd "$(dirname "$0")/../terraform-projeto"

git pull origin main
terraform init -input=false
terraform apply -auto-approve -input=false
