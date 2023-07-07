# BeaconCure-exercise

This repo creates an X number of Nginx Web-servers behind an Nginx Load-Balancer using Docker containers to run locally on Ubuntu OS.

Requirments:
Terraform v1.5.2
on Ubuntu OS linux_amd64
Docker Engine
git - to clone this repo

Usage:
* Run from shell terminal nginx-cluster.sh using start|stop|status|destroy functions
* To change servers params go to variables.tfvars
* to check server static page:
  curl http://localhost:8080/
* To check Load balancer health endpoing
  curl http://localhost:8080/health
* Running start twice will restack the containers
* Round-Robin is set by default in the LoadBalancer

start = runs terraform init + apply -var-file=variables.tfvars -auto-approve + starts docker and containers
stop = stops all containers
status = shows containers status
destory = deletes all images and containers

****use destroy func with caution since it deletes all local images and containers, not only cluster related*** 

Example command:
./nginx-cluster.sh start

Notes for improvment:
* Add terraform providers locally
* Focus Destroy function only to fetch specific cluster
* Add auto scaling option in case server failure
