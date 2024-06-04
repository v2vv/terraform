
provider "null" {}

resource "null_resource" "alist" {


  provisioner "remote-exec" {
    inline = [
      "mkdir -p /root/alist"
    ]

    connection {
      type        = "ssh"
      user        = "root"  # 修改为你目标主机的用户名
      password    = "${var.root_password}"
      host        = "${var.host}" # 修改为你的目标主机 IP 或域名
    }
  }

  provisioner "file" {
    source      = "data.db"
    destination = "/root/alsit/data.db"
 
    connection {
      type        = "ssh"
      user        = "root"  # 修改为你目标主机的用户名
      password    = "${var.root_password}"
      host        = "${var.host}" # 修改为你的目标主机 IP 或域名
    }
  }

    provisioner "file" {
    source      = "config.json"
    destination = "/root/alist/config.json"

    connection {
      type        = "ssh"
      user        = "root"  # 修改为你目标主机的用户名
      password    = "${var.root_password}"
      host        = "${var.host}" # 修改为你的目标主机 IP 或域名
    }
  }


  provisioner "remote-exec" {
    inline = [
      <<EOF
      docker run -d --restart=always -v /media/U盘:/media/U盘 -v /root/alist:/opt/alist/data -p 5244:5244 -e PUID=0 -e PGID=0 -e UMASK=022 --name="alist" xhofe/alist:latest
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
