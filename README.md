# Docker + EC2 + Terraform Cloud Deployment

This project demonstrates how to:

- Build a Dockerized Flask application
- Push the image to Docker Hub
- Provision AWS infrastructure using Terraform
- Automatically deploy the container on EC2 using user_data

## Architecture

Internet
↓
EC2 (Amazon Linux 2023)
↓
Docker
↓
Flask container (port 5000)
↓
Exposed on port 80

## Tech Stack

- Python (Flask)
- Docker
- AWS EC2
- Terraform
- Docker Hub

## Deployment Steps

1. Build Docker image:
   docker build -t username/cloud-app:1.0 .

2. Push to Docker Hub:
   docker push username/cloud-app:1.0

3. Deploy infrastructure:
   terraform init
   terraform apply -var="docker_image=username/cloud-app:1.0"

4. Access application:
   http://EC2_PUBLIC_IP/

## What I Learned

- Infrastructure as Code (Terraform)
- Docker image lifecycle
- AWS networking basics (Security Groups, VPC)
- Automated cloud deployment using user_data