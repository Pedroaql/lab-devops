variable "container_name" {
  description = "Nome do container"
  type        = string
  default     = "lab-nginx"
}

variable "external_port" {
  description = "Porta externa exposta no host"
  type        = number
  default     = 8080
}
