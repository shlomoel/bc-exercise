#!/bin/bash

#PreReq
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
#From here: 
# https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

#USAGE:
# start = runs terraform init + apply -var-file=variables.tfvars -auto-approve + starts docker and containers 
# stop = stops all containers status = shows containers 
# status destory = deletes all images and containers

#********Terminate*********
#use terminate func with caution since it deletes all local images and containers, not only cluster related

# Example command: ./nginx-cluster.sh start

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

# Function to Start Nginx Cluster with Nginx Load balancer
start_nginx() {
    terraform init
    terraform apply -var-file=variables.tfvars -auto-approve
    # docker start $(docker ps -a -q --filter="ancestor=nginx-web")
    # docker start $(docker ps -a -q --filter="ancestor=nginx-load-balancer")
}

# Stops Cluster
stop_nginx() {
    docker stop $(docker ps -a -q --filter="ancestor=nginx-web")
    docker stop $(docker ps -a -q --filter="ancestor=nginx-load-balancer")
}

# Check status of Cluster
status_nginx() {
    docker ps --filter="ancestor=nginx-web"
    docker ps --filter="ancestor=nginx-load-balancer"
}

# Terminates all local images & containers
terminate_nginx() {
    docker stop $(docker ps -a -q)
    docker system prune -a
 }

# Command Options to run from terminal
case $1 in
    start) start_nginx ;;
    stop) stop_nginx ;;
    status) status_nginx ;;
    terminate) terminate_nginx ;;
    *) echo "Usage: $0 {start|stop|status|terminate}"
esac
