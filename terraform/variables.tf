variable "aws_region" {
  type    = string
  default = "eu-north-1"
}

variable "docker_image" {
  type        = string
  description = "Docker image to run, e.g. username/cloud-app:1.0"
}