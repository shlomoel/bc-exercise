# BeaconCure-exercise

This repo creates an X number of Nginx Web-servers behind an Nginx Load-Balancer using Docker containers to run locally on Ubuntu OS.

Web server ports are opened incremenatly from 8080 

Requirments:

Terraform v1.5.2

on Ubuntu OS <22.04 linux_amd64

Docker Engine

git - to clone this repo

Usage:
* Execute from terminal nginx-cluster.sh using start|stop|status|terminate functions
* To change terraform params go to variables.tfvars
* Running start twice will rebuild the containers
* Round-Robin is set by default in the LoadBalancer

* To check server static page from Load Balancer:
  curl http://localhost

* To check Load balancer health endpoing:
  curl http://localhost:/health

* For web-servers(by port) curl http://localhost:8080/health.html



start = runs terraform init + apply -var-file=variables.tfvars -auto-approve + starts docker and containers

stop = stops all containers

status = shows containers status

terminate = deletes all images and containers

***use Terminate func with caution since it deletes all local images and containers, not only cluster related*** 

Example command:
./nginx-cluster.sh start

Notes for improvment:
* Pin terraform providers locally to be able to start offline
* Add Terraform Plan step before applying
* Focus Terminate function only to fetch specific cluster
* Add auto scaling option in case of server failure
* Add security and permissions for execution and Add TLS for HTTPS