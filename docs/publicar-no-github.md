# Do zero até publicado no GitHub

Este guia assume que você já tem a pasta `lab-devops/` no seu computador (baixada deste
chat) e quer transformá-la num repositório real no seu GitHub, do absoluto zero.

---

## 1. Criar o repositório no GitHub

1. Acesse [github.com/new](https://github.com/new)
2. Nome sugerido: `lab-devops` (ou, seguindo seu padrão de portfólio: `portfolio-homelab-devops`)
3. **Não marque** "Add a README" nem ".gitignore" — já temos os nossos
4. Visibilidade: público, se a ideia é usar como portfólio
5. Clique em "Create repository" e deixe a página aberta — o GitHub mostra os comandos
   de setup, mas vamos usar os daqui, que já incluem tudo.

## 2. Instalar e configurar o Git (se ainda não fez isso)

No terminal (WSL2 no Windows, ou Pop!_OS):

```bash
git --version
```

Se não tiver:

```bash
sudo apt install -y git
```

Configure sua identidade (só precisa fazer uma vez por máquina):

```bash
git config --global user.name "Pedro"
git config --global user.email "seu-email-do-github@exemplo.com"
```

## 3. Autenticação com o GitHub

O GitHub não aceita mais login por senha via linha de comando. Duas opções:

**Opção A — GitHub CLI (mais simples)**

```bash
# Instala o GitHub CLI
type -p curl >/dev/null || sudo apt install curl -y
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh -y

# Autentica (abre o navegador e pede confirmação)
gh auth login
```

Siga as perguntas: `GitHub.com` → `HTTPS` → `Login with a web browser`. Copie o código
mostrado no terminal, cole na página que abrir no navegador.

**Opção B — SSH (mais robusta a longo prazo)**

```bash
ssh-keygen -t ed25519 -C "seu-email-do-github@exemplo.com"
# Aperte Enter em todas as perguntas para usar os padrões
cat ~/.ssh/id_ed25519.pub
```

Copie a saída do `cat` e cole em GitHub → Settings → SSH and GPG keys → New SSH key.

## 4. Inicializar o repositório local

Dentro da pasta `lab-devops/`:

```bash
cd lab-devops
git init
git branch -M main
```

Confira o que será versionado (o `.gitignore` já está configurado para não subir state,
segredos e arquivos temporários do Terraform):

```bash
git status
```

## 5. Primeiro commit

```bash
git add .
git commit -m "chore: estrutura inicial do laboratório DevOps"
```

## 6. Conectar ao repositório remoto e enviar

**Se usou GitHub CLI (Opção A):**

```bash
git remote add origin https://github.com/Pedroaql/lab-devops.git
git push -u origin main
```

**Se usou SSH (Opção B):**

```bash
git remote add origin git@github.com:Pedroaql/lab-devops.git
git push -u origin main
```

Atualize a página do repositório no navegador — os arquivos devem aparecer.

## 7. Criar a tag do módulo Terraform

O `terraform-modules/docker-nginx` precisa de uma tag para ser consumido via `?ref=`:

```bash
git tag -a v1.0.0 -m "primeira versão estável do módulo docker-nginx"
git push origin v1.0.0
```

Confirme em GitHub → seu repositório → aba "Tags" que `v1.0.0` aparece.

## 8. Cadastrar os secrets do pipeline

Repositório no GitHub → **Settings → Secrets and variables → Actions → New repository
secret**:

- `MINIO_ACCESS_KEY` → a access key que você criou no MinIO
- `MINIO_SECRET_KEY` → a secret key correspondente

## 9. Registrar o runner self-hosted

Repositório → **Settings → Actions → Runners → New self-hosted runner** → Linux x64. O
GitHub mostra comandos com token temporário — execute no Pop!_OS. Depois de configurado,
rode sob demanda:

```bash
cd actions-runner
./run.sh
```

## 10. Ativar aprovação manual no ambiente de produção

Repositório → **Settings → Environments → New environment** → nome `production` →
marque "Required reviewers" e adicione seu próprio usuário. Isso faz o job `apply` do
pipeline esperar sua aprovação manual antes de rodar.

## 11. Testar o ciclo completo

Faça uma mudança pequena, por exemplo alterar `external_port` em
`terraform-projeto/main.tf`, e:

```bash
git checkout -b teste/mudanca-porta
git add .
git commit -m "test: altera porta exposta do container"
git push -u origin teste/mudanca-porta
```

Abra um Pull Request no GitHub da branch `teste/mudanca-porta` para `main`. O workflow
`plan` deve rodar automaticamente (com o runner ativo via `./run.sh`). Depois do merge,
o job `apply` vai pedir sua aprovação antes de aplicar.

## Checklist final

- [ ] Repositório criado e público (ou privado, se preferir)
- [ ] Primeiro commit e push feitos
- [ ] Tag `v1.0.0` do módulo criada
- [ ] Secrets `MINIO_ACCESS_KEY`/`MINIO_SECRET_KEY` cadastrados
- [ ] Runner self-hosted registrado
- [ ] Ambiente `production` com aprovação manual configurado
- [ ] Testou abrindo um PR e viu o `plan` rodar

A partir daqui, o repositório já é um item de portfólio real: mostra IaC modular, CI/CD
com controle, e prática de GitOps — não só teoria.
