# Credenciais NÃO ficam aqui. São lidas via variáveis de ambiente:
#   export AWS_ACCESS_KEY_ID="<access key do minio>"
#   export AWS_SECRET_ACCESS_KEY="<secret key do minio>"

terraform {
  backend "s3" {
    bucket                      = "terraform-state"
    key                         = "lab/terraform.tfstate"
    region                      = "us-east-1"
    endpoint                    = "http://<IP_DO_POP_OS>:9000"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    force_path_style            = true
  }
}
