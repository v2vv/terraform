
provider "null" {}

resource "null_resource" "ru4n" {


  provisioner "remote-exec" {
    inline = [
      "mkdir -p /root/ansible"
    ]

    connection {
      type        = "ssh"
      user        = "root"  # 修改为你目标主机的用户名
      password    = "${var.root_password}"
      host        = "${var.host}" # 修改为你的目标主机 IP 或域名
    }
  }

  provisioner "file" {
    source      = "hosts"
    destination = "/root/ansible/hosts"

    connection {
      type        = "ssh"
      user        = "root"  # 修改为你目标主机的用户名
      password    = "${var.root_password}"
      host        = "${var.host}" # 修改为你的目标主机 IP 或域名
    }
  }

  provisioner "remote-exec" {
    inline = [
      "docker",
      "pwd",
      "ls"
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
