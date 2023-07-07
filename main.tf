terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

variable "docker_image_version" {
  description = "Specify the version of the docker image here"
  type        = string
  default     = "latest"
}

variable "number_of_containers" {
  description = "Number of web-servers containers to create"
  type        = number
  default     = 3 # You can change the number of containers here
}

resource "docker_network" "default" {
  name = "nginx_network"
}

resource "local_file" "index_html" {
  count    = var.number_of_containers
  content  = templatefile("${path.module}/index.html.tpl", { server_name = "web${count.index + 1}" })
  filename = "${path.module}/nginx-content/web${count.index + 1}/index.html"
}

resource "local_file" "nginx_conf" {
  content  = templatefile("${path.module}/nginx.conf.tpl", { number_of_containers = var.number_of_containers })
  filename = "${path.module}/nginx-load-balancer/nginx.conf"
}

resource "docker_image" "nginx-web" {
  name = "nginx-web:${var.docker_image_version}"
  build {
    context = "./nginx-web"
  }
}

resource "docker_image" "nginx-load-balancer" {
  name = "nginx-load-balancer:${var.docker_image_version}"
  build {
    context = "./nginx-load-balancer"
  }
  depends_on = [local_file.nginx_conf]
}

resource "docker_container" "web" {
  count = var.number_of_containers
  image = docker_image.nginx-web.name
  name  = "web${count.index + 1}"

    networks_advanced {
    name = docker_network.default.name
  }
  env = [
    "SERVER_NAME=web${count.index + 1}"
  ]
    volumes {
    container_path  = "/usr/share/nginx/html"
    host_path       = abspath("${path.module}/nginx-content/web${count.index + 1}")
    read_only       = false
  }
}

resource "docker_container" "load_balancer" {
  image = docker_image.nginx-load-balancer.name
  name  = "load_balancer"
  tty = true
  logs = true

    networks_advanced {
    name = docker_network.default.name
  }

  ports {
    internal = 80
    external = 8080
  }
}

