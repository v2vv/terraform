
provider "null" {}

resource "null_resource" "docker install" {


  provisioner "remote-exec" {
    inline = [
      <<EOF
      apt-get update -y
      apt install curl -y
      curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
      docker -v
      EOF
    ]

    connection {
      type        = "ssh"
      user        = "root"  # 修改为你目标主机的用户名
      password    = "${var.root_password}"
      host        = "${var.host}" # 修改为你的目标主机 IP 或域名
    }
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}
