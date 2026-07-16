# Setup do ambiente

## Pop!_OS (nó de infraestrutura)

```bash
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker $USER
newgrp docker
```

Habilitar API remota do Docker:

```bash
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo tee /etc/systemd/system/docker.service.d/override.conf <<'EOF'
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:2375
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
```

⚠️ Sem TLS — use apenas em rede local isolada, nunca em rede exposta à internet.

Subir o MinIO (state remoto):

```bash
docker run -d --name minio \
  -p 9000:9000 -p 9001:9001 \
  -e "MINIO_ROOT_USER=admin" \
  -e "MINIO_ROOT_PASSWORD=senha-forte-aqui" \
  -v /opt/minio-data:/data \
  minio/minio server /data --console-address ":9001"
```

Acesse `http://<IP_DO_POP_OS>:9001`, crie o bucket `terraform-state` e uma access key
dedicada.

## Windows (WSL2 — estação de controle)

```powershell
wsl --install -d Ubuntu-24.04
```

Dentro do WSL2:

```bash
sudo apt update && sudo apt upgrade -y

curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install -y terraform

pip install --user pre-commit checkov
curl -s https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install_linux.sh | sudo bash
```

## Variáveis de ambiente necessárias

```bash
export AWS_ACCESS_KEY_ID="<access key do minio>"
export AWS_SECRET_ACCESS_KEY="<secret key do minio>"
```

## Rodando

```bash
git clone https://github.com/Pedroaql/lab-devops.git
cd lab-devops
pre-commit install

cd terraform-projeto
terraform init
terraform plan
terraform apply
```
