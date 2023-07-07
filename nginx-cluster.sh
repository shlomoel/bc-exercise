#!/bin/bash

# # Update package list and upgrade all packages
# sudo apt-get update
# sudo apt-get upgrade -y

# # Install Git
# sudo apt-get install git -y

# # Install Docker
# sudo apt-get install docker.io -y
# sudo systemctl start docker
# sudo systemctl enable docker

# # Install Terraform
# wget https://releases.hashicorp.com/terraform/1.0.5/terraform_1.0.5_linux_amd64.zip
# unzip terraform_1.0.5_linux_amd64.zip
# sudo mv terraform /usr/local/bin/

# # Clone Terraform Configuration from GitHub
# git clone https://github.com/YOUR_GITHUB_USERNAME/YOUR_REPOSITORY.git
# cd YOUR_REPOSITORY

# # vars to pass to terraform
# export TF_VAR_docker_image_version=default
# export TF_VAR_number_of_containers=2


# environment tools validation:
	if ! command which docker &> /dev/null; then \
    echo "docker is not installed. Please install it first."; \
    exit 1; \
    fi
    if ! command which git &> /dev/null; then \
    echo "git is not installed. Please install it first."; \
    exit 1; \
    fi
    if ! command which terraform &> /dev/null; then \
    echo "terraform is not installed. Please install it first."; \
    exit 1; \
    fi
	if ! command docker info &> /dev/null; then \
		echo "docker is not running. Please make sure docker is running."; \
		exit 1; \
	fi

# Function to Start Nginx Cluster
start_nginx() {
    terraform init
    terraform apply -var-file=variables.tfvars -auto-approve
    docker start $(docker ps -a -q --filter="ancestor=nginx-web")
    docker start $(docker ps -a -q --filter="ancestor=nginx-load-balancer")
}

# Function to Stop Nginx Cluster
stop_nginx() {
    docker stop $(docker ps -a -q --filter="ancestor=nginx-web")
    docker stop $(docker ps -a -q --filter="ancestor=nginx-load-balancer")
}

# Function to check status of Nginx Cluster
status_nginx() {
    docker ps --filter="ancestor=nginx-web"
    docker ps --filter="ancestor=nginx-load-balancer"
}

destroy_nginx() {
    docker stop $(docker ps -a -q)
    docker system prune -a
 }

# Command Options to run from terminal
case $1 in
    start) start_nginx ;;
    stop) stop_nginx ;;
    status) status_nginx ;;
    destroy) destroy_nginx ;;
    *) echo "Usage: $0 {start|stop|status|destroy}"
esac
