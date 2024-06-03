provider "null" {}

resource "null_resource" "install_docker" {
  provisioner "remote-exec" {
    inline = [
      "curl -fsSL https://get.docker.com -o get-docker.sh",
      "sudo sh get-docker.sh",
      "sudo usermod -aG docker $USER"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"  # 修改为你目标主机的用户名
      private_key = file("~/.ssh/my-key.pem")  # 修改为你的 SSH 私钥路径
      host        = "your-custom-host"  # 修改为你的目标主机 IP 或域名
    }
  }
}

provider "docker" {
  host = "tcp://your-custom-host:2375"  # 修改为你的目标主机的 Docker API 地址
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
