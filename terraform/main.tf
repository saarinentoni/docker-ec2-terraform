# ----------------------------
# Hae default VPC
# ----------------------------
data "aws_vpc" "default" {
  default = true
}

# ----------------------------
# Hae default subnetit
# ----------------------------
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# ----------------------------
# Hae uusin Amazon Linux 2023 AMI
# ----------------------------
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64*"]
  }
}

# ----------------------------
# Security Group (avaa HTTP 80)
# ----------------------------
resource "aws_security_group" "web_sg" {
  name        = "toni-web-sg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ----------------------------
# User data script (asentaa Dockerin ja ajaa containerin)
# ----------------------------
locals {
  user_data = <<-EOF
    #!/bin/bash
    set -euxo pipefail

    # Päivitä järjestelmä
    dnf update -y

    # Asenna Docker
    dnf install -y docker

    # Käynnistä Docker
    systemctl enable --now docker

    # Aja container
    docker run -d --restart=always -p 80:5000 ${var.docker_image}
  EOF
}

# ----------------------------
# EC2-instanssi
# ----------------------------
resource "aws_instance" "web" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = "t3.micro"
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = local.user_data

  tags = {
    Name = "toni-docker-web"
  }
}