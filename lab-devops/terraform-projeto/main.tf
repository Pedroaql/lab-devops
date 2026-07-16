terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  host = "tcp://${var.infra_host}:2375"
}

module "site" {
  source         = "git::https://github.com/Pedroaql/lab-devops.git//terraform-modules/docker-nginx?ref=v1.0.0"
  container_name = "lab-nginx"
  external_port  = 8080
}

output "url" {
  value = module.site.url
}
