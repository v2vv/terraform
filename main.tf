
provider "null" {}

resource "null_resource" "install_docker" {
  provisioner "remote-exec" {
    inline = [
      "echo hello >  /tmp/output.txt"
      "cat /tmp/output.txt"
    ]

    connection {
      type        = "ssh"
      user        = "root"  # 修改为你目标主机的用户名
      password    = "${var.root_password}"
      host        = "${var.host}" # 修改为你的目标主机 IP 或域名
    }
  }
}
