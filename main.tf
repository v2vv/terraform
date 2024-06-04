terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "null" {}

resource "null_resource" "install_docker" {
  provisioner "remote-exec" {
    inline = [
      "echo hello"
    ]

    connection {
      type        = "ssh"
      user        = "root"  # 修改为你目标主机的用户名
      password    = "${var.root_password}"
      host        = "${var.host}" # 修改为你的目标主机 IP 或域名
    }
  }
}

provider "docker" {
  host = "tcp://${var.host}:2375"  # 修改为你的目标主机的 Docker API 地址
}

resource "docker_image" "nginx" {
  name = "nginx:latest"
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.latest
  name  = "nginx"
  ports {
    internal = 80
    external = 80
  }
}
